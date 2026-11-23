// yazi in a floating dialog, toggled by `mod.open:yazi`. Starts in the focused
// pane's folder; closing the dialog (or quitting yazi) ends the terminal.
import { View, div } from "gpui-kit";
import { hc, focused, spaces, run, openOverlay, closeOverlay, notify, props } from "herdr";

const MEMORY = "__yazi_float_v1";
const memory = () => (globalThis[MEMORY] ??= { dialog: null });

function dialogSpec(address) {
  return {
    kind: "dialog", width: 0.9, height: 0.9,
    layout: {
      type: "column",
      children: [
        { type: "block", size: { px: 0 }, content: { mod: "yazi", props: { role: "sentinel", terminal: address } } },
        { type: "block", content: { terminal: address } },
      ],
    },
  };
}

function hide(dialog) {
  memory().dialog = null;
  closeOverlay(dialog.overlay);
  hc(["kill", dialog.terminal]);
  if (dialog.previousPane) run("pane.focus", { pane: dialog.previousPane });
}

async function toggle() {
  const open = memory().dialog;
  if (open) return hide(open);
  const now = focused();
  const space = spaces().find(s => s.id === now?.space);
  if (!now || !space) throw new Error("Focus a terminal pane and try again.");
  const result = await hc([
    "run", "--json", "--bg", "--rm", "--no-parent",
    ...(space.machine ? ["--on", space.machine] : []),
    ...(now.cwd ? ["--cwd", now.cwd] : []),
    "--label", "herdr.mod=yazi",
    "--", "yazi",
  ]);
  if (result.code !== 0) throw new Error(result.stderr.trim() || `exit ${result.code}`);
  const address = JSON.parse(result.stdout).address;
  const overlay = openOverlay(dialogSpec(address));
  memory().dialog = { overlay, terminal: address, previousPane: now.pane };
}

export default class Yazi extends View {
  init(_props, cx) {
    this.copy = props() ?? {};
    if (this.copy.role === "sentinel" || !this.copy.overlay) return;
    const owner = this.copy.overlay;
    cx.spawn(async () => {
      try { await toggle(); }
      catch (e) { notify({ title: "yazi", body: String(e?.message ?? e), level: "error" }); }
      finally { closeOverlay(owner); }
    });
  }

  // Dialog closed by a click outside, a layout switch or yazi quitting.
  async close() {
    if (this.copy.role !== "sentinel") return;
    const mem = memory();
    if (mem.dialog?.overlay === this.copy.overlay) mem.dialog = null;
    hc(["kill", this.copy.terminal]);
  }

  render() { return div(); }
}
