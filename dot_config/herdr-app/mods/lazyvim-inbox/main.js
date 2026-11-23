// Agent inbox: answer an agent without going to it. A dialog holding a layout: the
// agents on the left (this mod, role "list"), the selected one's real terminal on
// the right (native colors, live, typed into directly), under a header (role
// "header"). Herdr fixes a terminal block when the overlay opens, so selecting
// another agent opens the dialog again around it.
// cmd-shift-i (mod.open) lands here without a role: open the dialog, or close it
// when it's already open, and go. Also <leader>ai and the cmdline.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, hc, run, theme, props, openOverlay, closeOverlay, shared, setShared, nextCommand } from "herdr";

const ROW_H = 38;
const SPIN = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
// Most urgent first, like the Trouble list.
const RANK = { blocked: 0, done: 1, working: 2, idle: 3 };
const SAY = { blocked: "needs you", done: "done", working: "working", idle: "idle" };
const BOX = { radius: 6, border: { width: 1, color: "accent" }, background: "background" };

function list() {
  return [...agents()].sort((a, b) => (RANK[a.status] ?? 4) - (RANK[b.status] ?? 4) || b.seq - a.seq);
}

const name = (a) => a?.program?.name ?? a?.app ?? "agent";

// Opens the dialog around an agent (the most urgent when none), then closes the one
// it replaces: open first, so nothing blinks out.
function show(address) {
  const a = list().find((x) => x.address === address) ?? list()[0];
  const prev = shared("lazyvim.inbox");
  const id = openOverlay({
    kind: "dialog", width: 0.72, height: 0.66, frame: "none",
    layout: {
      type: "row", gap: 10,
      children: [
        { type: "block", size: { weight: 2 }, ...BOX, content: { mod: "lazyvim-inbox", props: { role: "list", at: a?.address ?? null } } },
        {
          type: "column", size: { weight: 3 }, ...BOX,
          children: [
            { type: "block", size: { px: 26 }, content: { mod: "lazyvim-inbox", props: { role: "header", at: a?.address ?? null } } },
            a ? { type: "block", padding: [2, 8], content: { terminal: a.address } }
              : { type: "block", content: { mod: "lazyvim-inbox", props: { role: "header", at: null } } },
          ],
        },
      ],
    },
  });
  setShared("lazyvim.inbox", id);
  if (prev) closeOverlay(prev);
}

// Diagnostic signs (copied from lazyvim-picker): error blocked, dot done, spinner working.
function sign(t, status) {
  if (status === "working") return div().w(14).flex_none().text_color(t.working).frames(SPIN, 80);
  if (status === "blocked") return div().w(14).flex_none().text_color(t.blocked).child("\u{F057}");
  if (status === "done") return div().w(14).flex_none().text_color(t.done).child("\u{25CF}");
  return div().w(14).flex_none().text_color(t.dim).child("\u{F04B2}");
}

// The numbered choices a dialog shows ("❯ 1. Yes", "2. No, and tell…"), from the
// screen's last lines: [digit, label].
function choices(screen) {
  const out = [];
  for (const l of screen.split("\n").slice(-15)) {
    const m = /^[\s│|❯>›]*([1-9])[.)]\s+(.+?)\s*[│|]?$/.exec(l);
    if (m && !out.some(([d]) => d === m[1])) out.push([m[1], m[2]]);
  }
  return out;
}

export default class Inbox extends View {
  init(_props, cx) {
    const p = props() ?? {};
    this.role = p.role ?? "open";
    this.at = p.at ?? null;
    if (this.role === "open") {
      // mod.open's own overlay only carried the key here (none under herdr-app check).
      if (p.overlay) closeOverlay(p.overlay);
      const open = shared("lazyvim.inbox");
      if (open) { setShared("lazyvim.inbox", null); return closeOverlay(open); }
      return show(null);
    }
    if (this.role !== "list") return;
    this.picks = [];
    this.note = null;
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(150, () => this.handle.focus());
    // A popup over it closing (the picker, the cmdline) gives the keyboard back.
    cx.spawn(async () => {
      for (;;) if ((await nextCommand()) === "focus") this.handle.focus();
    });
    // A blocked agent's choices, read once: the dialog opens again on each selection.
    cx.spawn(async (cx) => {
      const a = this.current();
      if (a?.status !== "blocked") return;
      const r = await hc(["read", a.address]).catch(() => null);
      this.picks = r?.code === 0 ? choices(r.stdout) : [];
      cx.notify();
    });
  }

  // However the dialog goes (Esc, a click beside it, cmd-shift-i), it's no longer open,
  // unless another one already replaced it.
  async close() {
    if (this.role === "list" && shared("lazyvim.inbox") === props()?.overlay) setShared("lazyvim.inbox", null);
  }

  current() {
    return agents().find((a) => a.address === this.at) ?? null;
  }

  dismiss() {
    setShared("lazyvim.inbox", null);
    closeOverlay(props().overlay);
  }

  move(by) {
    const all = list();
    const i = all.findIndex((a) => a.address === this.at);
    const next = all[Math.max(0, Math.min(i + by, all.length - 1))];
    if (next && next.address !== this.at) show(next.address);
  }

  // Into the agent's terminal, to type there.
  type() {
    if (this.at) run("pane.focus", { terminal: this.at });
  }

  go() {
    const a = this.current();
    if (!a) return;
    this.dismiss();
    run("pane.focus", { pane: a.pane });
  }

  // A dialog choice's digit, pressed in the agent without leaving the list.
  press(d, cx) {
    if (!this.at) return;
    cx.spawn(async (cx) => {
      const r = await hc(["keys", this.at, d]).catch(() => null);
      this.note = r?.code === 0 ? null : `Couldn't press ${d}: ${(r?.stderr || "hc failed").trim()}`;
      cx.notify();
    });
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers ?? {};
    const k = e.key_char ?? e.key;
    if (e.key === "escape" || k === "q") return this.dismiss();
    if (e.key === "down" || k === "j" || (k === "n" && m.control)) return this.move(1);
    if (e.key === "up" || k === "k" || (k === "p" && m.control)) return this.move(-1);
    if (e.key === "enter" || e.key === "tab" || e.key === "right" || k === "i") return this.type();
    if (k === "o") return this.go();
    if (/^[1-9]$/.test(k) && this.current()?.status === "blocked") return this.press(k, cx);
  }

  render() {
    const t = theme();
    if (this.role === "open") return div();
    const a = this.current();
    if (this.role === "header") {
      return h_flex().size_full().px(12).gap(8).items_center().border_b(1).border_color(t.border).text_size(12.5)
        .children(a ? [sign(t, a.status), div().flex_none().font_bold().text_color(t.accent).child(name(a)),
          div().flex_none().text_color(a.status === "blocked" ? t.blocked : t.dim).child(SAY[a.status] ?? ""),
          div().flex_1().min_w(0).truncate().text_color(t.dim).child(a.title && a.title !== name(a) ? a.title : ""),
          div().flex_none().text_size(11.5).text_color(t.dim).child("typing here goes to the agent (esc too)")]
          : [div().text_color(t.dim).child("No agents running.")]);
    }

    const all = list();
    const blocked = all.filter((x) => x.status === "blocked").length;
    const rows = all.map((x, i) => {
      const on = x.address === this.at;
      // A click selects; a click on the selected one goes into its terminal.
      return h_flex().id(`ib-${i}`).h(ROW_H).flex_none().px(12).gap(8).items_center().cursor_pointer()
        .when(on, (el) => el.bg(t.hover)).when(!on, (el) => el.hover((s) => s.bg(t.hover)))
        .on_click(() => (on ? this.type() : show(x.address)))
        .child(sign(t, x.status))
        .child(v_flex().flex_1().min_w(0)
          .child(h_flex().gap(6).child(div().flex_none().text_color(on ? t.foreground : t.muted).when(on, (el) => el.font_bold()).child(name(x)))
            .child(div().min_w(0).truncate().text_color(t.dim).child(x.title && x.title !== name(x) ? x.title : "")))
          .child(div().truncate().text_size(11.5).text_color(t.dim).child(`${x.space_name} \u{203A} ${x.tab_name}`)))
        .child(div().flex_none().text_size(11.5).text_color(x.status === "blocked" ? t.blocked : t.dim).child(SAY[x.status] ?? ""));
    });
    const picks = a?.status === "blocked" ? this.picks : [];
    const pick = ([d, label]) => h_flex().id(`ib-c-${d}`).flex_none().max_w(240).px(8).h(22).gap(6).items_center().rounded(4).cursor_pointer()
      .bg(t.raised).hover((s) => s.bg(t.hover)).on_click((_e, cx) => this.press(d, cx))
      .child(div().flex_none().text_color(t.ansi4).child(d))
      .child(div().min_w(0).truncate().text_color(t.foreground).child(label));
    const keys = [["enter", "type"], ["j/k", "agent"], ["1-9", "choose"], ["o", "go to"], ["esc", "close"]];
    return v_flex().id("inbox").size_full().text_color(t.foreground)
      .track_focus(this.handle)
      .on_mouse_down("left", () => this.handle.focus())
      .on_key_down((e, cx) => this.key(e, cx))
      .child(h_flex().h(26).flex_none().px(12).items_center().border_b(1).border_color(t.border).text_size(12.5).font_bold().text_color(t.accent)
        .child(blocked ? `Agents \u{00B7} ${blocked} need${blocked === 1 ? "s" : ""} you` : "Agents"))
      .child(v_flex().id("ib-list").flex_1().min_h(0).py(4).overflow_y_scrollbar().text_size(12.5)
        .when(!all.length, (el) => el.child(div().px(12).py(8).text_color(t.dim).child("No agents running.")))
        .children(rows))
      .when(picks.length > 0, (el) => el.child(h_flex().flex_none().flex_wrap().px(10).py(6).gap(6).border_t(1).border_color(t.border).text_size(11.5).children(picks.map(pick))))
      .when(Boolean(this.note), (el) => el.child(div().px(12).pb(4).text_size(11.5).text_color(t.dim).child(this.note)))
      .child(h_flex().h(24).flex_none().px(12).gap(14).items_center().border_t(1).border_color(t.border).text_size(11.5)
        .children(keys.map(([k, what]) => h_flex().flex_none().gap(5).child(div().text_color(t.accent).child(k)).child(div().text_color(t.dim).child(what)))));
  }
}
