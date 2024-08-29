 
#Run as Administrator
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
    Get-Service -Name wuauserv | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
    }
    
    #Check if BITS is running
    if ((Get-Service "BITS").Status -ne "Stopped") {
    #stop the Background Intelligent transfer Service (BITS) using
    Stop-Service BITS
    Get-Service -Name BITS | foreach-Object {$_.WaitForStatus("Stopped", '00:00:30')}
     
    
    #Select and delete all content in the folder
    Get-ChildItem
    $children = Get-ChildItem -Path $folderPath
     
    foreach ($child in $children) {
    
    Remove-Item -Path $child.FullName -Force -Recurse
     
    }
    
    #Start the Windows Update Service, Start BITS "net start ..."
     
    Start-Service wuauserv
    Start-Service BITS
