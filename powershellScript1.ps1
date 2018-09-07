# Alexandra Ioannidis
# Computer Forensics Lab 1

import-module activedirectory
Write-Host "Note: Some commands in this script will not run correctly without admin credentials.`n"

# TIME
# Time, Time Zone, PC Uptime
Write-Host "Date/Time"
Write-Host "----------" 
Get-Date
$TimeZone = Get-TimeZone | Select-Object @{Name = "Time Zone"; Expression = {$_.Id}}
Write-Host "PC Uptime:"
(Get-Date)-(Get-CimInstance Win32_OperatingSystem).LastBootUpTime | Format-Table
Write-Host

# OS VERSION
# numerical, typical name, kernel version
[environment]::OSVersion.Version
Write-Host "Typical Name"
Write-Host "------------"
Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption
Write-Host

# SYSTEM HARDWARE SPECS
Get-WmiObject -class "Win32_Processor" | Select-Object @{Name = "CPU Brand"; Expression = {$_.Manufacturer}}, @{Name = "CPU Type"; Expression = {$_.Caption}} | Format-Table
Write-Host "RAM Amount:"
Get-WmiObject -class "Win32_PhysicalMemoryArray" | Select-Object Name, MaxCapacity
Get-WmiObject -class Win32_LogicalDisk | Select-Object Size
# Size is in bytes????????????????????????
Write-Host

# GET DOMAIN CONTROLLER INFO
Get-ADDomainController | Select-Object IPv4Address,HostName | Format-Table -AutoSize
Write-Host "DC DNS Server:"
Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses

# HOSTNAME AND DOMAIN
$name = (Get-WmiObject Win32_ComputerSystem).Name
$domain = (Get-WmiObject Win32_ComputerSystem).Domain
Write-Host "`nHostname : ", $name
Write-Host "Domain : ", $domain

# LIST OF USERS
$users = (Get-WmiObject -Class Win32_UserAccount | Select-Object Name, SID)
Write-Host "`nUsers:"
$users

# START AT BOOT
Write-Host "`nStart at Boot Services:"
Get-Service | Select-Object -Property Name,StartType | Where-Object {$_.StartType -eq "Automatic"} | Select-Object Name
Write-Host "Start at Boot Programs:"
Get-CimInstance Win32_StartupCommand | Select-Object Name

# LIST OF SCHEDULED TASKS
Get-ScheduledTask | Select-Object @{Name = "List of Scheduled Tasks"; Expression = {$_.TaskName}}

# NETWORK
Write-Host "ARP table:"
Get-NetNeighbor
Write-Host "MAC Address:"
Get-WmiObject -class "Win32_NetworkAdapterConfiguration" | Select-Object MACAddress
Write-Host "Routing Table:"
Get-NetRoute
Write-Host "IP Address:"
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress | Format-Table
Write-Host "DHCP Server:"
Get-DhcpServerInDC
Write-Host "DNS Server:"
Get-DnsServer
Write-Host "Gateway:"
Get-NetRoute | where {$_.DestinationPrefix -eq '0.0.0.0/0'} | select @{Name = 'Gateway';Expression = {$_.NextHop}}
Write-Host "Listening Services:"
Get-NetTCPConnection -State Listen
Write-Host "Established Connections:"
Get-NetTCPConnection -State Established
Write-Host "DNS Cache:"
Get-DnsClientCache

# NETWORK SHARES, PRINTERS, WIFI ACCESS POINTS
Get-PSDrive | Select-Object @{Name = "Network Shares"; Expression = {$_.Name}} 
Get-Printer | Select-Object @{Name = "Printer"; Expression = {$_.Name}}
Write-Host

# LIST OF INSTALLED SOFTWARE
Get-WmiObject -Class Win32_Product | Select-Object @{Name = "List of Installed Software:"; Expression = {$_.Name}}

# PROCESS LIST
Get-Process -IncludeUserName | Select-Object ProcessName, Id, UserName, Path | Format-Table -AutoSize
Write-Host

# DRIVER LIST
Get-WindowsDriver -Online -All | Select-Object Driver, BootCritical, Version, Date, ProviderName, OriginalFileName | Format-Table -AutoSize
Write-Host

# LIST OF ALL FILES IN DOWNLOADS/DOCUMENTS FOR EACH USER DIRECTORY
$userList = Get-WmiObject -Class Win32_UserAccount | Select-Object Name
for each ($obj in $userList){
	Write-Host $obj
	$files = Get-ChildItem "C:\Users\"$obj"\Documents\"
	$downFiles = Get-ChildItem "C:\Users\"$obj"\Downloads\"
}

# ADD THREE OF MY OWN
$exec = (Get-ExecutionPolicy)
$sysLocale = (Get-WinSystemLocale | Select-Object Name | Format-Table)
$location = (Get-WinHomeLocation | Select-Object HomeLocation | Format-Table)
Write-Host "Execution Policy:" , $exec
Write-Host "System Location: ", $sysLocale
Write-Host "Home Location: ", $location

# Get Credential & Start PSRemote Session
$c = Get-Credential
$psremote = Read-Host -Prompt 'Enter the name or IP of machine to remote to:' 
Enable-PSRemoting -Force
Enter-PSSession -ComputerName $psremote -Credential $c

# Script must have the ability to output to a file in CSV format and send CSV in an email

