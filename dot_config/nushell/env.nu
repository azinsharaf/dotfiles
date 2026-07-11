# env.nu
# Nushell environment setup.
# Ported from xonsh rc.xsh.
# Loaded once at shell startup, before config.nu.

# ----- Locale / display -----
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.COLORTERM = "truecolor"

# ----- Editor -----
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# ----- Shell (point at nushell itself) -----
$env.SHELL = (which nu | get path | first | into string)

# ----- Temp -----
$env.TMP = ($env.USERPROFILE | path join ".tmp")
$env.TMPDIR = ($env.TMP | into string)

# ----- XDG / app config homes -----
$env.XDG_CONFIG_HOME = ($env.USERPROFILE | path join ".config")
$env.MPV_HOME = ($env.USERPROFILE | path join ".config" "mpv")
$env.YOUTUBETUI_CONFIG_HOME = ($env.USERPROFILE | path join ".config" "youtube-tui")

# Komorebi / GlazeWM
$env.KOMOREBI_CONFIG_HOME = ($env.USERPROFILE | path join ".config" "komorebi")
$env.KOMOREBI_AHK_EXE = ($env.USERPROFILE | path join "scoop" "apps" "autohotkey" "current" "UX" "AutoHotkeyUX.exe")
$env.GLAZEWM_CONFIG_PATH = ($env.USERPROFILE | path join ".config" "glazewm" "config.yaml")

# Starship / Bat
$env.STARSHIP_CONFIG = ($env.USERPROFILE | path join ".config" "starship" "starship.toml")
$env.BAT_CONFIG_DIR = ($env.USERPROFILE | path join ".config" "bat")
$env.BAT_CONFIG_PATH = ($env.USERPROFILE | path join ".config" "bat" "bat.conf")

# Yazi
$env.YAZI_FILE_ONE = ($env.USERPROFILE | path join "scoop" "apps" "git" "current" "usr" "bin" "file.exe")
$env.YAZI_CONFIG_HOME = ($env.USERPROFILE | path join ".config" "yazi")
$env.YAZI_ZOXIDE_OPTS = [
    "--preview 'eza --color=always --icons --group-directories-first --tree --level=2 {2}'"
    "--preview-window=right,40%,border-left"
] | str join " "

# Neovim node
$env.NEOVIM_NODE_PATH = ($env.USERPROFILE | path join "scoop" "apps" "nodejs-nightly" "current" "node.exe")

# CUDA
let cuda_path = "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v12.8"
$env.CUDA_PATH = $cuda_path
$env.CUDA_PATH_V12_8 = $cuda_path

# Tool config dirs
$env.EZA_CONFIG_DIR = ($env.USERPROFILE | path join ".config" "eza")

# Eza color scheme: Tokyo Night (Night variant).
# Eza loads $EZA_CONFIG_DIR/theme.yml when $EZA_THEME is set to its basename (no .yml).
# Format reference: https://github.com/eza-community/eza/blob/main/man/eza_themes.5.md
$env.EZA_THEME = "theme"
$env.ZELLIJ_CONFIG_DIR = ($env.USERPROFILE | path join ".config" "zellij")

# Tool homes
$env.CARGO_HOME = ($env.USERPROFILE | path join ".cargo")
$env.RUSTUP_HOME = ($env.USERPROFILE | path join ".rustup")
$env.GNUPGHOME = ($env.USERPROFILE | path join ".config" "gnupg")
$env.UV_TOOL_DIR = ($env.USERPROFILE | path join ".venvs")

# Zoxide hook — register PWD tracking
# (zoxide init nushell output, embedded so it survives `nu -c` runs)
export-env {
    $env.config = (
        $env.config?
        | default {}
        | upsert hooks { default {} }
        | upsert hooks.env_change { default {} }
        | upsert hooks.env_change.PWD { default [] }
    )
    let __zoxide_hooked = (
        $env.config.hooks.env_change.PWD | any { try { get __zoxide_hook } catch { false } }
    )
    if not $__zoxide_hooked {
        $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append {
            __zoxide_hook: true,
            code: {|_, dir| ^zoxide add -- $dir}
        })
    }
}

# ----- PATH: prepend (high priority) -----
# Commented out: conda env activation (ca) now manages PATH via `def --env`.
# $env.Path = ([
#     ($env.USERPROFILE | path join ".venvs" "xonsh" "Scripts")
#     ($env.USERPROFILE | path join "scoop" "shims")
#     ($env.USERPROFILE | path join "scoop" "apps" "miniconda3" "current")
#     ($env.USERPROFILE | path join "scoop" "apps" "miniconda3" "current" "Scripts")
#     ($env.USERPROFILE | path join "scoop" "apps" "miniconda3" "current" "condabin")
# ] | append $env.Path)

# ----- PATH: append (low priority) -----
$env.Path = ($env.Path | append [
    ($env.USERPROFILE | path join ".cargo" "bin")
    ($env.USERPROFILE | path join ".local" "bin")
    ($env.USERPROFILE | path join "gdal-env" ".pixi" "envs" "default" "Library" "bin")
    ($env.USERPROFILE | path join "pdal-env" ".pixi" "envs" "default" "Library" "bin")
    ($env.USERPROFILE | path join "scoop" "apps" "perl" "current" "perl" "bin")
    "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v12.8\\bin"
    "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v12.8\\libnvvp"
    "C:\\Program Files (x86)\\NVIDIA Corporation\\PhysX\\Common"
    "C:\\Program Files\\NVIDIA Corporation\\Nsight Compute 2025.1.0"
    "C:\\Program Files\\ImageMagick-7.1.2-Q16-HDRI"
    ($env.USERPROFILE | path join "AppData" "Local" "pnpm")
    ($env.USERPROFILE | path join "go" "bin")
])
