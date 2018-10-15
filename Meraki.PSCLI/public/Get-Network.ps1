function Get-Network {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$Id = $env:MerakiOrganizationId,
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject[]]$InputObject
    )
    Begin {
        try {
            [string]$uri = $endpoint
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            if ($Id) {
                if ($Id.Contains("_")) {
                    $uri = "$uri/networks/$Id"
                }
                else {
                    $uri = "$uri/organizations/$Id/networks"
                }
            }
            else {
                if ($env:MerakiOrganizationId) {
                    $uri = "$uri/organizations/$env:MerakiOrganizationId/networks"
                }
                else {
                    Write-Error -Exception ([System.Management.Automation.PSArgumentException]::new()) `
                        -Message "No Id was specified and `$env:\MerakiOrganizationId was not set." `
                        -ErrorAction Stop
                }
            }

            return Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}
