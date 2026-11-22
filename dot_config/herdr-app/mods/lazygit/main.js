import { View, div } from "gpui-kit";
import { exec, hc, appHome, focused, machines, spaces, run, openOverlay, closeOverlay, notify, props, shared, setShared, readTextFile, window as app } from "herdr";
import {
  MOD_LABEL, MOD_NAME, REPO_LABEL, SPACE_LABEL,
  normalizeRoot, firstLine, findInstance, planCleanup, parseSettings, executableFor,
} from "./model.js";

const MEMORY = "__lazygit_float_v1";
const STATE_KEY = "lazygit.v1";
const LEASE_MS = 15000;

// Runner copies close after one toggle, so state that must outlive them lives here.
function memory() {
  return globalThis[MEMORY] ??= { dialog: null, lease: null };
}

async function claim(cx, owner) {
  const mem = memory();
  while (mem.lease && mem.lease.owner !== owner && Date.now() - mem.lease.at < LEASE_MS) await cx.sleep(15);
  mem.lease = { owner, at: Date.now() };
}

function release(owner) {
  const mem = memory();
  if (mem.lease?.owner === owner) mem.lease = null;
}

class Problem extends Error {
  constructor(level, title, body) {
    super(body);
    this.level = level;
    this.title = title;
  }
}

function coreError(result) {
  try { return JSON.parse(result.stderr).error.message; }
  catch { return result.stderr.trim() || `exit ${result.code}`; }
}

async function hcJSON(args, what) {
  const [command, ...rest] = args;
  const result = await hc([command, "--json", ...rest]);
  if (result.code !== 0) throw new Error(`${what}: ${coreError(result)}`);
  return JSON.parse(result.stdout);
}

async function listInstances() {
  const data = await hcJSON(["ls", "--label", `${MOD_LABEL}=${MOD_NAME}`], "List lazygit terminals");
  const details = await Promise.all((data.terminals ?? []).map(async t => {
    try {
      const info = await hcJSON(["get", t.address], "Read terminal");
      return { address: t.address, state: info.state ?? t.state, labels: info.labels ?? {} };
    } catch {
      return null;
    }
  }));
  return details.filter(Boolean);
}

function readHidden() {
  return shared(STATE_KEY)?.hiddenAt ?? {};
}

function writeHidden(hiddenAt) {
  if (JSON.stringify(hiddenAt) !== JSON.stringify(readHidden())) setShared(STATE_KEY, { hiddenAt });
}

function markHidden(address) {
  writeHidden({ ...readHidden(), [address]: Date.now() });
}

async function cleanup(terminals, keep) {
  const plan = planCleanup({
    terminals,
    spaceIds: spaces().map(s => s.id),
    readyMachines: machines().filter(m => m.layout === "ready").map(m => m.name),
    hiddenAt: readHidden(),
    keep,
    now: Date.now(),
  });
  writeHidden(plan.hiddenAt);
  await Promise.all(plan.kill.map(address => hc(["kill", address])));
}

function where(machine) {
  return machine ?? "this computer";
}

async function execOn(machine, command, args, missing) {
  try {
    return await exec(command, args, { on: machine });
  } catch {
    if (machine) throw new Problem("error", `${command} failed on ${machine}`, `Could not run ${command} on ${machine}. Is it installed, and is the machine online?`);
    throw missing;
  }
}

async function readSettings() {
  try {
    return parseSettings(await readTextFile(`${appHome()}/lazygit.json`));
  } catch (error) {
    throw new Problem("error", "lazygit settings", error.message);
  }
}

async function findLazygit(machine, localWindows) {
  const paths = memory().paths ??= {};
  const cached = paths[machine ?? ""];
  if (cached) return { path: cached, configured: false };
  const missing = new Problem("error", "lazygit not installed",
    `lazygit was not found on ${where(machine)}. Install it, or set its path in lazygit.json.`);
  const result = localWindows
    ? await execOn(machine, "where.exe", ["lazygit"], missing)
    : await execOn(machine, "sh", ["-c", "command -v lazygit"], missing);
  const path = result.code === 0 ? firstLine(result.stdout) : null;
  if (!path) throw missing;
  paths[machine ?? ""] = path;
  return { path, configured: false };
}

async function repoRoot(machine, cwd, lowercase) {
  const missing = new Problem("error", "git not installed", `git was not found on ${where(machine)}.`);
  const result = await execOn(machine, "git", ["-C", cwd, "rev-parse", "--show-toplevel"], missing);
  const raw = result.code === 0 ? firstLine(result.stdout) : null;
  if (!raw) throw new Problem("warning", "Not a git repo", `${cwd} is not inside a git repository.`);
  return { raw, key: normalizeRoot(raw, lowercase) };
}

async function locate() {
  const now = focused();
  const space = spaces().find(s => s.id === now?.space);
  if (!now || !space) throw new Problem("warning", "No active pane", "Focus a terminal pane and try again.");
  if (!now.cwd) throw new Problem("warning", "Folder unknown", "The active pane has no known folder.");
  const machine = space.machine;
  const localWindows = machine == null && app().platform === "windows";
  const [settings, root] = await Promise.all([readSettings(), repoRoot(machine, now.cwd, localWindows)]);
  return { space: space.id, machine, localWindows, settings, root, previousPane: now.pane };
}

async function chooseLazygit(target) {
  const configured = executableFor(target.settings, target.machine);
  return configured ? { path: configured, configured: true } : findLazygit(target.machine, target.localWindows);
}

async function start(target) {
  const result = await hc([
    "run", "--json", "--bg", "--rm", "--no-parent",
    ...(target.machine ? ["--on", target.machine] : []),
    "--cwd", target.root.raw,
    "--label", `${MOD_LABEL}=${MOD_NAME}`,
    "--label", `${REPO_LABEL}=${target.root.key}`,
    "--label", `${SPACE_LABEL}=${target.space}`,
    "--", target.lazygit.path,
  ]);
  if (result.code === 0) return JSON.parse(result.stdout).address;
  if (target.lazygit.configured) {
    throw new Problem("error", "lazygit did not start",
      `${target.lazygit.path} (set in lazygit.json) could not start: ${coreError(result)}`);
  }
  delete memory().paths?.[target.machine ?? ""];
  throw new Error(`Start lazygit: ${coreError(result)}`);
}

function dialogSpec(address) {
  return {
    kind: "dialog", width: 0.9, height: 0.9,
    layout: {
      type: "column",
      children: [
        { type: "block", size: { px: 0 }, content: { mod: MOD_NAME, props: { role: "sentinel", terminal: address } } },
        { type: "block", content: { terminal: address } },
      ],
    },
  };
}

function hide(dialog) {
  memory().dialog = null;
  closeOverlay(dialog.overlay);
  if (dialog.previousPane) run("pane.focus", { pane: dialog.previousPane });
}

function show(target, address) {
  const overlay = openOverlay(dialogSpec(address));
  memory().dialog = { overlay, terminal: address, previousPane: target.previousPane };
}

async function toggle() {
  const dialog = memory().dialog;
  if (dialog) {
    hide(dialog);
    await cleanup(await listInstances(), null);
    return;
  }
  const [terminals, located] = await Promise.all([
    listInstances(),
    locate().then(target => ({ target }), problem => ({ problem })),
  ]);
  const { target, problem } = located;
  if (problem) {
    await cleanup(terminals, null);
    throw problem;
  }
  const existing = findInstance(terminals, target.root.key, target.space);
  const address = existing?.address ?? await start({ ...target, lazygit: await chooseLazygit(target) });
  show(target, address);
  await cleanup(terminals, address);
}

async function runToggle(owner, cx) {
  try {
    await claim(cx, owner);
    await toggle();
  } catch (error) {
    const isProblem = error instanceof Problem;
    notify({
      title: isProblem ? error.title : "lazygit",
      body: String(error?.message ?? error),
      level: isProblem ? error.level : "error",
    });
  } finally {
    release(owner);
    closeOverlay(owner);
  }
}

export default class Lazygit extends View {
  init(_props, cx) {
    this.copy = props() ?? {};
    if (this.copy.role === "sentinel") return;
    const owner = this.copy.overlay;
    if (owner) cx.spawn(cx => runToggle(owner, cx));
  }

  // The dialog also closes on a click outside or a layout switch; this keeps the toggle state true.
  async close() {
    if (this.copy.role !== "sentinel") {
      // A second mod.open closes a busy runner; its finally may never run.
      if (this.copy.overlay) release(this.copy.overlay);
      return;
    }
    const mem = memory();
    if (mem.dialog?.overlay === this.copy.overlay) mem.dialog = null;
    markHidden(this.copy.terminal);
  }

  render() {
    return div();
  }
}
