function persistApiKey {
    if ($env:MerakiApiKey -eq [System.Environment]::GetEnvironmentVariable("MerakiApiKey", "User")) {
        Write-Warning -Message $("Session api key matches value stored in User Environment " +
            "variable. Nothing to update.")
    }
    else {
        [System.Environment]::SetEnvironmentVariable("MerakiApiKey", $env:MerakiApiKey, "User")
        Write-Host "Persited api key from current session into User Environment variable."
    }
}