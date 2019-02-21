# Contributing

## Status
Accepting contributions

## Pull Requests
Please make pull requests against **development** branch or a feature branch. Master is reserved for tracking releases and staging PS Gallery Releases (because I'm paranoid).

## Repository/Project Layout/Build System
Repository Root\
- Build\ <- PSDeploy Scripting (Shamelessly borrowed from ramblingcookiemonster)
- Meraki.PSCLI\ <- Module Directory, this is what gets built into a module
  - private\ <- private functions or cmdlets
  - public\  <- public functions or cmdlets
  - Meraki.PSCLI.psd1 <- Module Manifest (Generated)
  - Meraki.PSCLI.psm1 <- Module script (top-level)
- tests\ <- Pester test scripts (thanks RCM, again)
- {Misc. Repository Files}

## How to add functionality
Please try to make all public (user-accessible) functions into Cmdlets (aka advanced functions or workflows implementing the CmletBindingAttribute).
Place all such functions into individual script files (.ps1 extension) and into the **public** directory.
The build system will automatically export these functions in the finished module.

Do the same for any private functions but into the **private** directory instead.
Private functions do not have to be cmdlets.

I know there's no such thing as "Module" Scope in PowerShell, but place any "Module Scope Globals" into the top level .psm1 file.

The top-level .psm1 dot-sources each .ps1 file in the private and public directories.

Don't wory about the Manifest (.psd1) it gets generated.

**NOTE:** This will change in the future by a better build system that concatenates all of the script files into a single .psm1 (for performance).

**NOTE2:** This will all be replaced by a binary module eventually
