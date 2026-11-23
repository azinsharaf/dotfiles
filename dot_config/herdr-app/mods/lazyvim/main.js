// LazyVim's chrome for Herdr. One mod, a role per piece of the nvim screen:
//   bufferline  tabs as buffers, spaces as tabpages on the right
//   sources     neo-tree's source selector over the sidebar stack
//   explorer    spaces as folders, tabs as files, indent guides
//   trouble     agents as diagnostics, most urgent first
//   lualine     the focused agent's status as the vim mode
//   (no role)   a pane header (props: { pane, terminal }): the winbar
// Colors come from theme() so the theme picker restyles it all; the layout
// ships tokyonight moon (themes/lazyvim.json), LazyVim's default.

import { View, div, svg, image } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { spaces, agents, panes, terminals, focused, run, openOverlay, closeOverlay, theme, props, home, layout, window, updates, setAgentOrder, shared, setShared, nextCommand } from "herdr";

const SPIN = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
const G = {
  folder: "\u{F024B}", open: "\u{F0770}", right: "\u{F460}", down: "\u{F47C}", term: "\u{F489}",
  branch: "\u{E0A0}", root: "\u{F126D}", error: "\u{F057}", warn: "\u{F071}", hint: "\u{F0EB}",
  sleep: "\u{F04B2}", close: "\u{F0156}", clock: "\u{F017}", server: "\u{F048B}", robot: "\u{F06A9}",
  files: "\u{F0253}", git: "\u{F02A2}", update: "\u{F06B0}", plus: "\u{F067}",
  sl: "\u{E0B0}", sr: "\u{E0B2}", cl: "\u{E0B1}", cr: "\u{E0B3}",
};
// The vim mode, most urgent first: the cmdline open (lazyvim-cmdline), then
// from the focused pane: a blocked agent, then typing (a working agent, or a
// shell prompt with text: insert.zsh titles it "lv:insert"), a zoomed pane
// (a selection), then what the pane runs: an editor, a shell, an idle agent.
// The color is a theme key, or a hex for teal (tokyonight moon's, not in the
// theme's ANSI slots).
const EDITORS = ["nvim", "vim", "hx", "nano", "emacs"]; // Herdr program keys
function modeOf(p) {
  if (shared("lazyvim.cmdline")) return ["COMMAND", "ansi3"];
  if (p?.status === "blocked") return ["REPLACE", "ansi1"];
  if (p?.status === "working" || p?.title?.startsWith("lv:insert")) return ["INSERT", "ansi2"];
  if (p?.zoomed) return ["VISUAL", "ansi5"];
  if (EDITORS.includes(p?.program?.key)) return ["CODE", "#4fd6be"];
  if (p && !p.program?.agent) return ["TERMINAL", "ansi6"];
  return ["NORMAL", "ansi4"];
}
const URGENCY = { blocked: 0, done: 1, working: 2, idle: 3 };

const opt = (x) => (x ? [x] : []);

// flash.nvim's FlashLabel on a target while lazyvim-flash is open (it hands out the letters).
const flashLabel = (t, id) => {
  const k = shared("lazyvim.flash")?.[id];
  return k ? div().flex_none().px(4).rounded(2).bg(t.ansi5).text_color(t.accent_foreground).font_bold().child(k) : null;
};
const stop = (_e, cx) => cx.stop_propagation();

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

function pretty(cwd) {
  if (!cwd) return "";
  const h = home();
  return cwd === h ? "~" : cwd.startsWith(h + "/") ? "~" + cwd.slice(h.length) : cwd;
}

// A buffer name: the agent, else the shell's folder (a file-ish name), else the title.
function paneName(p) {
  if (p.program?.agent) return p.program.name;
  if (p.program?.shell) return p.cwd?.split("/").filter(Boolean).pop() ?? "~";
  return p.title || p.program?.name || "shell";
}

function tabLead(tab) {
  const ps = panes().filter((p) => p.tab === tab.id);
  return ps.find((p) => p.program?.agent) ?? ps.find((p) => p.focused) ?? ps[0];
}

function tabName(tab) {
  if (tab.named) return tab.name;
  const lead = tabLead(tab);
  return lead ? paneName(lead) : `${tab.index}`;
}

function icon(t, p, size) {
  if (p?.icon) return p.tint ? svg(p.icon).size(size).flex_none().text_color(t.muted) : image(p.icon).size(size).flex_none();
  return div().flex_none().text_color(t.ansi2).child(G.term);
}

// Diagnostic signs: error for blocked, a modified dot for done, a spinner while working.
function sign(t, status, idle) {
  if (status === "working") return div().flex_none().text_color(t.working).frames(SPIN, 80);
  if (status === "blocked") return div().flex_none().text_color(t.blocked).child(G.error);
  if (status === "done") return div().flex_none().text_color(t.done).child("●");
  return idle ? div().flex_none().text_color(t.dim).child(G.sleep) : null;
}

export default class LazyVim extends View {
  init(_p, cx) {
    const p = props();
    this.role = p?.role ?? (p?.pane ? "winbar" : "lualine");
    this.hovered = false;
    this.collapsed = new Set(JSON.parse(localStorage.getItem("collapsed") ?? "[]"));
    if (this.role === "lualine") {
      cx.timer.every(15000, (cx) => cx.notify()); // the clock
      setShared("lazyvim.cmdline", false); // shared state persists: a crash mid-cmdline would leave COMMAND
      setShared("lazyvim.flash", null); // and flash labels
      // cmd-p (keys.json "lazyvim.goto"): the picker on its goto source (mod.open can't pass props).
      cx.spawn(async () => {
        for (;;) {
          if ((await nextCommand()) !== "goto") continue;
          openOverlay({ mod: "lazyvim-picker", kind: "dialog", width: 0.92, height: 0.86, frame: "none", props: { source: "goto" } });
        }
      });
      // The dashboard, like nvim's on start: when the layout shows, then on each new space
      // that becomes the shown one (a space made in the background by a script doesn't count).
      const dashboard = () => {
        if (this.dashboard) closeOverlay(this.dashboard);
        this.dashboard = openOverlay({ mod: "lazyvim-dashboard", kind: "dialog", width: 620, height: 560, frame: "none" });
      };
      dashboard();
      this.seen = new Set(spaces().map((s) => s.id));
      cx.timer.every(400, () => {
        const all = spaces();
        if (all.some((s) => s.active && !this.seen.has(s.id))) dashboard();
        this.seen = new Set(all.map((s) => s.id));
      });
    }
  }

  render() {
    const t = theme();
    if (this.role === "winbar") return this.winbar(t);
    if (this.role === "bufferline") return this.bufferline(t);
    if (this.role === "sources") return this.sources(t);
    if (this.role === "explorer") return this.explorer(t);
    if (this.role === "trouble") return this.trouble(t);
    return this.lualine(t);
  }

  tabMenu(tab, space) {
    openOverlay({ mod: "menu", kind: "popup", width: 200, props: { tab: "tab", target: { id: tab.id, space: space.id } } });
  }

  spaceMenu(space) {
    openOverlay({ mod: "menu", kind: "popup", width: 200, height: 260, props: { tab: "space", target: { id: space.id } } });
  }

  bufferline(t) {
    const space = spaces().find((s) => s.active);
    const w = window();
    const lights = w?.platform === "macos" && w.titlebar === "none" && !w.fullscreen ? 78 : 0;
    const buf = (tab) => {
      const on = tab.active;
      const status = sign(t, tab.status);
      return h_flex().id(`buf-${tab.id}`).h_full().pr(10).gap(7).items_center().flex_none()
        .bg(on ? t.background : t.chrome).text_color(on ? t.foreground : t.dim)
        .border_r(1).border_color(t.border)
        .hover((s) => s.text_color(t.foreground))
        .on_mouse_down("left", (e, cx) => { cx.stop_propagation(); if (e.click_count === 2) run("tab.rename", { id: tab.id }); else run("tab.select", { id: tab.id }); })
        .on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); this.tabMenu(tab, space); })
        .child(div().text_color(on ? t.ansi4 : t.chrome).child("▍"))
        .children(opt(flashLabel(t, tab.id)))
        .child(icon(t, tabLead(tab)?.program, 14))
        .child(div().max_w(180).truncate().when(on, (el) => el.font_bold()).child(tabName(tab)))
        .children(status ? [status] : [div().id(`bufx-${tab.id}`).text_color(t.dim).hover((s) => s.text_color(t.blocked))
          .on_mouse_down("left", stop).on_click((_e, cx) => { cx.stop_propagation(); run("tab.close", { id: tab.id }); }).child(G.close)]);
    };
    // Tabpages on the right, like `:tabnew`: one per space.
    const page = (s, i) => div().id(`page-${s.id}`).h_full().px(9).flex().gap(5).items_center()
      .bg(s.active ? t.background : t.chrome).text_color(s.active ? t.foreground : t.dim).when(s.active, (el) => el.font_bold())
      .hover((el) => el.text_color(t.foreground))
      .on_mouse_down("left", (_e, cx) => { cx.stop_propagation(); run("space.select", { id: s.id }); })
      .on_mouse_down("right", (_e, cx) => { cx.stop_propagation(); this.spaceMenu(s); })
      .children(opt(flashLabel(t, s.id)))
      .child(`${i + 1}`);
    const button = (id, label, action) => div().id(id).h_full().px(9).flex().items_center().text_color(t.dim)
      .hover((s) => s.text_color(t.foreground)).on_mouse_down("left", stop).on_click(action).child(label);
    return h_flex().size_full().min_w(0).pl(lights).items_center().bg(t.chrome).text_size(12.5)
      .on_scroll_wheel((e) => { if (Math.abs(e.delta.y) >= 1) run(e.delta.y > 0 ? "tab.prev" : "tab.next"); })
      .child(h_flex().id("bufs").flex_1().min_w(0).h_full().items_center().overflow_x_scrollbar().children((space?.tabs ?? []).map(buf)))
      .child(button("buf-new", G.plus, () => openOverlay({ mod: "new-menu", kind: "popup", width: 250, height: 512 })))
      .children(spaces().map(page))
      .when(Boolean(w?.buttons), (el) => el
        .child(button("win-min", "─", () => run("window.minimize")))
        .child(button("win-max", "□", () => run("window.maximize")))
        .child(button("win-close", "✕", () => run("window.close"))));
  }

  sources(t) {
    const active = find(layout(), "explorer-body")?.active ?? "tree";
    const items = [["tree", G.folder, "Spaces"], ["files", G.files, "Files"], ["changes", G.git, "Git"]];
    return h_flex().size_full().bg(t.chrome).text_size(12).children(items.map(([id, glyph, label]) => {
      const on = active === id;
      return h_flex().id(`src-${id}`).flex_1().h_full().gap(6).items_center().justify_center()
        .bg(on ? t.background : t.chrome).text_color(on ? t.ansi4 : t.dim).when(on, (el) => el.font_bold())
        .hover((s) => s.text_color(t.foreground))
        .on_click(() => run("layout.select", { stack: "explorer-body", child: id }))
        .child(glyph).child(label);
    }));
  }

  toggle(id) {
    if (this.collapsed.has(id)) this.collapsed.delete(id); else this.collapsed.add(id);
    localStorage.setItem("collapsed", JSON.stringify([...this.collapsed]));
  }

  explorer(t) {
    const list = spaces();
    const guide = t.dim + "80";
    const row = (id) => h_flex().id(id).h(22).px(8).gap(6).items_center().flex_none().hover((s) => s.bg(t.hover));
    const rows = [
      row("root").text_color(t.ansi4).font_bold()
        .child(G.open).child(div().flex_1().truncate().child("herdr"))
        .child(div().id("space-new").text_color(t.dim).hover((s) => s.text_color(t.foreground)).on_click(() => run("space.new")).child(G.plus)),
    ];
    list.forEach((s, i) => {
      const last = i === list.length - 1;
      const open = !this.collapsed.has(s.id);
      const status = sign(t, s.status);
      rows.push(row(`space-${s.id}`)
        .on_click((_e, cx) => { if (s.active) this.toggle(s.id); else { this.collapsed.delete(s.id); run("space.select", { id: s.id }); } cx.notify(); })
        .on_mouse_down("right", () => this.spaceMenu(s))
        .child(div().text_color(guide).child(last ? "└╴" : "├╴"))
        .child(div().id(`chev-${s.id}`).text_color(t.dim).on_click((_e, cx) => { cx.stop_propagation(); this.toggle(s.id); cx.notify(); }).child(open ? G.down : G.right))
        .child(div().text_color(t.ansi4).child(open ? G.open : G.folder))
        .child(div().flex_1().truncate().text_color(s.active ? t.foreground : t.muted).when(s.active, (el) => el.font_bold()).child(s.name))
        .when(Boolean(s.machine), (el) => el.child(div().flex_none().text_color(t.dim).child(`${G.server} ${s.machine}`)))
        .when(Boolean(s.branch), (el) => el.child(div().flex_none().max_w(110).truncate().text_color(t.ansi5).child(`${G.branch} ${s.branch}`)))
        .children(opt(status)));
      if (!open) return;
      s.tabs.forEach((tab, j) => {
        const cursor = s.active && tab.active; // the cursorline
        rows.push(row(`file-${tab.id}`).when(cursor, (el) => el.bg(t.hover))
          .on_click(() => { run("space.select", { id: s.id }); run("tab.select", { id: tab.id }); })
          .on_mouse_down("right", () => this.tabMenu(tab, s))
          .child(div().text_color(guide).child(`${last ? "  " : "│ "}  ${j === s.tabs.length - 1 ? "└╴" : "├╴"}`))
          .child(icon(t, tabLead(tab)?.program, 13))
          .child(div().flex_1().truncate().text_color(cursor ? t.foreground : t.muted).child(tabName(tab)))
          .when(tab.panes > 1, (el) => el.child(div().flex_none().text_color(t.dim).child(`${tab.panes}`)))
          .children(opt(sign(t, tab.status))));
      });
    });
    return v_flex().id("explorer").size_full().bg(t.chrome).text_size(12.5).py(4).overflow_y_scrollbar().children(rows);
  }

  // Live sub-agents (`hc run` children) under `addr`, depth first. Paneless ones
  // aren't in agents(), so they come from terminals().
  kids(all, addr, lead = "") {
    const kids = all.filter((k) => k.parent === addr && k.state === "live");
    return kids.flatMap((k, i) => {
      const last = i === kids.length - 1;
      return [{ k, guide: lead + (last ? "└╴" : "├╴") }, ...this.kids(all, k.address, lead + (last ? "  " : "│ "))];
    });
  }

  trouble(t) {
    const all = terminals();
    const list = [...agents()].sort((a, b) => (b.pinned - a.pinned) || (URGENCY[a.status] - URGENCY[b.status]) || (a.seq - b.seq));
    setAgentOrder(list.map((a) => a.address));
    const groups = [];
    for (const a of list) {
      const g = groups.find((x) => x.space === a.space);
      if (g) g.items.push(a); else groups.push({ space: a.space, name: a.space_name, items: [a] });
    }
    const counts = (k) => list.filter((a) => a.status === k).length;
    const head = h_flex().h(24).px(8).gap(8).items_center().flex_none().bg(t.background).text_color(t.foreground)
      .child(div().text_color(t.ansi4).child(G.robot)).child(div().font_bold().child("Agents"))
      .child(div().flex_1())
      .when(counts("blocked") > 0, (el) => el.child(div().text_color(t.blocked).child(`${G.error} ${counts("blocked")}`)))
      .when(counts("working") > 0, (el) => el.child(div().text_color(t.working).child(`${G.warn} ${counts("working")}`)))
      .when(counts("done") > 0, (el) => el.child(div().text_color(t.done).child(`${G.hint} ${counts("done")}`)));
    const rows = [];
    for (const g of groups) {
      rows.push(h_flex().h(22).px(8).gap(6).items_center().flex_none().text_color(t.foreground)
        .child(div().text_color(t.ansi4).child(G.folder)).child(div().truncate().child(g.name))
        .child(div().px(5).rounded(8).bg(t.hover).text_color(t.dim).text_size(11).child(`${g.items.length}`)));
      for (const a of g.items) {
        rows.push(h_flex().id(`agent-${a.address}`).h(22).pl(22).pr(8).gap(6).items_center().flex_none()
          .when(a.focused, (el) => el.bg(t.hover)).hover((s) => s.bg(t.hover))
          .on_click(() => run(a.pane ? "pane.focus" : "terminal.peek", a.pane ? { pane: a.pane } : { terminal: a.address }))
          .child(div().w(14).flex_none().flex().justify_center().children(opt(sign(t, a.status, true))))
          .child(icon(t, a.program, 13))
          .child(div().flex_1().truncate().text_color(a.focused ? t.foreground : t.muted).child(a.title || a.program?.name || a.address))
          .child(div().flex_none().text_color(t.dim).child(`[${a.tab_name || a.tab_index}]`)));
        // A sub-agent reports to its parent: error reads as blocked, done as idle.
        for (const { k, guide } of this.kids(all, a.address)) {
          const st = k.status === "error" ? "blocked" : k.status === "done" ? "idle" : k.status;
          rows.push(h_flex().id(`sub-${k.address}`).h(22).pl(22).pr(8).gap(6).items_center().flex_none()
            .hover((s) => s.bg(t.hover)).on_click(() => run("terminal.peek", { terminal: k.address }))
            .child(div().flex_none().text_color(t.dim + "80").child(guide))
            .child(div().w(14).flex_none().flex().justify_center().children(opt(sign(t, st, true))))
            .child(icon(t, k.program, 13))
            .child(div().flex_1().truncate().text_color(t.muted).child(k.title || k.program?.name || k.address))
            .child(div().flex_none().text_color(t.dim).child(k.address)));
        }
      }
    }
    if (!rows.length) rows.push(div().px(8).py(4).text_color(t.dim).italic().child("No agents. Nothing to fix."));
    return v_flex().size_full().bg(t.chrome).text_size(12.5)
      .child(head)
      .child(v_flex().id("trouble").flex_1().py(2).overflow_y_scrollbar().children(rows));
  }

  lualine(t) {
    const f = focused();
    const space = spaces().find((s) => s.active);
    const p = panes().find((x) => x.pane === f?.pane);
    const [mode, key] = modeOf(p);
    const m = t[key] ?? key, dark = t.accent_foreground, mid = t.raised;
    const sec = (bg, fg) => h_flex().h_full().px(10).gap(8).items_center().flex_none().bg(bg).text_color(fg);
    // Powerline arrows: the glyph in the left section's color over the next one's.
    const arrow = (glyph, fg, bg) => div().h_full().flex().items_center().flex_none().bg(bg).text_color(fg).text_size(22).child(glyph);
    const tabs = space?.tabs ?? [], ti = tabs.findIndex((x) => x.active);
    const progress = tabs.length <= 1 ? "All" : ti === 0 ? "Top" : ti === tabs.length - 1 ? "Bot" : `${Math.round((ti / (tabs.length - 1)) * 100)}%`;
    const list = agents(), n = (k) => list.filter((a) => a.status === k).length;
    const diag = [["blocked", G.error], ["working", G.warn], ["done", G.hint]].filter(([k]) => n(k) > 0)
      .map(([k, g]) => div().flex_none().text_color(t[k]).child(`${g} ${n(k)}`));
    const now = new Date(), clock = `${String(now.getHours()).padStart(2, "0")}:${String(now.getMinutes()).padStart(2, "0")}`;
    return h_flex().size_full().min_w(0).items_center().bg(t.chrome).text_size(12.5).text_color(t.muted)
      .child(sec(m, dark).id("mode").font_bold().on_click(() => run("mod.open", { name: "lazyvim-cmdline" })).child(mode))
      .child(arrow(G.sl, m, space?.branch ? mid : t.chrome))
      .when(Boolean(space?.branch), (el) => el.child(sec(mid, m).child(`${G.branch} ${space.branch}`)).child(arrow(G.sl, mid, t.chrome)))
      .child(h_flex().flex_1().min_w(0).h_full().px(10).gap(10).items_center()
        .when(Boolean(space), (el) => el.child(div().flex_none().text_color(t.ansi6).child(`${G.root} ${space.name}`)))
        .children(diag)
        .when(Boolean(p), (el) => el.child(h_flex().min_w(0).gap(6).items_center().child(icon(t, p.program, 13))
          .child(div().truncate().text_color(t.foreground).child(paneName(p)))
          .child(div().truncate().text_color(t.dim).child(pretty(p.cwd))))))
      .when(Boolean(updates()?.app?.ready), (el) => el.child(sec(t.chrome, t.ansi3).id("update").on_click(() => run("app.update")).child(`${G.update} update`)))
      .when(Boolean(space?.machine), (el) => el.child(sec(t.chrome, t.dim).child(`${G.server} ${space.machine}`)))
      .child(arrow(G.sr, mid, t.chrome))
      .child(sec(mid, m).child(progress).child(`${(space?.index ?? 0) + 1}:${ti + 1}`))
      .child(arrow(G.sr, m, mid))
      .child(sec(m, dark).font_bold().child(`${G.clock} ${clock}`));
  }

  winbar(t) {
    const p = panes().find((x) => x.pane === props()?.pane);
    if (!p) return div();
    const pane = p.pane, on = p.focused;
    const crumbs = pretty(p.cwd).split("/").filter(Boolean);
    const button = (id, file, command, args) => div().id(id).p(2).rounded(3).text_color(t.dim)
      .hover((s) => s.bg(t.hover).text_color(t.foreground))
      .on_click((_e, cx) => { cx.stop_propagation(); run(command, args); })
      .child(svg(`mods/pane/${file}.svg`).size(13));
    // WinBar vs WinBarNC: the focused pane's bar is lit and marked, the others sink.
    return h_flex().id(`winbar-${pane}`).size_full().pr(8).gap(6).items_center().bg(on ? t.background : t.chrome).text_size(12)
      .text_color(on ? t.foreground : t.dim)
      .on_hover((h, cx) => { this.hovered = h; cx.notify(); })
      .on_click(() => run("pane.focus", { pane }))
      .child(div().text_color(on ? (t[modeOf(p)[1]] ?? modeOf(p)[1]) : t.chrome).child("▍")) // the lualine's mode color
      .children(opt(flashLabel(t, pane)))
      .child(icon(t, p.program, 13))
      .child(div().flex_none().max_w(220).truncate().when(on, (el) => el.font_bold()).child(paneName(p)))
      .when(p.zoomed, (el) => el.child(div().flex_none().text_color(t.ansi3).child("[Z]")))
      .children(opt(sign(t, p.status)))
      .child(h_flex().flex_1().min_w(0).gap(4).items_center().text_color(t.dim).overflow_hidden()
        .children(crumbs.flatMap((c, i) => [div().flex_none().text_color(on ? t.ansi4 + "aa" : t.dim).child(i ? G.right : " "), div().flex_none().child(c)])))
      .when(this.hovered, (el) => el
        .child(button(`wb-r-${pane}`, "split-right", "pane.split", { direction: "right", pane }))
        .child(button(`wb-d-${pane}`, "split-down", "pane.split", { direction: "down", pane }))
        .child(button(`wb-z-${pane}`, p.zoomed ? "unzoom" : "zoom", "pane.zoom", { pane }))
        .child(button(`wb-x-${pane}`, "close", "pane.close", { pane })));
  }
}
