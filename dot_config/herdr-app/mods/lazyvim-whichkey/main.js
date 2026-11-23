// LazyVim's <leader> for Herdr: which-key's helix popup, bottom right. Herdr has no
// key chords, so the leader (ctrl-space in keys.json) opens this popup and it takes
// the next keys itself: a group key goes one level down, backspace one up, any other
// key runs its command and closes. Esc, the leader again or an unbound key closes.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { commands, run, theme, props, openOverlay, closeOverlay } from "herdr";

const ROW_H = 22;
const BOX_W = 340;

const open = (mod, more = {}) => () => openOverlay({ mod, kind: "dialog", width: 0.92, height: 0.86, frame: "none", ...more });
const goto = open("lazyvim-picker", { props: { source: "goto" } });
const files = open("lazyvim-picker");
const cmd = (name, args = {}) => ({ name, args });

// LazyVim's leader keymaps, mapped onto Herdr: buffers are tabs, tabpages are spaces.
// [key, desc, icon, action]: action is a command, a function, or a group { [key]: ... }.
const SPEC = [
  [" ", "Find Files", "\u{F0349}", files],
  [",", "Switch Buffer", "\u{F04E9}", goto],
  [":", "Cmdline", "\u{F489}", cmd("mod.open", { name: "lazyvim-cmdline" })],
  ["e", "Explorer", "\u{F0645}", cmd("layout.toggle", { id: "sidebar" })],
  ["?", "Keymaps", "\u{F030C}", cmd("app.help")],
  ["D", "Dashboard", "\u{F0570}", cmd("mod.open", { name: "lazyvim-dashboard" })],
  ["l", "Lazy (mods)", "\u{F0E58}", cmd("mod.open", { name: "lazyvim-lazy" })],
  ["j", "Jump (flash)", "\u{F0E7}", cmd("mod.open", { name: "lazyvim-flash" })],
  ["f", "file/find", "\u{F0214}", [
    ["f", "Find Files", "\u{F0349}", files],
    ["b", "Buffers", "\u{F04E9}", goto],
    ["n", "New File", "\u{F0224}", cmd("tab.new")],
    ["t", "Terminal", "\u{F489}", cmd("terminal.open")],
  ]],
  ["b", "buffer", "\u{F04E9}", [
    ["b", "Switch Buffer", "\u{F04E9}", goto],
    ["d", "Delete Buffer", "\u{F01B4}", cmd("tab.close")],
    ["r", "Rename Buffer", "\u{F03EB}", cmd("tab.rename")],
    ["n", "Next Buffer", "\u{F0142}", cmd("tab.next")],
    ["p", "Prev Buffer", "\u{F0141}", cmd("tab.prev")],
  ]],
  ["w", "windows", "\u{F05B2}", [
    ["-", "Split Window Below", "\u{F0E5E}", cmd("pane.split", { direction: "down" })],
    ["|", "Split Window Right", "\u{F0E5E}", cmd("pane.split", { direction: "right" })],
    ["d", "Delete Window", "\u{F01B4}", cmd("pane.close")],
    ["m", "Toggle Zoom", "\u{F0293}", cmd("pane.zoom")],
    ["h", "Go Left", "\u{F004D}", cmd("pane.go", { direction: "left" })],
    ["j", "Go Down", "\u{F0045}", cmd("pane.go", { direction: "down" })],
    ["k", "Go Up", "\u{F005D}", cmd("pane.go", { direction: "up" })],
    ["l", "Go Right", "\u{F0054}", cmd("pane.go", { direction: "right" })],
    ["H", "Swap Left", "\u{F04E1}", cmd("pane.swap", { direction: "left" })],
    ["J", "Swap Down", "\u{F04E1}", cmd("pane.swap", { direction: "down" })],
    ["K", "Swap Up", "\u{F04E1}", cmd("pane.swap", { direction: "up" })],
    ["L", "Swap Right", "\u{F04E1}", cmd("pane.swap", { direction: "right" })],
  ]],
  ["\t", "tabs", "\u{F04E9}", [
    ["\t", "New Tab", "\u{F0415}", cmd("space.new")],
    ["]", "Next Tab", "\u{F0142}", cmd("space.next")],
    ["[", "Previous Tab", "\u{F0141}", cmd("space.prev")],
    ["d", "Close Tab", "\u{F01B4}", cmd("space.close")],
    ["r", "Rename Tab", "\u{F03EB}", cmd("space.rename")],
  ]],
  ["a", "agents", "\u{F06A9}", [
    ["i", "Inbox (answer)", "\u{F02FA}", cmd("mod.open", { name: "lazyvim-inbox" })],
    ["s", "Send Context", "\u{F0552}", cmd("mod.open", { name: "lazyvim-context" })],
    ["n", "Next Agent", "\u{F0142}", cmd("agent.next")],
    ["p", "Previous Agent", "\u{F0141}", cmd("agent.prev")],
  ]],
  ["u", "ui", "\u{F0E09}", [
    ["l", "Next Layout", "\u{F0E58}", cmd("layout.switch")],
    ["s", "Settings", "\u{F013}", cmd("app.settings")],
    ["+", "Zoom In", "\u{F0349}", cmd("app.zoom_in")],
    ["-", "Zoom Out", "\u{F0349}", cmd("app.zoom_out")],
    ["=", "Reset Zoom", "\u{F0349}", cmd("app.zoom_reset")],
  ]],
  ["q", "quit/session", "\u{F0450}", [
    ["q", "Quit All", "\u{F0450}", cmd("app.quit")],
  ]],
];

// which-key's names for keys that don't print.
const NAME = { " ": "\u{F1050}", "\t": "\u{F0312}" };
const show = (k) => NAME[k] ?? k;
const isGroup = (a) => Array.isArray(a);

// which-key's sort: plain mappings first, then groups, each alphanumeric.
function sorted(level) {
  return [...level].sort((a, b) => isGroup(a[3]) - isGroup(b[3]) || a[0].localeCompare(b[0]));
}

export default class WhichKey extends View {
  init(_props, cx) {
    this.path = []; // the group keys pressed so far
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  level() {
    let level = SPEC;
    for (const k of this.path) level = level.find((m) => m[0] === k)[3];
    // Hide what this Herdr doesn't have.
    const known = new Set(commands().map((c) => c.name));
    return level.filter(([, , , a]) => typeof a === "function" || isGroup(a) || known.has(a.name));
  }

  press(k, cx) {
    const m = this.level().find((e) => e[0] === k);
    if (!m) return this.dismiss();
    const a = m[3];
    if (isGroup(a)) {
      this.path.push(k);
      return cx.notify();
    }
    this.dismiss();
    if (typeof a === "function") a();
    else run(a.name, a.args);
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers ?? {};
    if (e.key === "escape" || (e.key === "space" && m.control)) return this.dismiss();
    if (e.key === "backspace") {
      if (!this.path.length) return this.dismiss();
      this.path.pop();
      return cx.notify();
    }
    if (m.control || m.alt || m.platform) return this.dismiss();
    const k = e.key === "space" ? " " : e.key === "tab" ? "\t" : (e.key_char ?? (m.shift && e.key.length === 1 ? e.key.toUpperCase() : e.key));
    this.press(k, cx);
  }

  render() {
    const t = theme();
    const rows = sorted(this.level());
    const title = ["<leader>", ...this.path.map(show)].join(" ");
    // Tokyonight's which-key colors: keys cyan, separator comment, groups blue, descs magenta.
    const row = ([k, desc, icon, a]) => h_flex().id(`wk-${k}`).h(ROW_H).px(10).gap(8).items_center().cursor_pointer()
      .hover((s) => s.bg(t.hover))
      .on_click((_e, cx) => this.press(k, cx))
      .child(div().w(18).flex_none().text_color(t.ansi6).child(show(k)))
      .child(div().flex_none().text_color(t.dim).child("\u{279C}"))
      .child(div().w(16).flex_none().text_color(isGroup(a) ? t.ansi4 : t.ansi5).child(icon))
      .child(div().flex_1().min_w(0).truncate().text_color(isGroup(a) ? t.ansi4 : t.ansi5)
        .child(isGroup(a) ? `+${desc}` : desc));
    // The title is cut into the top border, outside the rounded box so it isn't clipped.
    const box = div().id("wk-box").relative().flex_none().pt(8)
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .child(v_flex().w(BOX_W).pt(10).pb(6).rounded(6).border_1().border_color(t.accent).bg(t.background)
        .children(rows.map(row))
        .child(h_flex().mt(4).px(10).gap(12).text_size(11).text_color(t.dim)
          .child(h_flex().gap(4).child(div().text_color(t.ansi6).child("esc")).child("close"))
          .when(this.path.length > 0, (el) => el.child(h_flex().gap(4).child(div().text_color(t.ansi6).child("bs")).child("back")))))
      .child(div().absolute().top(0).left(12).px(4).bg(t.background).text_size(11.5).text_color(t.accent).child(title));
    // The popup fills the window; only the box shows, above the 24px lualine. A press beside it closes.
    return v_flex().id("whichkey").size_full().justify_end().items_end().pr(8).pb(32).text_size(12.5)
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .on_mouse_down("left", () => this.dismiss())
      .child(box);
  }
}
