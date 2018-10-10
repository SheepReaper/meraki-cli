param([switch]$Finalize)

# Globals
$psVersion = $PSVersionTable.PSVersion.Major
$testFile = "TestResultsPS$psVersion.xml"
$projectRoot = $ENV:APPVEYOR_BUILD_FOLDER

Set-Location $projectRoot

# Run tests for current version
if (-not $Finalize) {
    Write-Host "`n`tSTATUS: Testing with PowerShell $psVersion`n"

    Import-Module Pester

    Invoke-Pester -Path "$projectRoot\tests" -OutputFormat NUnitXml -OutputFile "$projectRoot\$testFile" -PassThru |
        Export-Clixml -Path "$projectRoot\PesterResults$psVersion.xml"
}

# Finalizing
else {
    $allFiles = Get-ChildItem -Path $projectRoot\*Results*.xml | Select-Object -ExpandProperty FullName
    Write-Host "`n`tSTATUS: Finalizing results`n"
    Write-Host "Concatenating results:`n$($allFiles | Out-String)"

    # Upload to appveyor
    Get-ChildItem -Path "$projectRoot\TestResultsPS*.xml" | ForEach-Object {
        $url = "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"
        $file = $_.FullName

        Write-Host "UPLOADING: $file to $url"

        (New-Object -TypeName System.Net.WebClient).UploadFile($url, $file)
    }

    # Log failures
    $results = @(Get-ChildItem -Path "$projectRoot\PesterResults*.xml" | Import-Clixml)

    $failureCount = $results | Select-Object -ExpandProperty FailedCount | Measure-Object -Sum | Select-Object -ExpandProperty Sum

    if ($failureCount -gt 0) {
        $failedItems = $results | Select-Object -ExpandProperty TestResult | Where-Object {$_.Passed -notlike $true}
        
        Write-Host "Failure Summary:`n"
        $failedItems | ForEach-Object {
            $test = $_
            $test.Name = "It $($test.Name)"
        } | Sort-Object Describe, Context, Name, Result| Format-List

        throw "$failureCount tests failed."
    }
}