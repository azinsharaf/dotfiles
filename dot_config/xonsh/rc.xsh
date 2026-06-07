# Syntax highlighting theme (pygments style)
$XONSH_COLOR_STYLE = 'catppuccin-mocha'

# Base

import os as _os
_h = _os.environ['USERPROFILE']

# Starship prompt
xontrib load prompt_starship
# xontrib load xxh
xontrib load coreutils

# Jedi — Python autocompletion (attributes, imports, docstrings)
xontrib load jedi


# General
XONSH_INTERACTIVE = True

# cd behavior
$AUTO_CD = True

# intractive prompt
$SUGGEST_COMMAND = True
$XONSH_HISTORY_MATCH_ANYWHERE = True
$PRETTY_PRINT_RESULTS = True
$AUTO_SUGGEST_IN_COMPLETIONS = True
$VI_MODE = True
$XONSH_USE_SYSTEM_CLIPBOARD = True
$XONSH_PROMPT_CURSOR_SHAPE = 'modal-vi-mode-only'

$XONSH_AUTOPAIR = True


# History
$XONSH_HISTORY_BACKEND = 'json'
$XONSH_HISTORY_SIZE = '10000 commands'
$HISTCONTROL = {'ignoredups', 'ignoreerr'}
$XONSH_HISTORY_MATCH_ANYWHERE = True
$XONSH_HISTORY_SAVE_CWD = True





# Completion
$FUZZY_PATH_COMPLETION = True
$SUBSEQUENCE_PATH_COMPLETION = True
$COMPLETIONS_DISPLAY = 'single'
$COMPLETION_IN_THREAD = True
$XONSH_PROMPT_AUTO_SUGGEST = True
$UPDATE_COMPLETIONS_ON_KEYPRESS = True
$COMPLETIONS_CONFIRM = False
$CMD_COMPLETIONS_SHOW_DESC = True
$COMPLETIONS_DISPLAY = 'single'

# Navigation
$AUTO_PUSHD = True
$DIRSTACK_SIZE = 50
$DOTGLOB = True

# Completion menu style — Catppuccin Mocha
# String keys avoid RuntimeWarning from xonsh's to_dict() when the env var is serialised
$XONSH_STYLE_OVERRIDES = {
    'Token.PTK.CompletionMenu':                         'bg:#313244 #cdd6f4',        # menu background / text
    'Token.PTK.CompletionMenu.Completion':              'bg:#313244 #cdd6f4',        # each item
    'Token.PTK.CompletionMenu.Completion.Current':      'bg:#45475a #cba6f7 bold',   # selected item (mauve)
    'Token.PTK.CompletionMenu.Meta.Completion':         'bg:#313244 #6c7086',        # description text (dimmed)
    'Token.PTK.CompletionMenu.Meta.Completion.Current': 'bg:#45475a #89b4fa',        # selected description (blue)
    'Token.PTK.Scrollbar':                              'bg:#313244',
    'Token.PTK.Scrollbar.Button':                       'bg:#cba6f7',
}

# Input & Display
$XONSH_CTRL_BKSP_DELETION = False
$COLOR_INPUT = True
$PRETTY_PRINT_RESULTS = True
$ENABLE_ASYNC_PROMPT = True

# Environment

$EDITOR        = 'nvim'
$VISUAL        = 'nvim'
$COLORTERM     = 'truecolor'
$SHELL         = _h + r'\.venvs\xonsh\Scripts\xonsh.exe'

$TMP           = _h + r'\.tmp'

$XDG_CONFIG_HOME         = _h + r'\.config'
$MPV_HOME                = _h + r'\.config\mpv'
$YOUTUBETUI_CONFIG_HOME  = _h + r'\.config\youtube-tui'

$KOMOREBI_CONFIG_HOME    = _h + r'\.config\komorebi'
$KOMOREBI_AHK_EXE        = _h + r'\scoop\apps\autohotkey\current\UX\AutoHotkeyUX.exe'

# $GDAL_DRIVER_PATH        = _h + r'\gdal-env\.pixi\envs\default\Library\lib\gdalplugins'
$GLAZEWM_CONFIG_PATH     = _h + r'\.config\glazewm\config.yaml'


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
$GNUPGHOME   = _h + r'\.config\gnupg'

$UV_TOOL_DIR = _h + r'\.venvs'

# PATH

$PATH = [
    # High priority — prepend
    _h + r'\.venvs\xonsh\Scripts',
    _h + r'\scoop\shims',
    # Conda
    _h + r'\scoop\apps\miniconda3\current',
    _h + r'\scoop\apps\miniconda3\current\Scripts',
    _h + r'\scoop\apps\miniconda3\current\condabin',
] + $PATH + [
    # Append the rest
    _h + r'\.cargo\bin',
    _h + r'\.local\bin',

    _h + r'\gdal-env\.pixi\envs\default\Library\bin',
    _h + r'\pdal-env\.pixi\envs\default\Library\bin',
    _h + r'\scoop\apps\perl\current\perl\bin',
    r'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\bin',
    r'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\libnvvp',
    r'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',
    r'C:\Program Files\NVIDIA Corporation\Nsight Compute 2025.1.0',
    r'C:\Program Files\ImageMagick-7.1.2-Q16-HDRI',
    _h + r'\AppData\Local\pnpm',
    _h + r'\go\bin',

]

# Aliases

aliases['ls']  = 'eza --long -a --group-directories-first --icons --color=auto --header'
aliases['ll']  = 'eza -lh'
aliases['la']  = 'eza -lha'
aliases['lt']  = 'eza --tree'
aliases['cat'] = 'bat'
aliases['n']   = 'nvim'
aliases['lg']  = 'lazygit'
aliases['y']   = 'yazi'
aliases[':q']  = 'exit'
aliases['e']   = 'exit'
aliases['c']   = 'clear'
aliases['su']  = 'scoop update'
aliases['ss']  = 'scoop status'
aliases['sua'] = 'scoop update --all'
aliases['tls'] = 'tuios ls'

# Conda activate — directly mutates xonsh env vars using ArcGIS Pro conda for env resolution.
# Does not require a xonsh shell hook (which ArcGIS Pro conda does not ship).
def _ca(args, stdin=None):
    """Activate a conda environment using the ArcGIS Pro conda installation.

    Resolves the environment path via `conda env list --json`, then manually
    mutates $PATH and $CONDA_* variables in the current xonsh process — the
    same logic activate.bat uses in its CONDA_SKIPCHECK fast path.

    Usage: ca [env-name]   (default: arcgispro-py3-clone)
    """
    import json as _json
    import os as _os
    import subprocess as _sp
    import pathlib as _pl

    _CONDA_EXE = r'C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe'
    _env_name  = args[0] if args else 'arcgispro-py3-clone'

    # --- resolve env path ---------------------------------------------------
    _result = _sp.run(
        [_CONDA_EXE, 'env', 'list', '--json'],
        capture_output=True, text=True
    )
    if _result.returncode != 0:
        print(f'ca: conda env list failed:\n{_result.stderr}', file=__import__('sys').stderr)
        return 1

    _envs = _json.loads(_result.stdout).get('envs', [])
    _env_path = None
    for _e in _envs:
        if _os.path.basename(_e) == _env_name or _e == _env_name:
            _env_path = _pl.Path(_e)
            break

    if _env_path is None:
        print(f'ca: environment {_env_name!r} not found. Available envs:', file=__import__('sys').stderr)
        for _e in _envs:
            print(f'  {_os.path.basename(_e)}  ({_e})', file=__import__('sys').stderr)
        return 1

    # --- deactivate current env if one is active ----------------------------
    _prev_prefix = ${...}.get('CONDA_PREFIX', '')
    if _prev_prefix:
        _deact_d = _pl.Path(_prev_prefix) / 'etc' / 'conda' / 'deactivate.d'
        if _deact_d.is_dir():
            for _s in sorted(_deact_d.glob('*.bat')):
                _sp.run([str(_s)], shell=True)
        # strip old env dirs from PATH
        _old_bins = [
            str(_pl.Path(_prev_prefix)),
            str(_pl.Path(_prev_prefix) / 'Library' / 'mingw-w64' / 'bin'),
            str(_pl.Path(_prev_prefix) / 'Library' / 'usr' / 'bin'),
            str(_pl.Path(_prev_prefix) / 'Library' / 'bin'),
            str(_pl.Path(_prev_prefix) / 'Scripts'),
            str(_pl.Path(_prev_prefix) / 'bin'),
        ]
        $PATH = [p for p in $PATH if p not in _old_bins]

    # --- prepend new env dirs to PATH (mirrors activate.bat fast path) ------
    _new_bins = [
        str(_env_path),
        str(_env_path / 'Library' / 'mingw-w64' / 'bin'),
        str(_env_path / 'Library' / 'usr' / 'bin'),
        str(_env_path / 'Library' / 'bin'),
        str(_env_path / 'Scripts'),
        str(_env_path / 'bin'),
    ]
    $PATH = _new_bins + [p for p in $PATH if p not in _new_bins]

    # --- set CONDA_* env vars -----------------------------------------------
    $CONDA_PREFIX      = str(_env_path)
    $CONDA_DEFAULT_ENV = _env_name
    $CONDA_SHLVL       = '1'
    $CONDA_EXE         = _CONDA_EXE
    $CONDA_PROMPT_MODIFIER = f'({_env_name}) '

    # --- run activate.d hooks if any ----------------------------------------
    _act_d = _env_path / 'etc' / 'conda' / 'activate.d'
    if _act_d.is_dir():
        for _s in sorted(_act_d.glob('*.bat')):
            _sp.run([str(_s)], shell=True)

    print(f'activated: {_env_name}  ({_env_path})')

aliases['ca'] = _ca

# Chezmoi shortcuts
aliases['cedit']   = 'chezmoi edit'
aliases['cdiff']   = 'chezmoi diff'
aliases['cstatus'] = 'chezmoi status'
aliases['capply']  = 'chezmoi apply --interactive -v'
aliases['ccd']     = 'chezmoi cd'

# Functions

def touch(file):
    """Create an empty file."""
    import pathlib
    pathlib.Path(file).touch()

def pkill(name):
    """Kill a process by name."""
    import subprocess
    subprocess.run(['taskkill', '/F', '/IM', f'{name}.exe'], capture_output=True)

def pgrep(name):
    """List processes matching name."""
    import subprocess
    result = subprocess.run(['tasklist', '/FI', f'IMAGENAME eq {name}.exe'], capture_output=True, text=True)
    print(result.stdout)

def reload():
    """Re-source xonsh rc file."""
    source ~/.config/xonsh/rc.xsh

def fzfn():
    """Open a file picked with fzf in nvim."""
    file = $(fzf --preview "bat {}").strip()
    if file:
        nvim @(file)

def f():
    """Pick a file with fd | fzf."""
    file = $(fd | fzf).strip()
    if file:
        print(file)

def ai(*args):
    """Run opencode with gpt-4o."""
    msg = ' '.join(args)
    opencode --model openai/gpt-4o run @(msg)

def ai_mini():
    """Open opencode with gpt-4o-mini."""
    opencode --model openai/gpt-4o-mini

def ks():
    """Start Komorebi + AutoHotkey."""
    import time
    komorebic-no-console start --config @($KOMOREBI_CONFIG_HOME + r'\komorebi.json')
    time.sleep(1)
    @($KOMOREBI_AHK_EXE) @($KOMOREBI_CONFIG_HOME + r'\komorebi.ahk')

def ke():
    """Stop Komorebi + AutoHotkey."""
    import subprocess
    komorebic stop
    subprocess.run(['taskkill', '/F', '/IM', 'AutoHotkey*.exe'], capture_output=True)

# Scoop completer — subcommands, flags, and dynamic installed apps / buckets / cache
import re as _re
import time as _time
from xonsh.completers.tools import RichCompletion as _RC

_ANSI_ESCAPE = _re.compile(r'\x1b\[[0-9;]*m')

_scoop_cache = {}  # cleared on every rc.xsh source
_SCOOP_CACHE_TTL = 30  # seconds

def _scoop_cached(key, cmd_tokens):
    """Return cached list of (name, meta) tuples for key, refreshing if stale."""
    now = _time.monotonic()
    if key not in _scoop_cache or now - _scoop_cache[key][0] > _SCOOP_CACHE_TTL:
        try:
            raw = __xonsh__.subproc_captured_stdout(cmd_tokens)
            raw = _ANSI_ESCAPE.sub('', raw)
            lines = raw.strip().splitlines()
            entries = {}
            if key == 'apps':
                # scoop list columns: Name  Version  Source  Updated
                for ln in lines[3:]:
                    parts = ln.split()
                    if parts and not parts[0].startswith('-'):
                        name = parts[0]
                        version = parts[1] if len(parts) > 1 else ''
                        source  = parts[2] if len(parts) > 2 else ''
                        entries[name] = f'{version} [{source}]' if source else version
            elif key == 'buckets':
                for ln in lines:
                    name = ln.strip()
                    if name:
                        entries[name] = 'configured bucket'
            elif key == 'cache':
                # scoop cache show columns: Name  Version  Length
                for ln in lines[2:]:
                    parts = ln.split()
                    if parts and not parts[0].startswith('-'):
                        name    = parts[0]
                        version = parts[1] if len(parts) > 1 else ''
                        size    = parts[2] if len(parts) > 2 else ''
                        entries[name] = f'{version}  {size}'.strip()
            _scoop_cache[key] = (now, entries)
        except Exception:
            _scoop_cache[key] = (now, {})
    return _scoop_cache[key][1]  # dict {name: description}

def _rc(value, desc, prefix):
    return _RC(value, prefix_len=len(prefix), description=desc)

# Subcommands with descriptions
_SCOOP_SUBCMDS = {
    'install':    'Install an app',
    'uninstall':  'Uninstall an app',
    'update':     'Update app(s) or scoop itself',
    'search':     'Search for an app',
    'info':       'Show info about an app',
    'list':       'List installed apps',
    'status':     'Show outdated apps',
    'bucket':     'Manage buckets',
    'cleanup':    'Remove old app versions',
    'cache':      'Manage download cache',
    'checkup':    'Check for potential problems',
    'config':     'Get/set scoop config values',
    'export':     'Export installed apps as JSON',
    'import':     'Import apps from a JSON file',
    'hold':       'Pin an app to prevent updates',
    'unhold':     'Unpin an app',
    'prefix':     'Return install path of an app',
    'reset':      'Reset an app to resolve conflicts',
    'shim':       'Manage shims',
    'virustotal': 'Look up app hash on VirusTotal',
    'depends':    'Show dependencies of an app',
    'cat':        'Show manifest of an app',
    'download':   'Download app files to cache',
    'home':       'Open app homepage in browser',
    'help':       'Show help for a command',
}

# Flags with descriptions
_SCOOP_FLAGS = {
    'install': {
        '--global':           'Install globally for all users',
        '-g':                 'Install globally for all users',
        '--skip':             'Skip hash check',
        '-s':                 'Skip hash check',
        '--arch':             'Force 32/64bit download',
        '-a':                 'Force 32/64bit download',
        '--no-cache':         'Do not use download cache',
        '--no-update-scoop':  'Do not auto-update scoop',
    },
    'uninstall': {
        '--global': 'Uninstall globally installed app',
        '-g':       'Uninstall globally installed app',
        '--purge':  'Remove persisted data too',
        '-p':       'Remove persisted data too',
    },
    'update': {
        '--global':      'Update globally installed app',
        '-g':            'Update globally installed app',
        '--force':       'Force update even if up to date',
        '-f':            'Force update even if up to date',
        '--skip':        'Skip hash check',
        '-s':            'Skip hash check',
        '--quiet':       'Suppress output',
        '-q':            'Suppress output',
        '--all':         'Update all installed apps',
        '-a':            'Update all installed apps',
        '--independent': 'Do not update dependencies',
        '-i':            'Do not update dependencies',
    },
    'search': {
        '--remote': 'Search remote buckets (slower)',
        '-r':       'Search remote buckets (slower)',
    },
    'status': {
        '--local': 'Check local manifests only',
        '-l':      'Check local manifests only',
    },
    'cleanup': {
        '--global': 'Cleanup globally installed apps',
        '-g':       'Cleanup globally installed apps',
        '--cache':  'Remove download cache too',
        '-k':       'Remove download cache too',
        '--all':    'Cleanup all installed apps',
        '-a':       'Cleanup all installed apps',
    },
    'export': {
        '--config': 'Include scoop config in export',
        '-c':       'Include scoop config in export',
    },
    'download': {
        '--no-cache': 'Do not use download cache',
        '--arch':     'Force 32/64bit download',
        '-a':         'Force 32/64bit download',
    },
}

# Bucket subcommands with descriptions
_SCOOP_BUCKET_SUBCMDS = {
    'add':    'Add a bucket',
    'rm':     'Remove a bucket',
    'list':   'List configured buckets',
    'known':  'List known/official buckets',
    'update': 'Update all buckets',
}

# Known public buckets with descriptions
_SCOOP_KNOWN_BUCKETS = {
    'main':         'Default bucket — core apps',
    'extras':       'Apps that do not fit main',
    'versions':     'Alternative/older app versions',
    'nirsoft':      'NirSoft utilities',
    'sysinternals': 'Microsoft Sysinternals tools',
    'php':          'PHP versions',
    'nerd-fonts':   'Nerd Font patched fonts',
    'nonportable':  'Non-portable apps (installers)',
    'java':         'JDK/JRE distributions',
    'games':        'Open-source games',
}

_SCOOP_CACHE_SUBCMDS = {
    'show': 'List cached downloads',
    'rm':   'Remove cached download(s)',
}

def _scoop_completer(prefix, line, begidx, endidx, ctx):
    tokens = line[:endidx].split()
    if not tokens or tokens[0] != 'scoop':
        return set()

    n = len(tokens)
    completing_idx = n - (1 if prefix else 0)

    def _match(mapping):
        return {_rc(k, v, prefix) for k, v in mapping.items() if k.startswith(prefix)}

    # Position 1: subcommand
    if completing_idx == 1:
        return _match(_SCOOP_SUBCMDS), len(prefix)

    subcmd = tokens[1] if n > 1 else ''

    # --- bucket ---
    if subcmd == 'bucket':
        if completing_idx == 2:
            return _match(_SCOOP_BUCKET_SUBCMDS), len(prefix)
        bucket_sub = tokens[2] if n > 2 else ''
        if bucket_sub == 'add':
            return _match(_SCOOP_KNOWN_BUCKETS), len(prefix)
        if bucket_sub == 'rm':
            buckets = _scoop_cached('buckets', ['scoop', 'bucket', 'list'])
            return {_rc(k, v, prefix) for k, v in buckets.items() if k.startswith(prefix)}, len(prefix)
        return set()

    # --- cache ---
    if subcmd == 'cache':
        if completing_idx == 2:
            return _match(_SCOOP_CACHE_SUBCMDS), len(prefix)
        cache_sub = tokens[2] if n > 2 else ''
        if cache_sub == 'rm':
            entries = _scoop_cached('cache', ['scoop', 'cache', 'show'])
            matches = {_rc(k, v, prefix) for k, v in entries.items() if k.startswith(prefix)}
            matches.add(_rc('*', 'Remove all cached downloads', prefix))
            return matches, len(prefix)
        return set()

    # --- subcommands that take installed app names ---
    _app_subcmds = {'uninstall', 'update', 'hold', 'unhold', 'reset', 'info',
                    'prefix', 'depends', 'virustotal', 'cat', 'home', 'download'}

    if subcmd in _app_subcmds:
        flags = _SCOOP_FLAGS.get(subcmd, {})
        if prefix.startswith('-'):
            return {_rc(k, v, prefix) for k, v in flags.items() if k.startswith(prefix)}, len(prefix)
        apps = _scoop_cached('apps', ['scoop', 'list'])
        matches = {_rc(k, v, prefix) for k, v in apps.items() if k.startswith(prefix)}
        matches |= {_rc(k, v, prefix) for k, v in flags.items() if k.startswith(prefix)}
        return matches, len(prefix)

    # --- flag-only subcommands ---
    flags = _SCOOP_FLAGS.get(subcmd, {})
    return {_rc(k, v, prefix) for k, v in flags.items() if k.startswith(prefix)}, len(prefix)

if 'scoop' in __xonsh__.completers:
    completer remove scoop
completer add scoop _scoop_completer 'start'



# Carapace — multi-shell multi-command argument completer
$CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
$COMPLETIONS_CONFIRM=True
exec($(carapace _carapace))

# Zoxide — bootstraps z/zi commands into the session
execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')

