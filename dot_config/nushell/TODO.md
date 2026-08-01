# Nushell config TODOs

- [x] simplify: minimal config.nu, drop env.nu and theme
- [x] 1- remove welcome
- [x] 2- remove datetime in shell
- [x] 3- add starship (already installed)
- [x] add to path:'\scoop\apps\perl\current\perl\bin',
- [x] add tokyo night theme
- [x] fix XDG_CONFIG_HOME: enable chezmoi templating (env.nu -> env.nu.tmpl), drop hardcoded HOME
- [x] carapace.nu: fix $env.Path -> $env.path typo
- [x] add ZELLIJ_CONFIG_DIR env variable
      add $COLORTERM     = 'truecolor'
add $TMP = _h + r'\.tmp'
      add $TMPDIR        = _h + r'\.tmp'
add $MPV_HOME = _h + r'\.config\mpv'
      add $YOUTUBETUI_CONFIG_HOME = _h + r'\.config\youtube-tui'

add $KOMOREBI_CONFIG_HOME    = _h + r'\.config\komorebi'
add $KOMOREBI_AHK_EXE = _h + r'\scoop\apps\autohotkey\current\UX\AutoHotkeyUX.exe'
add
$STARSHIP_CONFIG = _h + r'\.config\starship\starship.toml'

$BAT_CONFIG_DIR  = _h + r'\.config\bat'
$BAT_CONFIG_PATH = _h + r'\.config\bat\bat.conf'

$YAZI_FILE_ONE    = _h + r'\scoop\apps\git\current\usr\bin\file.exe'
$YAZI_CONFIG_HOME = _h + r'\.config\yazi'
$YAZI_ZOXIDE_OPTS = ' '.join([
"--preview 'eza --color=always --icons --group-directories-first --tree --level=2 {2}'",
"--preview-window=right,40%,border-left",
])

$NEOVIM_NODE_PATH = _h + r'\scoop\apps\nodejs-nightly\current\node.exe'

$CUDA_PATH       = r'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8'
$CUDA_PATH_V12_8 = r'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8'

$EZA_CONFIG_DIR    = _h + r'\.config\eza'
$ZELLIJ_CONFIG_DIR = _h + r'\.config\zellij'

$CARGO_HOME  = _h + r'\.cargo'
$RUSTUP_HOME = _h + r'\.rustup'
$GNUPGHOME = _h + r'\.config\gnupg'

$UV_TOOL_DIR = _h + r'\.venvs'
