function New-Admin {
    [CmdletBinding(DefaultParameterSetName = "ByObject")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Inline")]
        [string]$Name,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Inline")]
        [string]$Email,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Inline")]
        [Alias("orgAccess")]
        [string]$OrganizationAccess,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject[]]$Tags,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCustomObject[]]$Networks,
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
            [string]$uri = "$endpoint/organizations/$OrganizationId/admins"
            $queryUriRedirect = Invoke-WebRequest -Method GET -Uri $uri -MaximumRedirection 0 -Headers $headers -ErrorAction SilentlyContinue
            $uri = $queryUriRedirect.Headers.Location
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            [PSCustomObject]$newAdmin = New-Object -TypeName PSObject -Property @{
                name      = $Name
                email     = $Email
                orgAccess = $OrganizationAccess
                tags      = $Tags
                networks  = $Networks
            }

            $body = $newAdmin | ConvertTo-Json

            Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body -ContentType 'application/json'
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}