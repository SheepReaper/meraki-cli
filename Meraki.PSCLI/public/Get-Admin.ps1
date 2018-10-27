function Get-Admin {
    [CmdletBinding(DefaultParameterSetName = "GetAllInfer")]
    param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "GetAll",
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias("Id")]
        [string]$OrganizationId
    )
    Begin {
        try {
            [string]$baseUri = "$endpoint/organizations"
            [string]$uri = $baseUri
            if ($PSCmdlet.ParameterSetName -eq "GetAllInfer") {
                if ($env:MerakiOrganizationId) {
                    $uri = "$baseUri/$env:MerakiOrganizationId/admins"
                }
                else {
                    Write-Error -Exception ([System.Management.Automation.PSArgumentNullException]::new()) `
                        -Message "Parameter OrganizationId was not specified, and attempt to infer from `env:MerakiOrganizationId failed." `
                        -ErrorAction Stop
                }
            }
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetAll") {
                $uri = "$baseUri/$OrganizationId/admins"
                [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
    End {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetAllInfer") {
                [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}