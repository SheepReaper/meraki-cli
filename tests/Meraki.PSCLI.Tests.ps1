if (-not $PSScriptRoot) {
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Definition -Parent
}

$PSVersion = $PSVersionTable.PSVersion.Major
$ModuleName = $ENV:BHProjectName
$ProjectRoot = $ENV:BHProjectPath

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if ($ENV:BHBranchName -notlike "release" -or $env:BHCommitMessage -match "!verbose") {
    $Verbose.add("Verbose", $True)
}

Describe "General project validation: $ModuleName" {

    $scripts = Get-ChildItem $ProjectRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {@{file = $_}}         
    It "Script <file> should be valid powershell (PS$PSVersion)" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }
}

Describe "$ModuleName PS$PSVersion" {
    Context 'Strict mode' {

        Set-StrictMode -Version latest

        It 'Should load' {
            Import-Module $ProjectRoot\$ModuleName -Force
            $Module = @( Get-Module $ModuleName )
            $Module.Name -contains $ModuleName | Should be $True
            $Commands = $Module.ExportedCommands.Keys
            $Commands -contains 'Set-MerakiApiKey' | Should Be $True
        }
    }
}
