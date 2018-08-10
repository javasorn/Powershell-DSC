<#
    .SYNOPSIS
        Get Product ID using in DSC package
#>
$x86Path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX86 = Get-ItemProperty -Path $x86Path | Select-Object -Property DisplayName, PSChildName

$x64Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedItemsX64 = Get-ItemProperty -Path $x64Path | Select-Object -Property DisplayName, PSChildName

$installedItems = $installedItemsX86 + $installedItemsX64
$installedItems | Where-Object -FilterScript { $null -ne $_.DisplayName } | Sort-Object -Property DisplayName | Out-GridView