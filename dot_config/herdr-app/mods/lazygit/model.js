export const MOD_LABEL = "herdr.mod";
export const MOD_NAME = "lazygit";
export const REPO_LABEL = "lazygit.repo";
export const SPACE_LABEL = "lazygit.space";
export const HERDR_SPACE_LABEL = "herdr.space";
export const IDLE_LIMIT_MS = 30 * 60 * 1000;

export function normalizeRoot(path, lowercase) {
  let root = path.trim().replace(/\\/g, "/");
  while (root.length > 1 && root.endsWith("/") && !/^[A-Za-z]:\/$/.test(root)) root = root.slice(0, -1);
  return lowercase ? root.toLowerCase() : root;
}

export function firstLine(text) {
  return text.split(/\r?\n/).map(line => line.trim()).find(Boolean) ?? null;
}

export function machineOf(address) {
  const slash = address.indexOf("/");
  return slash === -1 ? null : address.slice(0, slash);
}

function isOwnedLive(terminal) {
  const labels = terminal.labels ?? {};
  return terminal.state === "live" && labels[MOD_LABEL] === MOD_NAME && labels[HERDR_SPACE_LABEL] == null;
}

export function findInstance(terminals, repo, space) {
  return terminals.find(t => isOwnedLive(t) && t.labels[REPO_LABEL] === repo && t.labels[SPACE_LABEL] === space) ?? null;
}

export function planCleanup({ terminals, spaceIds, readyMachines, hiddenAt, keep, now }) {
  const spaces = new Set(spaceIds);
  const ready = new Set(readyMachines);
  const kill = [];
  const next = {};
  for (const terminal of terminals.filter(isOwnedLive)) {
    const { address } = terminal;
    if (!ready.has(machineOf(address))) {
      if (hiddenAt[address] != null) next[address] = hiddenAt[address];
    } else if (spaces.size > 0 && !spaces.has(terminal.labels[SPACE_LABEL])) {
      kill.push(address);
    } else if (address === keep) {
      continue;
    } else if (hiddenAt[address] == null) {
      next[address] = now;
    } else if (now - hiddenAt[address] >= IDLE_LIMIT_MS) {
      kill.push(address);
    } else {
      next[address] = hiddenAt[address];
    }
  }
  return { kill, hiddenAt: next };
}

export function parseSettings(text) {
  if (text == null || text.trim() === "") return {};
  let settings;
  try {
    settings = JSON.parse(text);
  } catch {
    throw new Error("lazygit.json is not valid JSON.");
  }
  if (typeof settings !== "object" || settings === null || Array.isArray(settings)) {
    throw new Error("lazygit.json must contain a JSON object.");
  }
  if (settings.path != null && typeof settings.path !== "string") {
    throw new Error('lazygit.json: "path" must be a string.');
  }
  const machines = settings.machines ?? {};
  if (typeof machines !== "object" || machines === null || Array.isArray(machines)
    || Object.values(machines).some(value => typeof value !== "string")) {
    throw new Error('lazygit.json: "machines" must map machine names to paths.');
  }
  return { path: settings.path ?? null, machines };
}

export function executableFor(settings, machine) {
  const configured = machine == null ? settings.path : settings.machines?.[machine];
  return configured?.trim() || null;
}
