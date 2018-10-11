function Get-MerakiNetwork {
    [CmdletBinding(DefaultParameterSetName = "organizationQuery")]
    param(
        [Parameter(ParameterSetName = "pipelineInput", ValueFromPipeline = $true)]
        $PipelineInput,
        [Parameter(ParameterSetName = "organizationQuery")]
        [string]$OrganizationId = $env:MerakiOrganizationId,
        [Parameter(ParameterSetName = "directQuery")]
        [string]$Id = $env:MerakiNetworkId
    )

    [string]$uri = $endpoint

    switch ($PSCmdlet.ParameterSetName) {
        "pipelineInput" {
            $uri = "$uri/organizations/$($PipelineInput.id)/networks"
        }
        "organizationQuery" {
            $uri = "$uri/organizations/$OrganizationId/networks"
        }
        "directQuery" {
            $uri = "$uri/networks/$Id"
        }
    }

    return Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
}
