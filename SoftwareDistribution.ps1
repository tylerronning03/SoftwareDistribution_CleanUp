 
#Run as Administrator
try {
    Unblock-File "Z:\IT\Tyler\SoftwareDistribution_05-17-2024.ps1"
    }
    catch {
    Write-Host "File has been moved"
    }
     
    if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([security.Principal.WindowsBuiltinRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath powershell.exe -Verb Runas -ArgumentList $CommandLine
        exit
      }
    }
    $folderPath = "C:\windows\SoftwareDistribution"
    #check if the windows update service is running
     
    if ((Get-Service "wuauserv").Status -ne "Stopped") {
    #Stop the Windows update service
    Stop-Service wuauserv
    Write-Host "Stopping Windows Update Service"
    Get-Service -Name wuauserv | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
    }
     
    else {
    Write-Host "Windows Update Service is not running"
    }
     
    #Check if BITS is running
    if ((Get-Service "BITS").Status -ne "Stopped") {
    #stop the Background Intelligent transfer Service (BITS) using
    Stop-Service BITS
    Write-Host "Stopping BITS"
    Get-Service -Name BITS | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
     
    } else {
    Write-Host "BITS is not running"
    }
    #Open C:\windows\SoftwareDistribution
    #Select and delete all content in the folder
     
    Set-Location $folderPath
    Get-ChildItem
    Set-Location "C:\Windows"
    $children = Get-ChildItem -Path $folderPath
     
    Write-Host "Starting Deletion"
    $errors = 0
    foreach ($child in $children) {
    try {
    Write-Host "Deleting $child"
     
     if (!$child.Attributes -eq "Directory") {
     
    Write-Host "Deleting Document $child"
    Remove-Item -Path $child.FullName -Force
     
    }
    else {
     
    Write-Host "Deleting Folder $child"
    Remove-Item -Path $child.FullName -Force -Recurse
     
    }
    }
    catch {
        Write-Host "Error deleting $child"
        $errors = $errors + 1
    }
    }
    if ($errors -gt 0) {
      Write-Host "Deletion generated $errors errors"
    }
    else {
      Write-Host "All files deleted successfully"
    }
    #Start the Windows Update Service, Start BITS "net start ..."
     
    Start-Service wuauserv
    Write-Host "Starting Windows Update Service"
    Start-Service BITS
    Write-Host "Starting Background Intelligent Transfer Service"
    Write-Host "End of Script"
    Start-Process explorer.exe -ArgumentList "$folderPath"
    Read-Host "Press Enter to extit"
     
    From: Tyler (IT Student Worker)
    Sent: Friday, May 17, 2024 4:46 PM
    To: Tyler (IT Student Worker) <swit02@northwestu.edu>
    Subject: RE: Powershell Script
     
    #Run as Administrator
    try {
    Unblock-File "Z:\IT\Tyler\SoftwareDistribution_05-17-2024.ps1"
    }
    catch {
    Write-Host "File has been moved"
    }
     
    if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([security.Principal.WindowsBuiltinRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath powershell.exe -Verb Runas -ArgumentList $CommandLine
        exit
      }
    }
    $folderPath = "C:\windows\SoftwareDistribution"
    #check if the windows update service is running
     
    if ((Get-Service "wuauserv").Status -ne "Stopped") {
    #Stop the Windows update service
    Stop-Service wuauserv
    Write-Host "Stopping Windows Update Service"
    Get-Service -Name wuauserv | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
    }
     
    else {
    Write-Host "Windows Update Service is not running"
    }
     
    #Check if BITS is running
    if ((Get-Service "BITS").Status -ne "Stopped") {
    #stop the Background Intelligent transfer Service (BITS) using
    Stop-Service BITS
    Write-Host "Stopping BITS"
    Get-Service -Name BITS | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
     
    } else {
    Write-Host "BITS is not running"
    }
    #Open C:\windows\SoftwareDistribution
    #Select and delete all content in the folder
     
    Set-Location $folderPath
    Get-ChildItem
    Set-Location "C:\Windows"
    $children = Get-ChildItem -Path $folderPath
     
    Write-Host "Starting Deletion"
    $errors = 0
    foreach ($child in $children) {
    try {
    Write-Host "Deleting $child"
     
     if (!$child.Attributes -eq "Directory") {
     
    Write-Host "Deleting Document $child"
    Remove-Item -Path $child.FullName -Force
     
    }
    else {
     
    Write-Host "Deleting Folder $child"
    Remove-Item -Path $child.FullName -Force -Recurse
     
    }
    }
    catch {
        Write-Host "Error deleting $child"
        $errors = $errors + 1
    }
    }
    if ($errors -gt 0) {
      Write-Host "Deletion generated $errors errors"
    }
    else {
      Write-Host "All files deleted successfully"
    }
    #Start the Windows Update Service, Start BITS "net start ..."
     
    Start-Service wuauserv
    Write-Host "Starting Windows Update Service"
    Start-Service BITS
    Write-Host "Starting Background Intelligent Transfer Service"
    Write-Host "End of Script"
    Start-Process explorer.exe -ArgumentList "$folderPath"
    Read-Host "Press Enter to extit"
     
    
     
     