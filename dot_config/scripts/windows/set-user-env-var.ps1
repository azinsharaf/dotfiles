$envVars = @(
    @{ Name = "GLAZEWM_CONFIG_PATH"; Value = "$HOME\.config\glazewm\config.yaml" }
    @{ Name = "XDG_CONFIG_HOME";     Value = "$HOME\.config" }
    @{ Name = "XDG_DATA_HOME";       Value = "$HOME\.local\share" }
    @{ Name = "XDG_STATE_HOME";      Value = "$HOME\.local\state" }
    @{ Name = "XDG_CACHE_HOME";      Value = "$HOME\.cache" }
    @{ Name = "BAT_CONFIG_PATH";     Value = "$HOME\.config\bat\bat.conf" }
	@{ Name = "GIT_INSTALL_ROOT";    Value = "$HOME\scoop\apps\git\current" }
	@{ Name = "PI_CODING_AGENT_DIR";    Value = "$HOME\.config\pi\agent" }
)

foreach ($item in $envVars) {
    [System.Environment]::SetEnvironmentVariable($item.Name, $item.Value, "User")
    Set-Item -Path "Env:$($item.Name)" -Value $item.Value
    Write-Host "$($item.Name) = $($item.Value)"
}