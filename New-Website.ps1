<#
    .SYNOPSIS
        DSC tp create a new IIS website with xWebAdministration module
    .Link
        Using xWebAdministration module refer from https://github.com/PowerShell/xWebAdministration
#>
Configuration New-Website
{
    param
    (
        [string[]]$NodeName = 'localhost',
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()]
        [String]$WebSiteName,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()]
        [String]$SourcePath,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()]
        [String]$DestinationPath
    )

    Import-DscResource -Module xWebAdministration

    Node $NodeName
    {
        # Copy the website content
        File WebContent {
            Ensure          = "Present"
            SourcePath      = $SourcePath
            DestinationPath = $DestinationPath
            Recurse         = $true
            Type            = "Directory"
            Force           = $true
        }
        # New WebSite
        xWebsite NewWebsite {
            Ensure       = "Present"
            Name         = $WebSiteName
            State        = "Started"
            PhysicalPath = $DestinationPath
            BindingInfo  = MSFT_xWebBindingInformation {
                Protocol = "HTTP"
                Port     = 7001
            }
        }
    }
}
New-Website -NodeName "localhost" -WebSiteName "TestDsc" -SourcePath "$PSScriptRoot\sampleHtml" -DestinationPath "D:\TestDscWww"
Start-DscConfiguration -Path New-Website -Verbose -Force -Wait