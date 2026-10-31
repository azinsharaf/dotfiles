$envVars = @(
    @{ Name = "GLAZEWM_CONFIG_PATH"; Value = "$HOME\.config\glazewm\config.yaml" }
    @{ Name = "XDG_CONFIG_HOME";     Value = "$HOME\.config" }
    @{ Name = "BAT_CONFIG_PATH";     Value = "$HOME\.config\bat\bat.conf" }
	@{ Name = "GIT_INSTALL_ROOT";    Value = "$HOME\scoop\apps\git\current" }
)

foreach ($item in $envVars) {
    [System.Environment]::SetEnvironmentVariable($item.Name, $item.Value, "User")
    Set-Item -Path "Env:$($item.Name)" -Value $item.Value
    Write-Host "$($item.Name) = $($item.Value)"
}