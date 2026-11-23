// LazyVim's start screen for Herdr: snacks.dashboard as a dialog over the shell. The
// lualine opens it at app start and on each new space; <leader>D and the cmdline too.
// The logo, the keys, a footer. Like snacks, it goes as soon as you do anything:
// a key runs its action and closes, any other key, Esc or a click beside it closes.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { spaces, agents, run, theme, home, props, openOverlay, closeOverlay } from "herdr";

// LazyVim's ANSI Shadow logo, spelling HERDR, with its zzz.
const LOGO = [
  "██╗  ██╗███████╗██████╗ ██████╗ ██████╗           Z",
  "██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗      Z    ",
  "███████║█████╗  ██████╔╝██║  ██║██████╔╝   z       ",
  "██╔══██║██╔══╝  ██╔══██╗██║  ██║██╔══██╗ z         ",
  "██║  ██║███████╗██║  ██║██████╔╝██║  ██║           ",
  "╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝           ",
];

const picker = (props) => () => openOverlay({ mod: "lazyvim-picker", kind: "dialog", width: 0.92, height: 0.86, frame: "none", props });
const folder = () => spaces().find((s) => s.active)?.folder || home();

// snacks' keys, mapped onto Herdr. [key, icon, desc, action]
const KEYS = [
  ["f", "\u{F0349}", "Find File", () => picker({ root: folder() })()],
  ["n", "\u{F0224}", "New Tab", () => run("tab.new")],
  ["g", "\u{F04E9}", "Go to", picker({ source: "goto" })],
  ["c", "\u{F013}", "Config", () => picker({ root: `${home()}/.config/herdr-app` })()],
  ["l", "\u{F0E58}", "Lazy", () => run("mod.open", { name: "lazyvim-lazy" })],
  ["q", "\u{F0156}", "Close", () => null],
];

export default class Dashboard extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
  }

  // Close first: what an action opens goes over the window, not under this dialog.
  go(act) {
    closeOverlay(props().overlay);
    act();
  }

  render() {
    const t = theme();
    const all = spaces();
    const tabs = all.reduce((n, s) => n + s.tabs.length, 0);
    const working = agents().filter((a) => a.status === "working").length;
    const n = (k, word) => `${k} ${word}${k === 1 ? "" : "s"}`;
    // tokyonight's snacks colors: header blue, icons and descs cyan, keys in the warm one.
    const row = ([k, icon, desc, act]) => h_flex().id(`db-${k}`).w(420).h(30).px(8).gap(12).items_center().rounded(4).cursor_pointer()
      .hover((s) => s.bg(t.hover))
      .on_click(() => this.go(act))
      .child(div().w(18).flex_none().text_color(t.ansi6).child(icon))
      .child(div().flex_1().text_color(t.ansi6).child(desc))
      .child(div().flex_none().text_color(t.ansi3).font_bold().child(k));
    return v_flex().id("dashboard").size_full().items_center().justify_center().gap(28)
      .rounded(8).border_1().border_color(t.accent).bg(t.background).text_size(13)
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        cx.stop_propagation();
        if (["shift", "control", "alt", "platform", "function"].includes(e.key)) return;
        const m = e.modifiers ?? {};
        const hit = !(m.control || m.alt || m.platform) && KEYS.find(([k]) => k === e.key);
        this.go(hit ? hit[3] : () => null);
      })
      .child(v_flex().text_color(t.ansi4).text_size(14).children(LOGO.map((l) => div().h(17).whitespace_nowrap().child(l))))
      .child(v_flex().gap(2).children(KEYS.map(row)))
      .child(div().text_color(t.ansi6).child(
        `\u{26A1} Herdr: ${n(all.length, "space")} \u{00B7} ${n(tabs, "tab")} \u{00B7} ${n(working, "agent")} working`));
  }
}
