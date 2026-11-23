// Send context to the tab's agent: another pane's output, or the git diff where the
// agent works, pasted into its prompt as a fenced block and left for you to finish
// (nothing is sent). noice's popup over blink's menu, like the cmdline.
// Opened from <leader>as and the cmdline.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { panes, spaces, exec, hc, run, theme, props, closeOverlay, setShared, window as win } from "herdr";

const ROW_H = 24;
const ROW2_H = 38; // a pane's row: its name over its last line
const LINES = 80; // a pane's last lines sent
const DIFF_MAX = 400; // a diff's lines sent, at most

// Puts text on the clipboard (copied from lazyvim-picker): hc can't type text
// without Enter, so it goes through the clipboard and terminal.paste.
function copy(text) {
  if (win()?.platform === "windows") return exec("powershell", ["-NoProfile", "-Command", "Set-Clipboard -Value $args[0]", text]);
  const to = win()?.platform === "macos" ? "pbcopy" : "wl-copy 2>/dev/null || xclip -selection clipboard";
  return exec("sh", ["-c", `printf %s "$1" | { ${to}; }`, "copy", text]);
}

// Names as the explorer shows them (copied from mods/lazyvim).
function paneName(p) {
  if (p.program?.agent) return p.program.name;
  if (p.program?.shell) return p.cwd?.split("/").filter(Boolean).pop() ?? "~";
  return p.title || p.program?.name || "shell";
}

// The shown tab's agent: the focused one, else the first.
function target() {
  const tab = spaces().find((s) => s.active)?.tabs.find((t) => t.active);
  const ps = panes().filter((p) => p.tab === tab?.id && p.terminal && p.program?.agent);
  return ps.find((p) => p.focused) ?? ps[0] ?? null;
}

// A diff line's color, like nvim's diff highlights: [color, bold].
function diffColor(t, l) {
  if (/^(diff --git|index |--- |\+\+\+ )/.test(l)) return [t.foreground, true];
  if (l.startsWith("@@")) return [t.ansi6, false];
  if (l.startsWith("+")) return [t.ansi2, false];
  if (l.startsWith("-")) return [t.ansi1, false];
  return [null, false];
}

const fence = (title, body, lang = "") => `${title}\n\`\`\`${lang}\n${body}\n\`\`\`\n`;
const cap = (text, n) => {
  const lines = text.split("\n");
  return lines.length > n ? `${lines.slice(0, n).join("\n")}\n… (${lines.length - n} more lines)` : text;
};

export default class Context extends View {
  init(_props, cx) {
    this.agent = target();
    this.at = 0;
    this.note = null; // what went wrong, shown under the box
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    // Every terminal pane of the shown space but the agent, the tab's first.
    const space = spaces().find((s) => s.active);
    const tab = space?.tabs.find((t) => t.active);
    const others = panes().filter((p) => space?.tabs.some((t) => t.id === p.tab) && p.terminal && p.pane !== this.agent?.pane)
      .sort((a, b) => (b.tab === tab?.id) - (a.tab === tab?.id));
    const where = this.agent?.cwd;
    // Panes often share a name (two shells in one repo): number the repeats, and say which tab.
    const seen = {};
    const label = (p) => {
      const key = `${p.tab}:${paneName(p)}`;
      seen[key] = (seen[key] ?? 0) + 1;
      return seen[key] > 1 ? `${paneName(p)} #${seen[key]}` : paneName(p);
    };
    // Another tab by its bufferline name: its own, else its first pane's.
    const tabName = (id) => {
      const t = space.tabs.find((x) => x.id === id);
      const lead = panes().find((p) => p.tab === id);
      return t?.named ? t.name : lead ? paneName(lead) : `tab ${t?.index}`;
    };
    this.sources = [
      ...others.map((p) => ({
        pane: p, icon: "\u{F489}", color: "ansi2", title: `Output of ${label(p)}`,
        hint: p.tab === tab?.id ? "this tab" : `in ${tabName(p.tab)}`,
        last: "",
        text: async () => {
          const r = await hc(["read", p.terminal, "--lines", String(LINES)]);
          // hc notes its own limits ("[hc] incomplete: …"): not the pane's output.
          const body = r.stdout.split("\n").filter((l) => !l.startsWith("[hc] ")).join("\n").replace(/\s+$/, "").split("\n").slice(-LINES).join("\n");
          return body && fence(`Output of \`${paneName(p)}\`${p.cwd ? ` in ${p.cwd}` : ""}:`, body, "text");
        },
      })),
      ...(where ? [
        { icon: "\u{F02A2}", color: "ansi5", title: "Git diff", hint: "unstaged", args: ["diff"] },
        { icon: "\u{F02A2}", color: "ansi5", title: "Git diff (staged)", hint: "staged", args: ["diff", "--staged"] },
      ].map((s) => ({
        ...s,
        text: async () => {
          const r = await exec("git", s.args, { cwd: where });
          if (r.code !== 0) return null;
          return r.stdout.trim() && fence(`\`git ${s.args.join(" ")}\` in ${where}:`, cap(r.stdout.trim(), DIFF_MAX), "diff");
        },
      })) : []),
    ];
    // The first preview straight away.
    cx.spawn(async (cx) => this.text(0, cx));
    // Each pane's last line under its name, to tell two shells in one repo apart.
    for (const s of this.sources.filter((s) => s.pane)) {
      cx.spawn(async (cx) => {
        const r = await hc(["read", s.pane.terminal]).catch(() => null);
        // Not a bare prompt (`❯`, `$`): the last line saying something.
        s.last = (r?.stdout ?? "").split("\n").map((l) => l.trim()).filter((l) => l.length > 2).pop() ?? "";
        cx.notify();
      });
    }
    // Their numbers on the panes' winbars (the lazyvim mod draws flash labels), ➜ on the agent.
    setShared("lazyvim.flash", Object.fromEntries([
      ...this.sources.flatMap((s, i) => (s.pane && i < 9 ? [[s.pane.pane, String(i + 1)]] : [])),
      ...(this.agent ? [[this.agent.pane, "\u{279C}"]] : []),
    ]));
    // The diffs' size as their hint, like blink's detail column.
    for (const s of this.sources.filter((s) => s.args)) {
      cx.spawn(async (cx) => {
        const r = await exec("git", [...s.args, "--shortstat"], { cwd: where }).catch(() => null);
        // " 2 files changed, 20 insertions(+), 3 deletions(-)" as "+20 −3 · 2 files".
        const n = (re) => Number(re.exec(r?.stdout ?? "")?.[1] ?? 0);
        const files = n(/(\d+) files? changed/), add = n(/(\d+) insertion/), del = n(/(\d+) deletion/);
        s.hint = r?.code !== 0 ? "not a repo" : files ? `+${add} \u{2212}${del} \u{00B7} ${files} file${files === 1 ? "" : "s"}` : "nothing";
        cx.notify();
      });
    }
  }

  // Herdr calls this however the popup goes.
  async close() {
    setShared("lazyvim.flash", null);
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  // What a source pastes, built once when it's first selected, then kept: the preview
  // shows it and Enter sends the same text.
  text(i, cx) {
    const s = this.sources[i];
    if (!s || s.got) return s?.got;
    s.got = s.text().catch(() => "").then((text) => { s.ready = text || ""; cx.notify(); return s.ready; });
    return s.got;
  }

  select(i, cx) {
    this.at = Math.max(0, Math.min(i, this.sources.length - 1));
    cx.spawn(async (cx) => this.text(this.at, cx));
    cx.notify();
  }

  send(i, cx) {
    const s = this.sources[i];
    if (!s || !this.agent) return;
    const agent = this.agent;
    // The work first: tasks stop once the overlay closes.
    cx.spawn(async (cx) => {
      const text = await this.text(i, cx);
      if (!text) { this.note = `${s.title}: nothing to send`; return cx.notify(); }
      const r = await copy(`${text}\n`).catch(() => null);
      this.dismiss();
      run("pane.focus", { pane: agent.pane });
      if (r?.code === 0) run("terminal.paste");
    });
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers ?? {};
    const k = e.key_char ?? e.key;
    if (e.key === "escape") return this.dismiss();
    if (e.key === "enter") return this.send(this.at, cx);
    if (e.key === "down" || k === "j" || (k === "n" && m.control) || (e.key === "tab" && !m.shift)) this.select(this.at + 1, cx);
    else if (e.key === "up" || k === "k" || (k === "p" && m.control) || (e.key === "tab" && m.shift)) this.select(this.at - 1, cx);
    else if (/^[1-9]$/.test(k) && Number(k) <= this.sources.length) this.send(Number(k) - 1, cx);
  }

  // A snacks window (as in lazyvim-picker): a rounded box with its title cut into the top border.
  box(t, id, title, body) {
    return div().id(id).relative().flex_1().min_w(0).h_full()
      .child(v_flex().size_full().rounded(6).border_1().border_color(t.accent).bg(t.background).overflow_hidden().child(body))
      .child(h_flex().absolute().top(-9).left(0).w_full().justify_center()
        .child(div().px(6).bg(t.background).text_size(12.5).font_bold().text_color(t.accent).child(title)));
  }

  render() {
    const t = theme();
    const title = this.agent ? `Send to ${paneName(this.agent)}` : "Send context";
    const rows = this.sources.map((s, i) => {
      const on = i === this.at;
      // A click selects (the preview follows); a click on the selected one sends it.
      return h_flex().id(`ctx-${i}`).h(s.pane ? ROW2_H : ROW_H).flex_none().px(12).gap(8).items_center().cursor_pointer()
        .when(on, (el) => el.bg(t.hover)).when(!on, (el) => el.hover((st) => st.bg(t.hover)))
        .on_click((_e, cx) => (on ? this.send(i, cx) : this.select(i, cx)))
        .child(div().w(14).flex_none().text_color(t.dim).child(i < 9 ? String(i + 1) : ""))
        .child(div().w(16).flex_none().text_color(t[s.color]).child(s.icon))
        .child(v_flex().flex_1().min_w(0)
          .child(div().truncate().text_color(on ? t.foreground : t.muted).when(on, (el) => el.font_bold()).child(s.title))
          .when(Boolean(s.last), (el) => el.child(div().truncate().text_size(11.5).text_color(t.dim).child(s.last))))
        .child(div().flex_none().text_color(t.dim).child(s.hint ?? ""));
    });
    const say = (text) => div().px(12).py(8).text_size(12).text_color(t.dim).child(text);
    const keys = [["enter", "paste, not sent"], ["1-9", "pick"], ["ctrl-n/p", "move"], ["esc", "close"]];
    const list = v_flex().size_full()
      .child(v_flex().id("ctx-list").flex_1().min_h(0).pt(12).pb(4).overflow_y_scrollbar().text_size(12.5)
        .when(!this.agent, (el) => el.child(say("No agent in this tab: open one beside a shell, then try again.")))
        .when(Boolean(this.agent) && rows.length === 0, (el) => el.child(say("Nothing to send: no other pane, and the agent's folder isn't known.")))
        .when(Boolean(this.agent), (el) => el.children(rows)))
      .when(Boolean(this.note), (el) => el.child(say(this.note)))
      .child(h_flex().h(24).flex_none().px(12).gap(14).items_center().border_t(1).border_color(t.border).text_size(11.5)
        .children(keys.map(([k, what]) => h_flex().flex_none().gap(5).child(div().text_color(t.accent).child(k)).child(div().text_color(t.dim).child(what)))))
    // The exact text Enter pastes, as plain text, like Go to's previews.
    const cur = this.sources[this.at];
    const preview = v_flex().id("ctx-preview").size_full().px(10).pt(14).pb(10).overflow_y_scrollbar().text_size(12).text_color(t.muted)
      .when(!cur, (el) => el.child(div().text_color(t.dim).child("")))
      .when(Boolean(cur) && cur.ready === undefined, (el) => el.child(div().text_color(t.dim).child("Loading\u{2026}")))
      .when(Boolean(cur) && cur.ready === "", (el) => el.child(div().text_color(t.dim).child("Nothing to send.")))
      .when(Boolean(cur?.ready), (el) => el.children(cur.ready.split("\n").map((l) => {
        const [color, bold] = cur.args ? diffColor(t, l) : [null, false];
        return div().whitespace_nowrap().when(Boolean(color), (d) => d.text_color(color)).when(bold, (d) => d.font_bold()).child(l || " ");
      })));
    return h_flex().id("context").track_focus(this.handle).size_full().pt(10).gap(10).text_color(t.foreground)
      .on_key_down((e, cx) => this.key(e, cx))
      .child(div().w_2_5().h_full().flex_none().child(this.box(t, "ctx-left", title, list)))
      .child(this.box(t, "ctx-right", cur?.title ?? "Preview", preview));
  }
}
