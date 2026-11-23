// lazy.nvim's :Lazy for Herdr: every mod in mods/, Loaded (the shown layout uses it,
// or a key opens it) then Not Loaded, Herdr's own tagged. Check (C) runs
// `herdr-app check` on each: a green check for the ones that pass, the ones that
// fail move into Failed. Opened from <leader>l, the dashboard's l, the cmdline.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, ScrollHandle } from "gpui-base";
import { exec, readTextFile, home, layout, keys, commands, shared, theme, props, openOverlay, closeOverlay } from "herdr";

const ROW_H = 20;
const PAGE = 15; // mods a page up/down moves
const HOME = () => `${home()}/.config/herdr-app`;
// The shell may not have ~/.local/bin, where Herdr puts herdr-app.
const CHECK = 'PATH="$PATH:$HOME/.local/bin"; herdr-app check "$1" 2>&1';

// Every `mod` the shown layout names (blocks, pane headers, toast...), and why.
function used() {
  const why = {};
  const walk = (o) => {
    if (Array.isArray(o)) return o.forEach(walk);
    if (!o || typeof o !== "object") return;
    for (const [k, v] of Object.entries(o)) {
      if ((k === "mod" || k === "toast" || k === "terminal_menu") && typeof v === "string") (why[v] ??= new Set()).add("layout");
      else walk(v);
    }
  };
  walk(layout());
  // keys.json: mod.open:<name> and <name>.<command> (not an app command), in sections that apply here.
  const known = new Set(commands().map((c) => c.name));
  const here = new Set(["global", "terminal", `layout:${shared("layout")}`]);
  for (const b of keys()) {
    if (!here.has(b.section) && !b.section.startsWith("mod:")) continue;
    const m = /^mod\.open:(.+)$/.exec(b.action) ?? (!known.has(b.action) && /^([\w-]+)\.[\w-]+$/.exec(b.action));
    if (m) (why[m[1]] ??= new Set()).add("keys");
  }
  return why;
}

// Why a mod is loaded, in lazy's reason colors: [label, theme color].
const REASON = {
  layout: ["\u{F0E58} layout", "ansi2"],
  keys: ["\u{F030C} keys", "ansi3"],
  mod: ["\u{F0AE2} mod", "ansi6"],
};

const HELP = [
  ["j / k", "move (or click)"], ["enter", "details (or click it again)"], ["c", "check this mod"], ["C", "check every mod"],
  ["o", "open its folder in the picker"], ["H", "home"], ["?", "this help"], ["q / esc", "close"],
];

export default class Lazy extends View {
  init(_props, cx) {
    this.mods = []; // { name, title, shipped, why, ms, error }
    this.at = 0;
    this.scroll = ScrollHandle.new();
    this.open = new Set(); // names with details shown
    this.view = "home";
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    cx.spawn(async (cx) => {
      try { await this.scan(); } catch (e) { this.failed = String(e?.stack ?? e); }
      cx.notify();
    });
  }

  async scan() {
    const dir = `${HOME()}/mods`;
    const shipped = new Set(Object.keys(JSON.parse((await readTextFile(`${HOME()}/installed.json`)) ?? "{}")));
    const r = await exec("sh", ["-c", 'cd "$1" && for d in */; do [ -f "$d/main.js" ] && printf "%s\\n" "${d%/}"; done', "sh", dir]);
    const names = r.stdout.split("\n").filter(Boolean);
    const why = used();
    // lazy's dependencies: a mod a loaded mod opens ({mod: "x"}, mod.open {name: "x"}), twice
    // over so a mod opened from one opened by a key counts too. grep returns just those
    // references rather than whole files.
    const opens = {}; // mod -> names it opens
    for (let pass = 0; pass < 2; pass++) {
      const read = Object.keys(why).filter((n) => names.includes(n) && !(n in opens));
      if (!read.length) break;
      const g = await exec("sh", ["-c", 'cd "$1" && shift && for n; do grep -ohE "(mod|name)[[:space:]]*:[[:space:]]*\\"[A-Za-z0-9_-]+\\"" "$n/main.js" | sed "s|^|$n |"; done; true', "sh", dir, ...read]);
      for (const n of read) opens[n] = new Set();
      for (const l of g.stdout.split("\n")) {
        const m = /^(\S+) .*"([^"]+)"$/.exec(l);
        if (m && m[1] !== m[2]) opens[m[1]].add(m[2]);
      }
      for (const n of names) if (!why[n] && Object.values(opens).some((o) => o.has(n))) (why[n] = new Set()).add("mod");
    }
    this.mods = names.map((name) => ({ name, title: null, shipped: shipped.has(name), why: [...(why[name] ?? [])], checked: false, error: null }));
  }

  // Details read its mod.json title once, when first opened.
  async details(m, cx) {
    if (m.title !== null) return;
    try { m.title = JSON.parse((await readTextFile(`${HOME()}/mods/${m.name}/mod.json`)) ?? "{}").title ?? ""; } catch { m.title = ""; }
    cx.notify();
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  // In a task of its own: a key or click handler's cx can't redraw once it has awaited.
  check(list, cx) {
    for (const m of list) { m.checked = false; m.error = null; }
    cx.notify();
    cx.spawn(async (cx) => {
      // ponytail: 8 at a time; each check starts a whole herdr-app, about 0.5s.
      const queue = [...list];
      const one = async () => {
        for (let m; (m = queue.shift());) {
          const r = await exec("sh", ["-c", CHECK, "sh", `${HOME()}/mods/${m.name}`]).catch((e) => ({ code: 1, stdout: String(e) }));
          m.checked = true;
          m.error = r.code === 0 ? null : (r.stdout || r.stderr || "check failed").trim();
          cx.notify();
        }
      };
      await Promise.all(Array.from({ length: 8 }, one));
    });
  }

  // The screen as lines: headers, mods and their details; `mod` marks selectable ones.
  lines() {
    const failed = this.mods.filter((m) => m.error);
    const ok = this.mods.filter((m) => !m.error);
    const sections = [
      ["Failed", failed],
      ["Loaded", ok.filter((m) => m.why.length)],
      ["Not Loaded", ok.filter((m) => !m.why.length)],
    ];
    const out = [];
    for (const [name, list] of sections) {
      if (!list.length) continue;
      out.push({ head: `${name} (${list.length})` });
      for (const m of list.sort((a, b) => a.name.localeCompare(b.name))) {
        out.push({ mod: m });
        if (!this.open.has(m.name)) continue;
        out.push({ key: "dir", value: `~/.config/herdr-app/mods/${m.name}` });
        if (m.title) out.push({ key: "title", value: m.title });
        out.push({ key: "from", value: m.shipped ? "Herdr (shipped)" : "yours" });
        if (m.why.length) out.push({ key: "used by", value: m.why.join(", ") });
        if (m.checked) out.push({ key: "check", value: m.error ? m.error.split("\n")[0] : "passed" });
        out.push({ actions: m });
      }
    }
    return out;
  }

  // Moves the selection to the n-th mod and scrolls its line into view.
  select(n, cx) {
    const sel = this.selectable();
    this.at = Math.max(0, Math.min(n, sel.length - 1));
    this.scroll.scroll_to_item(sel[this.at] ?? 0);
    cx.notify();
  }

  selectable() {
    return this.lines().map((l, i) => (l.mod ? i : -1)).filter((i) => i >= 0);
  }

  toggle(m, cx) {
    if (this.open.has(m.name)) this.open.delete(m.name);
    else { this.open.add(m.name); cx.spawn(async (cx) => this.details(m, cx)); }
    cx.notify();
  }

  folder(m) {
    this.dismiss();
    openOverlay({ mod: "lazyvim-picker", kind: "dialog", width: 0.92, height: 0.86, frame: "none", props: { root: `${HOME()}/mods/${m.name}` } });
  }

  show(view, cx) {
    this.view = view;
    cx.notify();
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers ?? {};
    const k = e.key_char ?? e.key;
    const lines = this.lines();
    const cur = lines[this.selectable()[this.at]]?.mod;
    if (e.key === "escape" || k === "q") return this.dismiss();
    if (this.view === "help") return this.show("home", cx);
    if (e.key === "down" || k === "j" || (k === "n" && m.control)) this.select(this.at + 1, cx);
    else if (e.key === "up" || k === "k" || (k === "p" && m.control)) this.select(this.at - 1, cx);
    else if (e.key === "pagedown") this.select(this.at + PAGE, cx);
    else if (e.key === "pageup") this.select(this.at - PAGE, cx);
    else if (e.key === "enter" && cur) this.toggle(cur, cx);
    else if (k === "c" && cur) this.check([cur], cx);
    else if (k === "C") this.check(this.mods, cx);
    else if (k === "o" && cur) this.folder(cur);
    else if (k === "?") this.show("help", cx);
    else if (k === "H") this.show("home", cx);
  }

  async close() {
    this.scroll.release();
  }

  render() {
    const t = theme();
    const lines = this.lines();
    const sel = this.selectable();
    this.at = Math.min(this.at, Math.max(0, sel.length - 1));
    const at = sel[this.at] ?? -1;
    const checking = this.mods.some((m) => !m.checked) && this.mods.some((m) => m.checked);
    const done = this.mods.filter((m) => m.checked).length;

    // lazy's header: its name as H1, then the buttons, the shown view lit. They click too.
    const button = (id, label, k, on, act) => div().id(id).px(8).rounded(3).cursor_pointer()
      .bg(on ? t.accent : t.raised).text_color(on ? t.accent_foreground : t.foreground)
      .when(on, (el) => el.font_bold()).when(!on, (el) => el.hover((s) => s.bg(t.hover)))
      .on_click((_e, cx) => act(cx)).child(`${label} (${k})`);
    const head = h_flex().h(28).flex_none().px(12).gap(10).items_center()
      .child(div().px(8).rounded(3).bg(t.ansi5).text_color(t.accent_foreground).font_bold().child("herdr mods"))
      .child(button("lz-home", "Home", "H", this.view === "home", (cx) => this.show("home", cx)))
      .child(button("lz-check", "Check", "C", checking, (cx) => this.check(this.mods, cx)))
      .child(button("lz-help", "Help", "?", this.view === "help", (cx) => this.show("help", cx)));

    // A small action under an open mod, like lazy's details: its key and what it does.
    const action = (id, k, label, act) => h_flex().id(id).px(6).gap(4).rounded(3).cursor_pointer().bg(t.raised)
      .hover((s) => s.bg(t.hover)).on_click((_e, cx) => { cx.stop_propagation(); act(cx); })
      .child(div().text_color(t.ansi4).child(k)).child(div().text_color(t.foreground).child(label));

    const line = (l, i) => {
      if (l.head) return div().h(ROW_H).pt(4).px(14).font_bold().text_color(t.foreground).child(l.head);
      if (l.actions) return h_flex().h(ROW_H + 4).pl(44).gap(8).items_center()
        .child(action(`lz-c-${l.actions.name}`, "c", "check", (cx) => this.check([l.actions], cx)))
        .child(action(`lz-o-${l.actions.name}`, "o", "open folder", () => this.folder(l.actions)));
      if (l.key) return h_flex().h(ROW_H).pl(44).gap(8).items_center()
        .child(div().w(64).flex_none().text_color(t.dim).child(l.key))
        .child(div().flex_1().min_w(0).truncate().text_color(l.key === "check" && l.value === "passed" ? t.ansi2 : l.key === "check" ? t.ansi1 : t.muted).child(l.value));
      const m = l.mod, on = i === at, n = sel.indexOf(i);
      const bullet = m.error ? ["\u{2717}", t.ansi1] : m.why.length ? ["\u{25CF}", t.ansi4] : ["\u{25CB}", t.dim];
      // A click selects; a click on the selected one opens or shuts its details.
      return h_flex().id(`lz-${m.name}`).h(ROW_H).pl(28).pr(12).gap(8).items_center().cursor_pointer()
        .when(on, (el) => el.bg(t.hover)).when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click((_e, cx) => (on ? this.toggle(m, cx) : this.select(n, cx)))
        .child(div().w(12).flex_none().text_color(bullet[1]).child(bullet[0]))
        .child(div().flex_none().text_color(m.why.length || m.error ? t.foreground : t.muted).when(on, (el) => el.font_bold()).child(m.name))
        // No times: `herdr-app check` takes about as long for any mod (it's mostly its own start-up).
        .when(m.checked && !m.error, (el) => el.child(div().flex_none().text_color(t.ansi2).child("\u{2713}")))
        .children(m.why.map((w) => div().flex_none().text_color(t[REASON[w][1]]).child(REASON[w][0])))
        .when(m.shipped, (el) => el.child(div().flex_none().text_color(t.dim).child("\u{F013} herdr")))
        .when(Boolean(m.error), (el) => el.child(div().flex_1().min_w(0).truncate().text_color(t.ansi1).child(m.error.split("\n")[0])));
    };

    const total = div().h(ROW_H).flex_none().px(14).font_bold().text_color(t.foreground).child(
      this.failed ? `Couldn't list mods: ${this.failed}` : this.mods.length ? `Total: ${this.mods.length} mods${done ? `  \u{00B7}  checked ${done}/${this.mods.length}` : ""}` : "Loading\u{2026}");
    const body = this.view === "help"
      ? v_flex().px(14).pt(6).children(HELP.map(([k, what]) => h_flex().h(ROW_H).gap(12)
          .child(div().w(80).text_color(t.ansi4).child(k)).child(div().text_color(t.muted).child(what))))
      : v_flex().id("lz-list").flex_1().min_h(0).pb(6).overflow_y_scrollbar().track_scroll(this.scroll)
          .children(lines.map(line));

    return v_flex().id("lazy").size_full().pt(8).pb(4).gap(6).rounded(6).border_1().border_color(t.accent).bg(t.background).text_size(12.5)
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .child(head)
      .when(this.view === "home", (el) => el.child(total))
      .child(body);
  }
}
