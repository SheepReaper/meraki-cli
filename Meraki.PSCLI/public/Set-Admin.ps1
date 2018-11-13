function Set-Admin {
    [CmdletBinding(DefaultParameterSetName = "ByObject")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Inline")]
        [string]$Id,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Name,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Email,
        [Parameter(ValueFromPipelineByPropertyName = $true)]
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
                    -Message "Parameter OrganizationId was not specified, and attempt to infer from env:MerakiOrganizationId failed." `
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
            if ($PSCmdlet.ParameterSetName -eq "ByObject" -and !$Id) {
                Write-Error -Exception ([System.Management.Automation.PSArgumentNullException]::new()) `
                    -Message "Parameter Id was not specified nor provided by input object. Id is required to update an admin" `
                    -ErrorAction Stop
            }

            [string]$uri = "$baseUri/$Id"
            [PSCustomObject]$newAdmin = Get-MerakiAdmin -OrganizationId $OrganizationId | Where-Object {$_.id -eq $Id}

            if ($Name) {$newAdmin.name = $Name}
            if ($Email) {$newAdmin.email = $Email}
            if ($OrganizationAccess) {$newAdmin.orgAccess = $OrganizationAccess}
            if ($Tags) {$newAdmin.tags = $Tags}
            if ($Networks) {$newAdmin.networks = $Networks}

            $body = $newAdmin | ConvertTo-Json

            Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body $body -ContentType 'application/json'
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}