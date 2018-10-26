function Get-Network {
    [CmdletBinding(DefaultParameterSetName = "GetAllInfer")]
    param(
        [Parameter(Mandatory = $true,
            ParameterSetName = "GetOne",
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$NetworkId,
        [Parameter(Mandatory = $true,
            ParameterSetName = "GetAll",
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$OrganizationId,
        [Parameter(Mandatory = $true,
            ParameterSetName = "ParseInput",
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$Id,
        [Parameter(Mandatory = $true,
            ParameterSetName = "GetAllGlobal")]
        [switch]$AllOrganizations
    )
    Begin {
        try {
            [string]$baseUri = $endpoint

            switch ($PSCmdlet.ParameterSetName) {
                GetOne {
                    $Id = $NetworkId
                    break
                }
                GetAll {
                    $Id = $OrganizationId
                    break
                }
                GetAllInfer {
                    if ($env:MerakiOrganizationId) {
                        $Id = $env:MerakiOrganizationId
                    }
                    else {
                        Write-Error -Exception ([System.Management.Automation.PSArgumentNullException]::new()) `
                            -Message "The OrganizationId parameter was attempted to be inferred from `$env:MerakiOrganizationId but was `$null" `
                            -ErrorAction Stop
                    }
                }
            }
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetOne" `
                    -or $PSCmdlet.ParameterSetName -eq "ParseInput") {
                if ($Id.Contains("_")) {
                    $uri = "$baseUri/networks/$Id"
                    [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
                }
                else {
                    Get-Network -OrganizationId $Id
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
    End {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetAllGlobal") {
                Write-Error -Exception ([NotImplementedException]::new()) `
                    -Message "The -AllOrganizations switch is not yet implemented" `
                    -ErrorAction Stop
            }
            if ($PSCmdlet.ParameterSetName -match "GetAll") {
                # Also matches GetAllInfer
                $uri = "$baseUri/organizations/$Id/networks"
                [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}
