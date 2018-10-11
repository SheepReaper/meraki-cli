function Set-MerakiSessionVariable {
    [CmdletBinding()]
    param([string]$ApiKey, $OrganizationId, $NetworkId)

    if ($ApiKey) { Set-MerakiApiKey -ApiKey $ApiKey }
    if ($OrganizationId) {
        $env:MerakiOrganizationId = $OrganizationId
        Write-Host "Updated Current Session Organization Id. Future commands will use it by default." 
    }
    if ($NetworkId) {
        $env:MerakiNetworkId = $NetworkId
        Write-Host "Updated Current Session Network Id. Future commands will use it by default."  
    }
}