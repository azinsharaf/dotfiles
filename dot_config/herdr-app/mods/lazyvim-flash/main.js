// flash.nvim for Herdr: jump labels. Mods can't see where panes are drawn, so this
// invisible popup only takes the keys: it hands out a label per target in
// shared("lazyvim.flash") = { id: letter }, and the lazyvim mod draws them where the
// targets are (winbars, buffers, tabpages). A label jumps there; anything else closes.

import { View, div } from "gpui-kit";
import { panes, spaces, run, props, closeOverlay, setShared } from "herdr";

// flash's default labels.
const LABELS = "asdfghjklqwertyuiopzxcvbnm";

// Panes of the shown tab, then its space's tabs, then the spaces: [id, command, args].
function targets() {
  const space = spaces().find((s) => s.active);
  const tab = space?.tabs.find((t) => t.active);
  return [
    ...panes().filter((p) => p.tab === tab?.id).map((p) => [p.pane, "pane.focus", { pane: p.pane }]),
    ...(space?.tabs ?? []).map((t) => [t.id, "tab.select", { id: t.id }]),
    ...spaces().map((s) => [s.id, "space.select", { id: s.id }]),
  ].slice(0, LABELS.length);
}

export default class Flash extends View {
  init(_props, cx) {
    this.targets = targets().map((t, i) => [LABELS[i], ...t]);
    setShared("lazyvim.flash", Object.fromEntries(this.targets.map(([k, id]) => [id, k])));
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
  }

  // Herdr calls this however the overlay goes.
  async close() {
    setShared("lazyvim.flash", null);
  }

  render() {
    return div().id("flash").size_full().track_focus(this.handle)
      .on_key_down((e, cx) => {
        cx.stop_propagation();
        if (["shift", "control", "alt", "platform", "function"].includes(e.key)) return;
        const m = e.modifiers ?? {};
        const hit = !(m.control || m.alt || m.platform) && this.targets.find(([k]) => k === e.key);
        closeOverlay(props().overlay);
        if (hit) run(hit[2], hit[3]);
      });
  }
}
