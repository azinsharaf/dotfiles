// LazyVim's notifications for Herdr: snacks.notifier's compact style, as the layout's
// "toast" mod, so it draws Herdr's own toasts (agent done or blocked, errors) and every
// notify(). A rounded box with its border in the level's color, the level icon and the
// title cut into the top border, the body under it. Click runs its action and closes.

import { View, div, image } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { props, closeOverlay, run, theme } from "herdr";

// snacks' icons and tokyonight's diagnostic colors per level.
const LEVEL = {
  error: ["\u{F0159}", "ansi1"],
  warning: ["\u{F0026}", "ansi3"],
  success: ["\u{F05E0}", "ansi2"],
  info: ["\u{F02FC}", "ansi6"],
};

export default class Notify extends View {
  render() {
    const t = theme();
    const p = props() ?? {};
    const [glyph, name] = LEVEL[p.level] ?? LEVEL.info;
    const c = t[name];
    // Herdr frames toasts itself (its border, corners and size), so the box sits inside
    // that frame, inset, flex_1 rather than size_full so its bottom border isn't cut.
    return v_flex().id("notify").relative().size_full().px(6).pt(9).pb(6).bg(t.background).cursor_pointer()
      .on_click(() => {
        if (p.action?.name) run(p.action.name, p.action.args ?? {});
        closeOverlay(p.overlay);
      })
      .child(v_flex().flex_1().min_h(0).justify_center().px(12).rounded(6).border_1().border_color(c).bg(t.background)
        .hover((s) => s.bg(t.hover))
        .child(div().truncate().text_size(12.5).text_color(t.foreground).child(p.body || p.title || "")))
      // The icon and title cut into the top border (inside the frame, so not clipped).
      .child(h_flex().absolute().top(1).left(16).px(4).gap(6).items_center().bg(t.background).text_size(12).text_color(c)
        .child(p.icon ? image(p.icon).w(13).h(13).flex_none() : div().flex_none().child(glyph))
        .when(Boolean(p.body), (el) => el.child(div().font_bold().child(p.title ?? ""))));
  }
}
