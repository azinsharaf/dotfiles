# Tokyo Night theme for qutebrowser

# Installation:
# 1. Save this file to ~/.qutebrowser/tokyonight.py
# 2. Add this line to your qutebrowser config.py:
#    config.source('~/.qutebrowser/tokyonight.py')
# 3. Restart qutebrowser or run :config-source

# Tokyo Night Night palette (colors based on folke/tokyonight.nvim)
bg = "#1a1b26"
bg_dark = "#16161e"
bg_highlight = "#292e42"
bg_popup = "#16161e"
bg_statusline = "#16161e"
bg_visual = "#364a82"
black = "#15161e"
blue = "#7aa2f7"
border = "#15161e"
border_highlight = "#27a1b9"
cyan = "#7dcfff"
dark3 = "#545c7e"
dark5 = "#737aa2"
error = "#db4b4b"
fg = "#c0caf5"
fg_gutter = "#3b4261"
green = "#9ece6a"
green1 = "#73daca"
info = "#0db9d7"
magenta = "#bb9af7"
orange = "#ff9e64"
purple = "#9d7cd8"
warning = "#e0af68"
yellow = "#e0af68"

# Qutebrowser color settings
# Completion menu
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg_dark
c.colors.completion.even.bg = bg
c.colors.completion.category.fg = blue
c.colors.completion.category.bg = bg_dark
c.colors.completion.category.border.top = bg_dark
c.colors.completion.category.border.bottom = bg_dark
c.colors.completion.item.selected.fg = fg
c.colors.completion.item.selected.bg = bg_visual
c.colors.completion.item.selected.border.top = bg_visual
c.colors.completion.item.selected.border.bottom = bg_visual
c.colors.completion.item.selected.match.fg = orange
c.colors.completion.match.fg = orange
c.colors.completion.scrollbar.fg = fg_gutter
c.colors.completion.scrollbar.bg = bg_dark

# Context menu
c.colors.contextmenu.disabled.bg = bg_dark
c.colors.contextmenu.disabled.fg = dark5
c.colors.contextmenu.menu.bg = bg_popup
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = bg_visual
c.colors.contextmenu.selected.fg = fg

# Downloads
c.colors.downloads.bar.bg = bg_statusline
c.colors.downloads.start.fg = bg
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = bg
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = error

# Hints
c.colors.hints.fg = bg
c.colors.hints.bg = yellow
c.colors.hints.match.fg = green

# Keyhint widget
c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = yellow
c.colors.keyhint.bg = bg_popup

# Messages
c.colors.messages.error.fg = error
c.colors.messages.error.bg = bg
c.colors.messages.error.border = error
c.colors.messages.warning.fg = warning
c.colors.messages.warning.bg = bg
c.colors.messages.warning.border = warning
c.colors.messages.info.fg = info
c.colors.messages.info.bg = bg
c.colors.messages.info.border = info

# Prompts
c.colors.prompts.fg = fg
c.colors.prompts.border = border_highlight
c.colors.prompts.bg = bg_popup
c.colors.prompts.selected.bg = bg_visual
c.colors.prompts.selected.fg = fg

# Statusbar (matches tokyonight.nvim StatusLine highlight)
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.insert.fg = green
c.colors.statusbar.insert.bg = bg_highlight
c.colors.statusbar.passthrough.fg = error
c.colors.statusbar.passthrough.bg = bg_highlight
c.colors.statusbar.private.fg = purple
c.colors.statusbar.private.bg = bg_highlight
c.colors.statusbar.command.fg = yellow
c.colors.statusbar.command.bg = bg_statusline
c.colors.statusbar.command.private.fg = purple
c.colors.statusbar.command.private.bg = bg_highlight
c.colors.statusbar.caret.fg = magenta
c.colors.statusbar.caret.bg = bg_highlight
c.colors.statusbar.caret.selection.fg = cyan
c.colors.statusbar.caret.selection.bg = bg_highlight
c.colors.statusbar.progress.bg = blue
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.error.fg = error
c.colors.statusbar.url.hover.fg = cyan
c.colors.statusbar.url.success.http.fg = orange
c.colors.statusbar.url.success.https.fg = green1
c.colors.statusbar.url.warn.fg = warning

# Tabs
c.colors.tabs.bar.bg = black
c.colors.tabs.indicator.start = blue
c.colors.tabs.indicator.stop = green
c.colors.tabs.indicator.error = error
c.colors.tabs.odd.fg = dark3
c.colors.tabs.odd.bg = bg_highlight
c.colors.tabs.even.fg = dark3
c.colors.tabs.even.bg = bg_highlight
c.colors.tabs.pinned.even.bg = bg_highlight
c.colors.tabs.pinned.even.fg = dark3
c.colors.tabs.pinned.odd.bg = bg_highlight
c.colors.tabs.pinned.odd.fg = dark3
c.colors.tabs.pinned.selected.even.fg = bg
c.colors.tabs.pinned.selected.even.bg = magenta
c.colors.tabs.pinned.selected.odd.fg = bg
c.colors.tabs.pinned.selected.odd.bg = magenta
c.colors.tabs.selected.odd.fg = bg
c.colors.tabs.selected.odd.bg = magenta
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.selected.even.bg = magenta

# Tooltips
c.colors.tooltip.bg = bg_popup
c.colors.tooltip.fg = fg
