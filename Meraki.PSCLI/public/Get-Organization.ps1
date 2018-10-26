function Get-Organization {
    [CmdletBinding(DefaultParameterSetName = "GetAll")]
    param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "GetOne",
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias("OrganizationId")]
        [string]$Id
    )
    Begin {
        try {
            [string]$baseUri = "$endpoint/organizations"
            [string]$uri = $baseUri
        }
        catch {$PSCmdlet.ThrowTerminatingError($PSitem)}
    }
    Process {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetOne") {
                $uri = "$baseUri/$Id"
                [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
    End {
        try {
            if ($PSCmdlet.ParameterSetName -eq "GetAll") {
                [PSCustomObject](Invoke-RestMethod -Method GET -Uri $uri -Headers $headers)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
    }
}