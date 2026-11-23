# Herdr LazyVim layout: lualine shows INSERT while the prompt has text.
# Source from ~/.zshrc:  source ~/.config/herdr-app/mods/lazyvim/insert.zsh
# Herdr can't see keystrokes, so the shell says it through the terminal title
# ("lv:insert"); the lazyvim mod reads it. Only runs inside Herdr terminals.
[[ -n $HC_TERMINAL_SOCKET ]] || return

typeset -g _lv_state=""
_lv_redraw() {
  local want=normal
  [[ -n $BUFFER ]] && want=insert
  [[ $want == $_lv_state ]] && return
  _lv_state=$want
  if [[ $want == insert ]]; then print -n "\e]2;lv:insert\a"; else print -Pn "\e]2;%~\a"; fi
}
# A running command gets its own title back (and never keeps the marker).
_lv_preexec() { _lv_state=""; print -rn -- $'\e]2;'"$1"$'\a'; }

autoload -Uz add-zle-hook-widget add-zsh-hook
add-zle-hook-widget line-init _lv_redraw
add-zle-hook-widget line-pre-redraw _lv_redraw
add-zsh-hook preexec _lv_preexec
