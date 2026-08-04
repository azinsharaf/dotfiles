let carapace_bin = (($env.USERPROFILE? | default $env.HOME) | path join "scoop" "apps" "carapace-bin" "current")
$env.path = ($env.path | split row (char esep) | where { $in != $carapace_bin } | prepend $carapace_bin)

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
  load-env {
  	CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
  	CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
  }

  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1 | str replace --regex  '\.exe$' '')
  } else {
    $spans | skip 1 | prepend ($spans.0 | str replace --regex  '\.exe$' '')
  })

  carapace $spans.0 nushell ...$spans
  | from json
}

mut config = ($env.config? | default {})
if ($config.completions? == null) { $config.completions = {} }
if ($config.completions.external? == null) { $config.completions.external = {} }

let completer = (if ($config.completions.external.completer? == null) { $carapace_completer } else { $config.completions.external.completer })

$config.completions.external.enable = ($config.completions.external.enable? | default true)
$config.completions.external.completer = $completer

$env.config = $config
    
