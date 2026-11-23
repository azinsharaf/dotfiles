// LazyVim's snacks picker for Herdr: a fuzzy list on the left, a preview of
// the selected entry on the right. Two sources:
// - files (cmd-o): the focused pane's repo files, the selected one read-only.
//   Enter mentions it in the tab's agent (@path, pasted, not sent), or with
//   no agent opens it like ctrl-o: in the tab's nvim (through its --server
//   socket), else with $VISUAL / $EDITOR (a GUI editor in its own window, a
//   terminal one in a split); ctrl-v / ctrl-s split right / down with a
//   terminal editor.
// - goto (cmd-p, props { source: "goto" }): spaces, tabs and agents, the
//   selected one's terminals as text (a space: all its tabs), refreshed every
//   500ms. Enter goes there.
// While it's open, shared("lazyvim.cmdline") is true and the lualine shows COMMAND.

import { View, div, svg, image } from "gpui-kit";
import { v_flex, h_flex, InputState, Input, Editor, EditorState } from "gpui-base";
import { exec, hc, readTextFile, focused, spaces, panes, agents, run, theme, props, closeOverlay, setShared, home, appHome, window as win } from "herdr";

const ROW_H = 22;
// ponytail: every keystroke ranks the whole list in QuickJS (~30-70 ms at 20k
// files); cap it, rank with `fzf --filter` through exec if big repos lag.
const MAX = 20000;
// image() only reads under Herdr's home, so pictures are copied here first
// (beside the mod's localStorage in data/lazyvim-picker). Herdr keeps every
// image it decodes for good, so each picture gets one name per version (path
// hash and mtime) and is shrunk to 2048px (sips, on macOS): a 5K screenshot
// is 56 MB decoded, and a name per look would keep one copy per look.
const SHOTS = "data/lazyvim-picker/preview";
const SHRINK = `d="$3/${SHOTS}"; mkdir -p "$d" && find "$d" -type f -mtime +7 -delete 2>/dev/null
n="$(printf %s "$1" | cksum | cut -d' ' -f1)-$(stat -f %m "$1" 2>/dev/null || stat -c %Y "$1").$2"
[ -f "$d/$n" ] || sips -Z 2048 "$1" --out "$d/$n" >/dev/null 2>&1 || cp "$1" "$d/$n" || exit 1
echo "${SHOTS}/$n"`;
// GUI editors open their own window: run them, no pane (and without --wait).
const GUI = new Set(["code", "code-insiders", "codium", "cursor", "windsurf", "zed", "subl", "mate", "idea", "webstorm", "open", "xdg-open"]);
const IMAGES = new Set(["png", "jpg", "jpeg", "gif", "webp", "svg", "bmp", "ico"]);
const BINARY = new Set(["ttf", "otf", "woff", "woff2", "zip", "gz", "tgz", "tar", "pdf", "mp3", "mp4", "mov", "wasm", "so", "dylib", "dll", "exe", "bin", "o", "a", "class", "jar", "db", "sqlite", "lockb"]);
// The editor's grammars, as Herdr's files mod names them.
const LANG = { ts: "js", tsx: "js", mts: "js", cts: "js", jsx: "js", mjs: "js", toml: "yaml", jsonc: "json", svelte: "html", vue: "html" };
// mini.icons' look: a glyph and a theme color per kind of file.
const BY_NAME = { ".gitignore": ["\u{E702}", "ansi1"], Dockerfile: ["\u{F308}", "ansi4"], Makefile: ["\u{E673}", "ansi3"], LICENSE: ["\u{F0219}", "ansi3"] };
const BY_EXT = {
  js: ["\u{E74E}", "ansi3"], mjs: ["\u{E74E}", "ansi3"], cjs: ["\u{E74E}", "ansi3"], jsx: ["\u{E7BA}", "ansi6"],
  ts: ["\u{E628}", "ansi4"], tsx: ["\u{E7BA}", "ansi4"], json: ["\u{E60B}", "ansi3"], jsonc: ["\u{E60B}", "ansi3"],
  md: ["\u{E73E}", "ansi4"], lua: ["\u{E620}", "ansi4"], py: ["\u{E606}", "ansi3"], rs: ["\u{E7A8}", "ansi1"],
  go: ["\u{E626}", "ansi6"], rb: ["\u{E739}", "ansi1"], sh: ["\u{F489}", "ansi2"], zsh: ["\u{F489}", "ansi2"],
  bash: ["\u{F489}", "ansi2"], fish: ["\u{F489}", "ansi2"], html: ["\u{E736}", "ansi1"], css: ["\u{E749}", "ansi4"],
  scss: ["\u{E749}", "ansi5"], yaml: ["\u{E615}", "ansi5"], yml: ["\u{E615}", "ansi5"], toml: ["\u{E615}", "ansi5"],
  txt: ["\u{F15C}", "muted"], lock: ["\u{F023}", "muted"], ttf: ["\u{F031}", "muted"], otf: ["\u{F031}", "muted"],
};
for (const x of IMAGES) BY_EXT[x] = ["\u{F1C5}", "ansi5"];
// Go to's kinds, as the cmdline draws them.
const KIND = { Space: ["\u{F024B}", "ansi4"], Tab: ["\u{F04E9}", "ansi2"], Agent: ["\u{F06A9}", "ansi4"], New: ["\u{F067}", "dim"] };
const SPIN = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

const extOf = (path) => { const name = path.split("/").pop(); return name.includes(".") ? name.split(".").pop().toLowerCase() : ""; };
const iconOf = (path) => BY_NAME[path.split("/").pop()] ?? BY_EXT[extOf(path)] ?? ["\u{F15B}", "muted"];

// Fuzzy score of `q` in `text`, with the matched positions; null: no match.
// (Copied from lazyvim-cmdline: a mod can't import another's files.)
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

// A match in the file name beats one spread over the folders.
function matchPath(q, path) {
  const slash = path.lastIndexOf("/") + 1;
  const base = fuzzy(q, path.slice(slash));
  if (base) return { score: base.score + 8, hits: base.hits.map((i) => i + slash) };
  return fuzzy(q, path);
}

// The repo's files, as git sees them (tracked and untracked, not ignored), else rg's, else find's.
async function listFiles(root, on) {
  const tries = [
    ["git", ["ls-files", "-z", "-co", "--exclude-standard"]],
    ["rg", ["--files", "--hidden", "--null", "-g", "!.git"]],
    ["find", [".", "-type", "f", "-not", "-path", "*/.git/*", "-print0"]],
  ];
  for (const [cmd, args] of tries) {
    const r = await exec(cmd, args, { cwd: root, on }).catch(() => null);
    if (r?.code === 0) return r.stdout.split("\0").filter(Boolean).map((p) => p.replace(/^\.\//, "")).sort().slice(0, MAX);
  }
  return [];
}

// nvim's default server is nvim.<pid>.0 (on 0.10+ the pid of the TUI's child),
// under $TMPDIR/nvim.$USER/*/ on macOS and $XDG_RUNTIME_DIR on Linux.
const SOCKET = `for p in "$1" $(pgrep -P "$1"); do
  for s in "\${XDG_RUNTIME_DIR:-/nonexistent}/nvim.$p.0" "\${TMPDIR:-/tmp}"/nvim.$(id -un)/*/nvim.$p.0; do
    [ -S "$s" ] && { echo "$s"; exit 0; }
  done
done
exit 1`;

// Puts text on the clipboard: hc can type keys but not text without Enter,
// so a mention goes through the clipboard and terminal.paste.
function copy(text) {
  if (win()?.platform === "windows") return exec("powershell", ["-NoProfile", "-Command", "Set-Clipboard -Value $args[0]", text]);
  const to = win()?.platform === "macos" ? "pbcopy" : "wl-copy 2>/dev/null || xclip -selection clipboard";
  return exec("sh", ["-c", `printf %s "$1" | { ${to}; }`, "copy", text]);
}

// Names as the explorer shows them (copied from mods/lazyvim): a named tab
// keeps its name, else its lead pane's: the agent, else the shell's folder, else the title.
function paneName(p) {
  if (p.program?.agent) return p.program.name;
  if (p.program?.shell) return p.cwd?.split("/").filter(Boolean).pop() ?? "~";
  return p.title || p.program?.name || "shell";
}

function tabName(tab) {
  if (tab.named) return tab.name;
  const ps = panes().filter((p) => p.tab === tab.id);
  const lead = ps.find((p) => p.program?.agent) ?? ps.find((p) => p.focused) ?? ps[0];
  return lead ? paneName(lead) : `${tab.index}`;
}

// Every space, then each of its tabs, then the agents, for Go to. A space
// previews all its tabs. `guide`: the explorer's tree lines, shown while the
// query is empty; `name`: a tab's name under its space there.
function places() {
  const ps = panes();
  const all = spaces();
  return all.flatMap((s, i) => {
    const last = i === all.length - 1;
    const tabs = s.tabs.map((tab) => ({ tab, name: tabName(tab), panes: ps.filter((p) => p.tab === tab.id) }));
    const space = { kind: "Space", title: s.name, words: s.branch ?? "", status: s.status, guide: last ? "└╴" : "├╴",
      go: ["space.select", { id: s.id }], space: s, tabs, panes: tabs.flatMap((x) => x.panes) };
    return [space, ...tabs.map((x, j) => ({ kind: "Tab", title: `${s.name} \u{F460} ${x.name}`, name: x.name, words: x.tab.name,
      status: x.tab.status, guide: `${last ? "  " : "│ "}  ${j === tabs.length - 1 ? "└╴" : "├╴"}`,
      lead: x.panes.find((p) => p.program?.agent) ?? x.panes.find((p) => p.focused) ?? x.panes[0],
      go: ["tab.select", { id: x.tab.id }], panes: x.panes }))];
  }).concat(agents().map((a) => ({ kind: "Agent", title: `${a.program?.name ?? a.app ?? "agent"} \u{F460} ${a.title}`, words: `${a.space_name} ${a.tab_name}`,
    status: a.status, go: ["agent.focus", { terminal: a.address }], panes: ps.filter((p) => p.pane === a.pane) })))
    .concat([
      { kind: "New", title: "New tab", words: "", go: ["tab.new", {}], panes: [] },
      { kind: "New", title: "New space", words: "workspace", go: ["space.new", {}], panes: [] },
    ]);
}

const opt = (x) => (x ? [x] : []);

// Diagnostic signs: error for blocked, a modified dot for done, a spinner while working.
function sign(t, status) {
  if (status === "working") return div().flex_none().text_color(t.working).frames(SPIN, 80);
  if (status === "blocked") return div().flex_none().text_color(t.blocked).child("\u{F057}");
  if (status === "done") return div().flex_none().text_color(t.done).child("●");
  return null;
}

function programIcon(t, p) {
  const i = p.program?.icon;
  if (i) return p.program.tint ? svg(i).size(13).flex_none().text_color(t.muted) : image(i).size(13).flex_none();
  return div().flex_none().text_color(t.ansi2).child("\u{F489}");
}

export default class Picker extends View {
  init(_props, cx) {
    setShared("lazyvim.cmdline", true);
    this.source = props()?.source === "goto" ? "goto" : "files";
    const f = focused();
    this.tab = f?.tab;
    this.on = spaces().find((s) => s.id === f?.space)?.machine ?? null;
    this.files = null; // null while listing
    this.query = "";
    this.ranked = [];
    this.at = 0;
    this.top = 0;
    this.shown = 20;
    this.seq = 0;
    this.screens = {}; // terminal address: its screen text (goto)
    this.input = InputState.new({});
    this.input.on("change", (_e, cx) => { this.query = this.input.value(); this.at = 0; this.rank(); this.sync(cx); });
    this.input.on("submit", (_e, cx) => (this.source === "goto" ? this.go() : this.mention(cx)));
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    if (this.source === "goto") {
      this.rank();
      this.sync(cx);
      cx.timer.every(500, (cx) => this.readScreens(cx));
      return;
    }
    // The editor: $VISUAL, else $EDITOR; a terminal one for splits (it, else nvim, vim or vi).
    this.editor = ["nvim"];
    this.splitEditor = ["nvim"];
    exec("sh", ["-c", 'printf "%s\\n%s" "${VISUAL:-$EDITOR}" "$(command -v nvim || command -v vim || echo vi)"'], { on: this.on }).then((r) => {
      const [mine, term] = r.stdout.split("\n");
      const argv = mine.trim().split(/\s+/).filter(Boolean);
      if (argv.length) this.editor = argv;
      this.splitEditor = argv.length && !GUI.has(argv[0].split("/").pop()) ? argv : [term.trim().split("/").pop() || "vi"];
      cx.notify();
    }, () => null);
    cx.spawn(async (cx) => {
      // props().root: a folder to list instead (the dashboard's Config).
      const cwd = props()?.root ?? f?.cwd ?? panes().find((p) => p.focused)?.cwd ?? home();
      const top = await exec("git", ["rev-parse", "--show-toplevel"], { cwd, on: this.on }).catch(() => null);
      this.root = top?.code === 0 ? top.stdout.trim() : cwd;
      this.recent = JSON.parse(localStorage.getItem(`recent:${this.root}`) ?? "[]");
      this.files = await listFiles(this.root, this.on);
      this.rank();
      this.sync(cx);
    });
  }

  // Herdr calls this when the overlay goes, however it went.
  async close() {
    setShared("lazyvim.cmdline", false);
    this.code?.release();
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  // Files: recent first when empty, ranked while typing. Go to: in place
  // order when empty, ranked by title (else by its other words) while typing.
  rank() {
    const q = this.query.trim().toLowerCase().replace(/\s+/g, "");
    if (this.source === "goto") {
      const all = places();
      this.ranked = !q ? all.map((e) => ({ e }))
        : all.map((e) => {
          const m = fuzzy(q, e.title) ?? (fuzzy(q, `${e.kind} ${e.title} ${e.words}`) && { score: -4, hits: [] });
          return m && { e, score: m.score, hits: m.hits };
        }).filter(Boolean).sort((a, b) => b.score - a.score);
      return;
    }
    const all = this.files ?? [];
    if (!q) {
      const seen = new Set(this.recent.filter((p) => all.includes(p)));
      this.ranked = [...seen, ...all.filter((p) => !seen.has(p))].map((path) => ({ path }));
      return;
    }
    const out = [];
    for (const path of all) {
      const m = matchPath(q, path);
      if (m) out.push({ path, score: m.score, hits: m.hits });
    }
    this.ranked = out.sort((a, b) => b.score - a.score);
  }

  move(by, cx) {
    this.at = Math.max(0, Math.min(this.at + by, this.ranked.length - 1));
    this.sync(cx);
  }

  // Load the selected entry into the preview, once the selection settles.
  sync(cx) {
    cx.notify();
    if (this.source === "goto") return this.readScreens(cx);
    const path = this.ranked[this.at]?.path ?? null;
    if (path === this.file) return;
    this.file = path;
    this.code?.release();
    this.code = null;
    this.note = null;
    this.picture = null;
    if (!path) return;
    const ext = extOf(path);
    const seq = ++this.seq;
    if (IMAGES.has(ext)) {
      if (this.on) { this.note = "Image on another machine · no preview"; return; }
      cx.spawn(async (cx) => {
        const r = await exec("sh", ["-c", SHRINK, "shrink", `${this.root}/${path}`, ext, appHome()]).catch(() => null);
        if (seq !== this.seq) return;
        if (r?.code === 0) this.picture = r.stdout.trim();
        else this.note = "Can't preview this image";
        cx.notify();
      });
      return;
    }
    if (BINARY.has(ext)) { this.note = "Binary file · no preview"; return; }
    cx.spawn(async (cx) => {
      await cx.sleep(40);
      if (seq !== this.seq) return;
      try {
        const text = await readTextFile(`${this.root}/${path}`, { on: this.on });
        if (seq !== this.seq) return;
        if (text === null) this.note = "This file is no longer there";
        else if (text.includes("\0")) this.note = "Binary file · no preview";
        else {
          const t = theme();
          this.code = EditorState.new({
            language: LANG[ext] ?? (ext || "txt"), readonly: true, folding: false, font_size: 12.5,
            value: text.length > 200000 ? text.slice(0, 200000) + "\n… (cut here)" : text,
            syntax: { keyword: t.ansi5, string: t.ansi2, comment: t.dim, function: t.ansi4, type: t.ansi6, number: t.ansi3, constant: t.ansi3, boolean: t.ansi3, operator: t.ansi6 },
          });
        }
      } catch {
        if (seq === this.seq) this.note = "Can't preview this file (too big or unreadable)";
      }
      cx.notify();
    });
  }

  // Go to: the selected entry's terminals as text (no colors: hc read gives the screen's text).
  readScreens(cx) {
    const ts = (this.ranked[this.at]?.e.panes ?? []).map((p) => p.terminal).filter(Boolean);
    if (!ts.length) return;
    cx.spawn(async (cx) => {
      const got = await Promise.all(ts.map((t) => hc(["read", t]).then((r) => [t, r.code === 0 ? r.stdout : ""], () => [t, ""])));
      for (const [t, text] of got) this.screens[t] = text.replace(/\s+$/, "");
      cx.notify();
    });
  }

  go() {
    const e = this.ranked[this.at]?.e;
    if (!e) return;
    this.dismiss();
    run(...e.go);
  }

  pick(path) {
    this.recent = [path, ...this.recent.filter((p) => p !== path)].slice(0, 30);
    localStorage.setItem(`recent:${this.root}`, JSON.stringify(this.recent));
    return `${this.root}/${path}`;
  }

  // Enter: @path in the tab's agent prompt (the focused one, else the first),
  // relative to its folder, pasted and left for you to finish. No agent: open it.
  agent() {
    const ps = panes().filter((p) => p.tab === this.tab && p.terminal && p.program?.agent);
    return ps.find((p) => p.focused) ?? ps[0];
  }

  mention(cx) {
    const path = this.ranked[this.at]?.path;
    if (!path) return;
    const agent = this.agent();
    if (!agent) return this.open(null, cx);
    const file = this.pick(path);
    const rel = agent.cwd && file.startsWith(`${agent.cwd}/`) ? file.slice(agent.cwd.length + 1) : file;
    // Find the work first: tasks stop once the overlay closes.
    cx.spawn(async () => {
      const r = await copy(`@${rel} `).catch(() => null);
      this.dismiss();
      run("pane.focus", { pane: agent.pane });
      if (r?.code === 0) run("terminal.paste");
    });
  }

  // The tab's nvim, when it has one: files go there through its server.
  nvim() {
    return panes().find((p) => p.tab === this.tab && p.terminal && p.program?.key === "nvim");
  }

  // What ctrl-o opens with, for the key line.
  editorName() {
    return this.nvim() ? "nvim" : this.editor[0].split("/").pop();
  }

  // ctrl-o: the tab's nvim, else $EDITOR (a GUI one in its window, a terminal
  // one in a split); ctrl-v / ctrl-s: a split right / down with a terminal editor.
  open(split, cx) {
    const path = this.ranked[this.at]?.path;
    if (!path) return;
    const file = this.pick(path);
    const nvim = !split && this.nvim();
    if (!nvim) {
      const [cmd, ...args] = this.editor;
      this.dismiss();
      if (!split && GUI.has(cmd.split("/").pop())) return exec(cmd, [...args.filter((a) => a !== "-w" && a !== "--wait"), file], { on: this.on }).catch(() => null);
      return run("pane.split", { direction: split ?? "right", argv: [...(split ? this.splitEditor : this.editor), file] });
    }
    cx.spawn(async () => {
      const got = await hc(["get", nvim.terminal, "--json"]).catch(() => null);
      const pid = got?.code === 0 ? JSON.parse(got.stdout).foreground?.pid : null;
      const sock = pid && await exec("sh", ["-c", SOCKET, "socket", String(pid)], { on: this.on }).catch(() => null);
      const sent = sock?.code === 0 && await exec("nvim", ["--server", sock.stdout.trim(), "--remote", file], { on: this.on }).catch(() => null);
      this.dismiss();
      if (sent?.code === 0) run("pane.focus", { pane: nvim.pane });
      else run("pane.split", { direction: "right", argv: [...this.splitEditor, file] });
    });
  }

  // The text with blink's matched letters lit; a file's folders dim.
  label(t, text, hits, on, dimTo) {
    const color = (i) => (hits?.includes(i) ? t.accent : i < dimTo ? t.dim : on ? t.foreground : t.muted);
    if (!hits?.length) {
      return h_flex().min_w(0).overflow_hidden().whitespace_nowrap()
        .child(div().flex_none().text_color(t.dim).child(text.slice(0, dimTo)))
        .child(div().flex_none().text_color(color(dimTo)).child(text.slice(dimTo)));
    }
    return h_flex().min_w(0).overflow_hidden().whitespace_nowrap().children([...text].map((ch, i) =>
      div().flex_none().text_color(color(i)).when(hits.includes(i), (d) => d.font_bold()).child(ch)));
  }

  // What the keys do, which-key style: Enter mentions in the tab's agent when
  // there is one, opens in nvim when there isn't.
  keysHint(t, goto) {
    const agent = !goto && this.agent();
    const split = !goto && ["ctrl-v/s", `split (${this.splitEditor[0].split("/").pop()})`];
    const pairs = goto ? [["enter", "go"], ["ctrl-n/p", "move"], ["esc", "close"]]
      : agent ? [["enter", `@ in ${paneName(agent)}`], ["ctrl-o", this.editorName()], split]
      : [["enter", `${this.editorName()} (no agent in this tab)`], split];
    return h_flex().h(24).flex_none().px(12).gap(14).items_center().border_t(1).border_color(t.border).text_size(11.5)
      .children(pairs.map(([k, what]) => h_flex().flex_none().gap(5).child(div().text_color(t.accent).child(k)).child(div().text_color(t.dim).child(what))));
  }

  // A snacks window: a rounded box with its title cut into the top border.
  box(t, id, title, body) {
    return div().id(id).relative().flex_1().min_w(0).h_full()
      .child(v_flex().size_full().rounded(6).border_1().border_color(t.accent).bg(t.background).overflow_hidden().child(body))
      .child(h_flex().absolute().top(-9).left(0).w_full().justify_center()
        .child(div().px(6).bg(t.background).text_size(12.5).font_bold().text_color(t.accent).child(title)));
  }

  row(t, r, i) {
    const on = i === this.at;
    const tree = r.e?.guide && !this.query.trim();
    const [glyph, color] = r.e ? KIND[r.e.kind] : iconOf(r.path);
    const text = tree && r.e.kind === "Tab" ? r.e.name : r.e ? r.e.title : r.path;
    const el = h_flex().id(`r-${i}`).h(ROW_H).flex_none().px(10).gap(8).items_center().cursor_pointer()
      .when(on, (el) => el.bg(t.hover)).when(!on, (el) => el.hover((s) => s.bg(t.hover)))
      .on_click((e, cx) => {
        if (this.at === i && e.click_count > 1) return this.source === "goto" ? this.go() : this.mention(cx);
        this.at = i;
        this.sync(cx);
      });
    // The explorer's look: guides, an open folder per space, the lead program per tab.
    if (tree) {
      const space = r.e.kind === "Space";
      return el.gap(6)
        .child(div().flex_none().text_color(t.dim + "80").child(r.e.guide))
        .when(space, (el) => el.child(div().flex_none().text_color(t.dim).child("\u{F47C}")).child(div().flex_none().text_color(t.ansi4).child("\u{F0770}")))
        .when(!space, (el) => el.child(r.e.lead ? programIcon(t, r.e.lead) : div().flex_none().text_color(t.ansi2).child("\u{F489}")))
        .child(div().flex_1().min_w(0).truncate().text_color(on ? t.foreground : t.muted).when(space, (el) => el.font_bold()).child(text))
        .when(space && Boolean(r.e.space.machine), (el) => el.child(div().flex_none().text_color(t.dim).child(`\u{F048B} ${r.e.space.machine}`)))
        .when(space && Boolean(r.e.space.branch), (el) => el.child(div().flex_none().max_w(140).truncate().text_color(t.ansi5).child(`\u{E0A0} ${r.e.space.branch}`)))
        .when(!space && r.e.panes.length > 1, (el) => el.child(div().flex_none().text_color(t.dim).child(`${r.e.panes.length}`)))
        .children(opt(sign(t, r.e.status)));
    }
    return el
      .child(div().w(14).flex_none().text_color(t[color] ?? t.muted).child(glyph))
      .child(div().flex_1().min_w(0).child(this.label(t, text, r.hits, on, r.e ? 0 : r.path.lastIndexOf("/") + 1)))
      .when(Boolean(r.e), (el) => el.children(opt(sign(t, r.e.status))).child(div().w(44).flex_none().text_color(t.dim).child(r.e.kind === "New" ? "" : r.e.kind)));
  }

  // One pane in Go to's preview: a winbar over its screen's last lines, the
  // given count of them (a card in a space's overview), else as many as fit.
  paneView(t, p, lines) {
    const text = p.terminal ? (this.screens[p.terminal] ?? "").split("\n").slice(-(lines ?? 80)) : [];
    return v_flex().id(`s-${p.pane}`).when(Boolean(lines), (el) => el.flex_none()).when(!lines, (el) => el.flex_1().min_h(0))
      .child(h_flex().h(22).flex_none().px(10).gap(6).items_center().bg(t.chrome).text_size(12)
        .child(programIcon(t, p))
        .child(div().flex_none().font_bold().child(paneName(p)))
        .children(opt(sign(t, p.status)))
        .child(div().flex_1().min_w(0).truncate().text_color(t.dim).child(p.cwd?.replace(home(), "~") ?? "")))
      .child(v_flex().px(10).py(4).justify_end().overflow_hidden().text_size(12).text_color(t.muted)
        .when(Boolean(lines), (el) => el.h(lines * 16 + 8)).when(!lines, (el) => el.flex_1().min_h(0))
        .children(p.terminal ? text.map((line) => div().flex_none().h(16).whitespace_nowrap().child(line || " "))
          : [div().text_color(t.dim).child(p.mod ?? "")]));
  }

  // Go to's preview. A tab or an agent: its panes stacked, filling the box
  // (14 lines each in a scroll past three). A space: where it is, then each
  // tab as a card of its panes' last 8 lines, scrolling.
  screensView(t, e) {
    if (!e?.panes.length) return div().p(12).text_size(12.5).text_color(t.dim).child(e ? "Nothing running yet" : "");
    const sep = (el, i) => (i > 0 ? el.border_t(1).border_color(t.border) : el);
    if (!e.space) {
      const many = e.panes.length > 3;
      return v_flex().id("screens").size_full().when(many, (el) => el.overflow_y_scrollbar())
        .children(e.panes.map((p, i) => sep(this.paneView(t, p, many ? 14 : null), i)));
    }
    const s = e.space;
    return v_flex().id("screens").size_full().overflow_y_scrollbar().p(10).gap(10)
      .child(h_flex().flex_none().gap(10).items_center().text_size(12).text_color(t.dim)
        .child(div().flex_none().font_bold().text_color(t.foreground).child(s.name))
        .children(opt(s.machine && div().flex_none().child(`\u{F048B} ${s.machine}`)))
        .children(opt(s.branch && div().flex_none().text_color(t.ansi5).child(`\u{E0A0} ${s.branch}`)))
        .child(div().flex_1().min_w(0).truncate().child((e.panes[0]?.cwd ?? s.folder).replace(home(), "~"))))
      .children(e.tabs.map((x) => v_flex().id(`tab-${x.tab.id}`).flex_none().rounded(4).border_1().border_color(x.tab.active ? t.accent : t.border).overflow_hidden()
        .child(h_flex().h(22).flex_none().px(10).gap(6).items_center().bg(t.background).text_size(12)
          .child(div().flex_none().text_color(t.ansi2).child(KIND.Tab[0]))
          .child(div().flex_none().font_bold().child(x.name))
          .children(opt(sign(t, x.tab.status)))
          .child(div().flex_1())
          .child(div().flex_none().text_color(t.dim).child(`${x.panes.length} pane${x.panes.length === 1 ? "" : "s"}${x.tab.active ? " · shown" : ""}`)))
        .children(x.panes.map((p, i) => sep(this.paneView(t, p, 8), i)))));
  }

  render() {
    const t = theme();
    const goto = this.source === "goto";
    if (goto) this.rank(); // spaces, tabs and agents change while it's open
    const rows = this.ranked;
    this.at = Math.min(this.at, Math.max(0, rows.length - 1));
    if (this.at < this.top) this.top = this.at;
    if (this.at >= this.top + this.shown) this.top = this.at - this.shown + 1;
    this.top = Math.max(0, Math.min(this.top, rows.length - this.shown));
    const total = goto ? null : this.files?.length;
    const count = !goto && this.files === null ? "…" : goto ? `${rows.length}` : `${rows.length}/${total}`;
    const list = v_flex().id("picker-list").flex_1().min_h(0).py(4).text_size(12.5)
      .on_size_change((size, cx) => {
        const n = Math.max(1, Math.floor((size.height - 8) / ROW_H));
        if (n !== this.shown) { this.shown = n; cx.notify(); }
      })
      .on_scroll_wheel((e, cx) => { if (Math.abs(e.delta.y) >= 1) this.move(e.delta.y > 0 ? -1 : 1, cx); })
      .children(rows.slice(this.top, this.top + this.shown).map((r, j) => this.row(t, r, this.top + j)))
      .when((goto || this.files !== null) && rows.length === 0, (el) => el.child(div().px(12).text_color(t.dim).child(goto || this.files.length ? "No match" : "No files")));
    const picker = v_flex().size_full()
      .child(h_flex().h(32).flex_none().px(12).gap(10).items_center().border_b(1).border_color(t.accent)
        .child(div().flex_none().text_color(t.accent).child(goto ? "\u{F0219}" : "\u{F054}"))
        .child(Input.new(this.input).flex_1().h_full().text_size(13).text_color(t.foreground))
        .child(div().flex_none().text_size(12).text_color(t.dim).child(count)))
      .child(list)
      .child(this.keysHint(t, goto));
    const sel = rows[this.at];
    const preview = goto ? this.screensView(t, sel?.e)
      : this.code ? Editor.new(this.code).size_full()
      : this.picture ? h_flex().size_full().p(16).items_center().justify_center().child(image(this.picture).max_w_full().max_h_full())
      : div().p(12).text_size(12.5).text_color(t.dim).child(this.note ?? (this.file ? "Loading…" : ""));
    const title = goto ? (sel?.e.title ?? "Preview") : this.file ? this.file.split("/").pop() : "Preview";
    // The input lets go of the keyboard on any press beside it; take it back once the press is over.
    return h_flex().id("lazyvim-picker").size_full().gap(10).pt(10).text_color(t.foreground)
      .on_mouse_up("left", () => this.input.focus())
      .on_key_down((e, cx) => {
        const k = e.key, m = e.modifiers ?? {};
        if (k === "escape") return this.dismiss();
        // ctrl-o, not ctrl-e: the input keeps ctrl-e (end of line) for itself.
        if (!goto && m.control && (k === "o" || k === "v" || k === "s")) {
          cx.stop_propagation();
          return this.open({ o: null, v: "right", s: "down" }[k], cx);
        }
        // snacks' list keys: ctrl-n / ctrl-j down, ctrl-p / ctrl-k up.
        if (k === "down" || (k === "tab" && !m.shift) || (m.control && (k === "n" || k === "j"))) this.move(1, cx);
        else if (k === "up" || (k === "tab" && m.shift) || (m.control && (k === "p" || k === "k"))) this.move(-1, cx);
        else if (k === "pagedown") this.move(this.shown, cx);
        else if (k === "pageup") this.move(-this.shown, cx);
        else return;
        cx.stop_propagation();
      })
      // A click on the list (or Go to's preview) gives the keyboard back to the input.
      .child(this.box(t, "picker-list-box", goto ? "Go to" : "Files", picker))
      // The code preview keeps its clicks (select, copy); anywhere else gives the keyboard back.
      .child(this.box(t, "picker-preview-box", title, preview).when(!goto, (el) => el.on_mouse_up("left", (_e, cx) => cx.stop_propagation())));
  }
}
