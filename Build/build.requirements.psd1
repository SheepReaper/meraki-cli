@{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target     = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath  = $true
        Parameters = @{Force = $true}
    }

    # Grab some modules without depending on PowerShellGet
    'psake'         = @{DependencyType = 'PSGalleryNuget'}
    'PSDeploy'      = @{DependencyType = 'PSGalleryNuget'}
    'BuildHelpers'  = @{DependencyType = 'PSGalleryNuget'}
    'Pester'        = @{DependencyType = 'PSGalleryNuget'}
}