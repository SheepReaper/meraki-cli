# Globals
[string]$endpoint = "https://api.meraki.com/api/v0"
[Hashtable]$headers = @{
    "X-Cisco-Meraki-API-Key" = $env:MerakiApiKey
    "Content-Type"           = 'application/json'
}

# Set TLS version to 1.2 <- required by Meraki
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# This runs on import to obviate if a Key was successfully read from environment
if (!$env:MerakiApiKey) {
    Write-Warning -Message $("An API Key for Meraki Dashboard was not found in the environment " + 
        "variables. (Did you forget to -Persist, previously? Or perhaps this is your first " +
        "time importing this module?) You will need to run:")
    Write-Host "`tSet-MerakiApiKey -ApiKey <string> [-Persist]"
    Write-Warning "All other commands provided by this module will fail until you do."
}
else {
    Write-Host "Using Dashboard API key from environment."
}

Write-Verbose "Importing Functions"

# Import everything in these folders
foreach ($folder in @('private', 'public')) {
    
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if (Test-Path -Path $root) {
        Write-Verbose "processing folder $root"
        $files = Get-ChildItem -Path $root -Filter *.ps1 -Recurse

        # dot source each file
        $files | where-Object { $_.name -NotLike '*.Tests.ps1'} | 
            ForEach-Object {Write-Verbose $_.name; . $_.FullName}
    }
}

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Recurse).basename