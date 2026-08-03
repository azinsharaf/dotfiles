# conda.nu — conda environment activation for nushell
# Mirrors the `ca` alias previously defined in ~/.config/xonsh/rc.xsh

export def --env ca [
    env_name: string = "arcgispro-py3-clone"
] {
    let conda_exe = 'C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe'

    let proc = (do { ^$conda_exe env list --json } | complete)
    if $proc.exit_code != 0 {
        error make { msg: $"ca: conda env list failed:\n($proc.stderr)" }
    }
    let envs = (($proc.stdout | from json).envs)

    let env_path = (
        $envs | where { |e| ($e | path basename) == $env_name or $e == $env_name } | get 0
    )
    if ($env_path | is-empty) {
        let avail = ($envs | each { |e| $"  ($e | path basename)  ($e)" } | str join "\n")
        error make { msg: $"environment ($env_name) not found. Available:\n($avail)" }
    }

    let prev = ($env.CONDA_PREFIX?)
    if ($prev | is-not-empty) {
        let deact_d = ($prev | path join "etc" "conda" "deactivate.d")
        if ($deact_d | path exists) {
            ls $deact_d | where name ends-with ".bat" | each { |f| ^cmd.exe /c $f.name }
        }
        let old_bins = [
            $prev,
            ($prev | path join "Library" "mingw-w64" "bin"),
            ($prev | path join "Library" "usr" "bin"),
            ($prev | path join "Library" "bin"),
            ($prev | path join "Scripts"),
            ($prev | path join "bin"),
        ]
        $env.path = ($env.path | where { |p| $p not-in $old_bins })
    }

    let new_bins = [
        $env_path,
        ($env_path | path join "Library" "mingw-w64" "bin"),
        ($env_path | path join "Library" "usr" "bin"),
        ($env_path | path join "Library" "bin"),
        ($env_path | path join "Scripts"),
        ($env_path | path join "bin"),
    ]
    $env.path = ($new_bins | append ($env.path | where { |p| $p not-in $new_bins }))

    let prev_shlvl = (($env.CONDA_SHLVL? | default "0") | into int)
    $env.CONDA_PREFIX          = $env_path
    $env.CONDA_DEFAULT_ENV     = $env_name
    $env.CONDA_SHLVL           = ($prev_shlvl + 1 | into string)
    $env.CONDA_EXE             = $conda_exe
    $env.CONDA_PROMPT_MODIFIER = $"($env_name) "

    let act_d = ($env_path | path join "etc" "conda" "activate.d")
    if ($act_d | path exists) {
        ls $act_d | where name ends-with ".bat" | each { |f| ^cmd.exe /c $f.name }
    }

    print $"activated: ($env_name)  ($env_path)"
}
