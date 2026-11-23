// LazyVim's `:` for Herdr: noice's cmdline popup over a blink completion menu.
// A restyled copy of Herdr's omarchy-palette (same entries, fuzzy and recent),
// bound to cmd-shift-p in the lazyvim layout (keys.json). While it's open,
// shared("lazyvim.cmdline") is true and the lualine shows COMMAND.
// "Duplicate mod" stays in this popup (a name to type) instead of opening
// Herdr's prompt, like noice restyles vim.ui.input; "Go to…" opens the
// lazyvim-picker on its goto source instead of Herdr's picker.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { commands, layouts, keys, run, theme, props, openOverlay, closeOverlay, shared, setShared, window as win } from "herdr";

const SHOWN = 10;
const ROW_H = 24;
// Blink's kind icons, one per group, each in its own color like blink's kinds;
// spaces are blue folders as in the explorer.
const KIND = {
  Tab: ["\u{F04E9}", "ansi2"], Pane: ["\u{F0E5E}", "ansi6"], Space: ["\u{F024B}", "ansi4"], Layout: ["\u{F0E58}", "ansi5"],
  Terminal: ["\u{F489}", "ansi2"], Agent: ["\u{F06A9}", "ansi4"], Window: ["\u{F05B6}", "ansi6"], App: ["\u{F013}", "ansi3"],
};
// The box's title and chevron per mode: commands, a name to type.
const HEAD = { cmdline: ["Cmdline", "\u{F054}"], input: [null, "\u{F03EB}"] };

// The palette's names for commands: [command, args, group, title, keywords].
const NAMED = [
  ["tab.new", {}, "Tab", "New tab", "tab agent new task"],
  ["mod.open", { name: "picker" }, "Tab", "Go to space or tab…", "switch jump find"],
  ["mod.open", { name: "lazyvim-dashboard" }, "Tab", "Dashboard", "start home snacks"],
  ["mod.open", { name: "lazyvim-lazy" }, "App", "Lazy: mods", "plugins manager check"],
  ["mod.open", { name: "lazyvim-flash" }, "Pane", "Flash: jump to a pane, tab or space", "jump label leap hop"],
  ["tab.rename", {}, "Tab", "Rename tab", "tab"],
  ["tab.close", {}, "Tab", "Close tab", "tab kill"],
  ["tab.next", {}, "Tab", "Next tab", "tab"],
  ["tab.prev", {}, "Tab", "Previous tab", "tab"],
  ["pane.split", { direction: "right" }, "Pane", "Split right", "vertical vsplit"],
  ["pane.split", { direction: "down" }, "Pane", "Split down", "horizontal split"],
  ["pane.close", {}, "Pane", "Close pane", "kill quit"],
  ["pane.zoom", {}, "Pane", "Zoom pane", "maximize fullscreen"],
  ...["left", "right", "up", "down"].map((d) => ["pane.go", { direction: d }, "Pane", `Focus pane ${d}`, "move go wincmd"]),
  ...["left", "right", "up", "down"].map((d) => ["pane.swap", { direction: d }, "Pane", `Swap pane ${d}`, "move"]),
  ["space.new", {}, "Space", "New space", "workspace tabnew"],
  ["space.rename", {}, "Space", "Rename space", "workspace"],
  ["space.close", {}, "Space", "Close space", "workspace kill tabclose"],
  ["space.next", {}, "Space", "Next space", "workspace tabnext"],
  ["space.prev", {}, "Space", "Previous space", "workspace tabprevious"],
  ["layout.switch", {}, "Layout", "Next layout", "look switch"],
  ["layout.reset", {}, "Layout", "Reset layout", "new version default restore herdr's"],
  ["layout.clone", {}, "Layout", "Duplicate layout", "clone copy customize"],
  ["mod.clone", {}, "Layout", "Duplicate mod", "clone copy customize"],
  ["terminal.open", {}, "Terminal", "New terminal", "shell term"],
  ["terminal.copy", {}, "Terminal", "Copy", "clipboard yank"],
  ["terminal.paste", {}, "Terminal", "Paste", "clipboard put"],
  ["mod.open", { name: "lazyvim-inbox" }, "Agent", "Agent inbox: answer an agent", "reply blocked approve"],
  ["mod.open", { name: "lazyvim-context" }, "Agent", "Send context to agent", "paste output diff prompt"],
  ["agent.next", {}, "Agent", "Next agent", ""],
  ["agent.prev", {}, "Agent", "Previous agent", ""],
  ["window.minimize", {}, "Window", "Minimize window", ""],
  ["window.maximize", {}, "Window", "Maximize window", "restore"],
  ["window.close", {}, "Window", "Close window", "quit"],
  ["app.settings", {}, "App", "Settings", "preferences options config look font theme sound"],
  ["app.help", {}, "App", "Keys", "keybindings shortcuts help"],
  ["app.welcome", {}, "App", "Welcome", "intro start onboarding"],
  ["app.whats_new", {}, "App", "What's new", "release changes news update"],
  ["app.reset", {}, "App", "Reset to the default screen", "escape hatch broken restore"],
  ["app.zoom_in", {}, "App", "Zoom in", "bigger font size"],
  ["app.zoom_out", {}, "App", "Zoom out", "smaller font size"],
  ["app.zoom_reset", {}, "App", "Reset zoom", "font size"],
  ["app.quit", {}, "App", "Quit Herdr", "exit qa"],
];

// Commands that act on something you point at (ids, terminals): not for a list.
const HIDDEN = new Set([
  "space.move", "tab.move", "space.select", "tab.select", "pane.focus", "terminal.keep",
  "terminal.park", "terminal.kill", "terminal.show", "agent.focus", "layout.set", "layout.toggle",
  "layout.show", "layout.hide", "layout.resize", "layout.select", "mod.open", "overlay.close",
  "tab.settle", "tab.unsettle",
  "app.palette", "app.hide", "app.hide_others", "app.show_all", "app.theme", "app.settings",
]);

function titleOf(name) {
  const [noun, verb] = name.split(".");
  return { group: noun.charAt(0).toUpperCase() + noun.slice(1), title: `${verb.replace(/_/g, " ")} ${noun}`.replace(/^./, (c) => c.toUpperCase()) };
}

// Every entry for the state we're in now.
function entries() {
  const known = new Set(commands().map((c) => c.name));
  const mac = win()?.platform === "macos";
  const list = NAMED.filter(([n]) => known.has(n))
    .filter(([n]) => !(mac && n.startsWith("window.")))
    .map(([name, args, group, title, words]) => ({ name, args, group, title, words }));
  for (const l of layouts()) {
    const t = { main: "Herdr", terminals: "Terminals", win98: "Herdr 98" }[l] ?? l.charAt(0).toUpperCase() + l.slice(1);
    list.push({ name: "layout.switch", args: { name: l }, group: "Layout", title: `Layout: ${t}`, words: `look ${l}` });
  }
  for (const th of ["lazyvim", "graphite", "ink", "moss", "atom-one-dark"]) list.push({ name: "app.theme", args: { name: th }, group: "App", title: `Theme: ${th.replace(/-/g, " ")}`, words: "colors colorscheme look" });
  // Anything new in the app shows up too, until it gets a better name here.
  const named = new Set(NAMED.map(([n]) => n));
  for (const c of commands()) {
    if (named.has(c.name) || HIDDEN.has(c.name) || c.args.some((a) => a.required && a.name !== "name")) continue;
    list.push({ name: c.name, args: {}, ...titleOf(c.name), words: c.about });
  }
  return list.map((e) => ({ ...e, id: `${e.name}:${JSON.stringify(e.args)}` }));
}

// The key bound to an entry: `name` or `name:value` in keys.json.
function keyOf(e, bound) {
  const v = Object.values(e.args)[0];
  const want = v === undefined ? e.name : `${e.name}:${v}`;
  return bound.find((b) => (b.section === "global" || b.section === "layout:lazyvim") && b.action === want)?.keys ?? null;
}

// Fuzzy score of `q` in `text`, with the matched positions; null: no match.
function fuzzy(q, text) {
  const t = text.toLowerCase();
  let score = 0;
  let at = 0;
  let run = 0;
  const hits = [];
  for (const ch of q) {
    const i = t.indexOf(ch, at);
    if (i < 0) return null;
    const start = i === 0 || /[\s:.\-_/]/.test(t[i - 1]);
    run = i === at && hits.length ? run + 1 : 0;
    score += 1 + (start ? 6 : 0) + run * 3 - Math.min(i - at, 6) * 0.3;
    hits.push(i);
    at = i + 1;
  }
  return { score: score - text.length * 0.02, hits };
}

export default class Cmdline extends View {
  init(_props, cx) {
    setShared("lazyvim.cmdline", true);
    this.query = "";
    this.input = InputState.new({});
    this.input.on("change", (_e, cx) => { this.query = this.input.value(); this.at = 0; cx.notify(); });
    this.input.on("submit", (_e, cx) => this.submit(cx));
    // "cmdline", or "input" with this.ask = { title, hint, command }.
    this.mode = "cmdline";
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.at = 0;
    this.top = 0; // the first row shown
    this.recent = JSON.parse(localStorage.getItem("recent") ?? "[]");
    this.handle = cx.focus_handle();
  }

  // Herdr calls this when the overlay goes, however it went (Esc, a click beside it, a command).
  async close() {
    setShared("lazyvim.cmdline", false);
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  // Same popup, new contents: the box empties and the title changes.
  enter(mode, cx, ask = null) {
    this.mode = mode;
    this.ask = ask;
    this.input.set_value("");
    this.query = "";
    this.at = 0;
    this.top = 0;
    cx.notify();
  }

  submit(cx) {
    if (this.mode !== "input") return this.go(this.rows()[this.at]?.e, cx);
    this.dismiss();
    run(this.ask.command, { name: this.query.trim() });
  }

  go(e, cx) {
    if (!e) return;
    if (e.name === "mod.open" && e.args.name === "picker") {
      this.dismiss();
      return openOverlay({ mod: "lazyvim-picker", kind: "dialog", width: 0.92, height: 0.86, frame: "none", props: { source: "goto" } });
    }
    if (e.name === "mod.clone") return this.enter("input", cx, { title: "Duplicate mod", hint: "Mod to copy; creates <name>-copy", command: "mod.clone" });
    this.recent = [e.id, ...this.recent.filter((r) => r !== e.id)].slice(0, 20);
    localStorage.setItem("recent", JSON.stringify(this.recent));
    this.dismiss();
    run(e.name, e.name === "layout.clone" ? { name: shared("layout") ?? "main" } : e.args);
  }

  // Recent first when empty, ranked while typing.
  rows() {
    if (this.mode === "input") return [];
    const all = entries();
    const q = this.query.trim().toLowerCase().replace(/\s+/g, "");
    if (!q) {
      const recent = this.recent.map((id) => all.find((e) => e.id === id)).filter(Boolean);
      return [...recent, ...all.filter((e) => !recent.includes(e))].map((e) => ({ e }));
    }
    const rank = (e) => this.recent.indexOf(e.id);
    return all
      .map((e) => {
        const title = fuzzy(q, e.title);
        const more = fuzzy(q, `${e.group} ${e.title} ${e.name} ${e.words}`);
        const best = title ?? (more && { score: more.score - 4, hits: [] });
        return best && { e, score: best.score, hits: best.hits };
      })
      .filter(Boolean)
      .sort((a, b) => b.score - a.score || (rank(a.e) < 0 ? 99 : rank(a.e)) - (rank(b.e) < 0 ? 99 : rank(b.e)));
  }

  // The label with blink's matched letters lit.
  label(t, text, hits, on) {
    const fg = on ? t.foreground : t.muted;
    if (!hits?.length) return div().truncate().text_color(fg).child(text);
    return h_flex().children([...text].map((ch, i) =>
      div().text_color(hits.includes(i) ? t.accent : fg).when(hits.includes(i), (d) => d.font_bold()).child(ch === " " ? " " : ch)));
  }

  move(by, n) {
    this.at = Math.max(0, Math.min(this.at + by, n - 1));
  }

  render() {
    const t = theme();
    const rows = this.rows();
    const bound = keys();
    this.at = Math.min(this.at, Math.max(0, rows.length - 1));
    // Scroll only as far as it takes to keep the selection in view.
    if (this.at < this.top) this.top = this.at;
    if (this.at >= this.top + SHOWN) this.top = this.at - SHOWN + 1;
    this.top = Math.max(0, Math.min(this.top, rows.length - SHOWN));
    const shown = rows.slice(this.top, this.top + SHOWN);
    // On the terminal's `background`, not `popover`: every theme sets the first,
    // while a theme without `popover` gets a lighter one derived by Herdr.
    const menu = v_flex().id("cmdline-menu").py(2).rounded(4).border_1().border_color(t.accent).bg(t.background).text_size(12.5)
      .on_scroll_wheel((e, cx) => {
        if (Math.abs(e.delta.y) < 1) return;
        this.move(e.delta.y > 0 ? -1 : 1, rows.length);
        cx.notify();
      })
      .children(shown.map((r, j) => {
        const i = this.top + j, on = i === this.at, k = keyOf(r.e, bound);
        const [glyph, color] = KIND[r.e.group] ?? ["\u{F0295}", "ansi5"];
        // PmenuSel: the selected row stays lit under the pointer; hover only marks the others.
        return h_flex().id(`cl-${i}`).h(ROW_H).flex_none().px(12).gap(8).items_center().cursor_pointer()
          .when(on, (el) => el.bg(t.accent + "40").font_bold()).when(!on, (el) => el.hover((s) => s.bg(t.hover)))
          .on_click((_e, cx) => this.go(r.e, cx))
          .child(div().w(16).flex_none().text_color(t[color]).child(glyph))
          .child(div().flex_1().min_w(0).overflow_hidden().child(this.label(t, r.e.title, r.hits, on)))
          .when(Boolean(k), (el) => el.child(div().flex_none().text_color(t.dim).child(k)))
          .child(div().w(64).flex_none().text_color(t.dim).child(r.e.group));
      }));
    const [title, chevron] = HEAD[this.mode];
    return v_flex()
      .id("cmdline")
      .track_focus(this.handle)
      .w_full()
      .pt(10)
      .gap(4)
      .text_color(t.foreground)
      .on_key_down((e, cx) => {
        const k = e.key, m = e.modifiers ?? {};
        if (k === "escape") return this.dismiss();
        // blink's cmdline keys: tab / ctrl-n down, shift-tab / ctrl-p up.
        if (k === "down" || (k === "tab" && !m.shift) || (k === "n" && m.control)) this.move(1, rows.length);
        else if (k === "up" || (k === "tab" && m.shift) || (k === "p" && m.control)) this.move(-1, rows.length);
        else if (k === "pagedown") this.move(SHOWN, rows.length);
        else if (k === "pageup") this.move(-SHOWN, rows.length);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(
        // noice's cmdline popup: a rounded box with its title cut into the top border.
        div().relative().flex_none()
          .child(h_flex().h(34).px(12).gap(10).items_center().rounded(6).border_1().border_color(t.accent).bg(t.background)
            .child(div().flex_none().text_color(t.accent).child(chevron))
            .child(Input.new(this.input).flex_1().h_full().text_size(13).text_color(t.foreground)))
          .child(div().absolute().top(-8).left(14).px(4).bg(t.background).text_size(11.5).text_color(t.accent).child(title ?? this.ask.title)),
      )
      .when(Boolean(this.ask?.hint), (el) => el.child(div().px(14).text_size(11.5).text_color(t.dim).child(this.ask.hint)))
      .when(rows.length > 0, (el) => el.child(menu));
  }
}
