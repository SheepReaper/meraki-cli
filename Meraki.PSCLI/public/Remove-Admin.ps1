function Remove-Admin {
    [CmdletBinding(DefaultParameterSetName = "ByObject")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "ById")]
        [string]$Id,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$OrganizationId = $env:MerakiOrganizationId
    )
    Begin {
        try {
            if (!$OrganizationId) {
                Write-Error -Exception ([System.Management.Automation.PSArgumentNullException]::new()) `
                    -Message "Parameter OrganizationId was not specified, and attempt to infer from `env:MerakiOrganizationId failed." `
                    -ErrorAction Stop
            }
            [string]$baseUri = "$endpoint/organizations/$OrganizationId/admins"
            $queryUriRedirect = Invoke-WebRequest -Method GET -Uri $baseUri -MaximumRedirection 0 -Headers $headers -ErrorAction SilentlyContinue
            $baseUri = $queryUriRedirect.Headers.Location
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            $uri = "$baseUri/$Id"

            Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -ContentType 'application/json'
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}