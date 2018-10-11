function Get-MerakiOrganization {
    [CmdletBinding()]
    param([string]$Id)

    [string]$uri = "$endpoint/organizations"

    if ($Id) { $uri = "$uri/$Id" }

    return Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
}