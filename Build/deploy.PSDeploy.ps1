# Generic module deployment.
#
# ASSUMPTIONS:
#
# * folder structure either like:
#
#   - RepoFolder
#     - This PSDeploy file
#     - ModuleName
#       - ModuleName.psd1
#
#   OR the less preferable:
#   - RepoFolder
#     - RepoFolder.psd1
#
# * Nuget key in $ENV:NugetApiKey
#
# * Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables

# Publish to gallery with a few restrictions
$authorizedBranches = @('psgallery-preview', 'psgallery-release')
Get-ChildItem env:\ | write-verbose

if (
    $env:BHModulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -iin $authorizedBranches -and
    ($null -eq $ENV:APPVEYOR_PULL_REQUEST_NUMBER)
    #$env:BHCommitMessage -match '!deploy'
) {
    Deploy Module {
        By PSGalleryModule {
            FromSource $env:BHModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
}
else {
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* ENV:BHModulePath is set (Current [$([bool]$env:BHModulePath)]: $env:BHModulePath)`n" +
    "`t* You are in a known build system (Current [$($env:BHBuildSystem -ne 'Unknown')]: $ENV:BHBuildSystem)`n" +
    "`t* This is not a Pull Request (Current [$($null -eq $ENV:APPVEYOR_PULL_REQUEST_NUMBER)]: PR #$ENV:APPVEYOR_PULL_REQUEST_NUMBER)`n" +
    "`t* You are committing to a psgallery branch (Current [$($env:BHBranchName -iin $authorizedBranches)]: $ENV:BHBranchName) `n" |
        #"`t* Your commit message includes !deploy (Current [$($env:BHCommitMessage -match '!deploy')]: $ENV:BHCommitMessage)" |
    Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if (
    $env:BHProjectName -and $ENV:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -eq 'AppVeyor'
) {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHProjectName
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}