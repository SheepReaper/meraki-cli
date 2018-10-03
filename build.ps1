param($Task = 'Default')

# Debug
$VerbosePreference = 'Continue'

Get-PackageProvider -Name NuGet -ForceBootstrap

Install-Module -Name Psake, PSDeploy, BuildHelpers -Force
Install-Module -Name Pester -Force -SkipPublisherCheck

Import-Module Psake, BuildHelpers

Set-BuildEnvironment

Invoke-psake -buildFile .\psake.ps1 -taskList $Task -nologo

exit([int](-not $psake.build_success))