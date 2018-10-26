##### CI(unstable): [![Build status](https://ci.appveyor.com/api/projects/status/x0bxldt82wwfga2j?svg=true)](https://ci.appveyor.com/project/bryan5989/meraki-cli) PSGallery(stable): [![Build status](https://ci.appveyor.com/api/projects/status/x0bxldt82wwfga2j/branch/dev?svg=true)](https://ci.appveyor.com/project/bryan5989/meraki-cli/branch/psgallery-preview)
# meraki-cli
PowerShell implementation of Meraki Dashboard API (for a binary version of this, see here: https://github.com/bryan5989/SheepReaper.Meraki.DashboardApi.PowerShell) (__WIP!__)
## Latest version (stable)
Found on [PSGallery](https://www.powershellgallery.com/packages/Meraki.PSCLI/1.0.0-dev)
## Latest version (ci build)
Register the CI repository (only need to do once)
```PowerShell
Register-PSRepository -Name MerakiCliUnstable -SourceLocation "https://ci.appveyor.com/nuget/meraki-cli-psm"
```
Then simply install from that repository
```PowerShell
Install-Module -Repository MerakiCliUnstable -Name Meraki.PSCLI -Force
```
