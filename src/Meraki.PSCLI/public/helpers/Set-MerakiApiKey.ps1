function Set-MerakiApiKey {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Position = 1)]
        [string]$ApiKey,
        [switch]$Persist
    )
	
    if (!($ApiKey -or $Persist)) {
        Write-Error -Exception [System.ArgumentNotSpecifiedException] `
            -Message "Neither an ApiKey or the -Persist parameter were specified." `
            -RecommendedAction $("Specify a Meraki ApiKey using -ApiKey, using -Persist to make " + 
            "the change permanent, or specify -Persist alone to store the current " +
            "session's Api Key permanently.")
        return
    }

    if ($Persist) {
        if (!$env:MerakiApiKey) {
            Write-Error -Exception [System.InvalidOperationException] `
                -RecommendedAction "Run command: Set-MerakiApiKey, specifying -ApiKey." `
                -Message $("The Meraki Dashboard Api Key was not previously specified, there is " +
                "nothing to persist.")
            return
        }
        if (!$ApiKey) {
            persistApiKey
            return
        }
    }
	
    if ($ApiKey -eq $env:MerakiApiKey) {
        Write-Warning -Message $("Supplied Api Key is the same as the one in use for this " +
            "session. `n`nSession Api Key remains unchanged.")
    }
    else {
        if ($env:MerakiApiKey) {
            Write-Warning -Message "Updating this session's Api Key..."
        }

        $env:MerakiApiKey = $ApiKey
        updateHeaders
        Write-Host "Session Api Key successfully set"
    }

    if ($Persist) { persistApiKey }

    return
}