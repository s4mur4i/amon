<powershell>
write-output "Running User Data Script"
write-host "(host) Running User Data Script"

$key = (128, 224, 253, 34, 239, 169, 31, 33, 2, 108, 62, 214, 232, 96, 105, 199, 168, 169, 180, 223, 14, 251, 146, 151, 12, 135, 14, 13, 48, 134, 138, 245)
$hash = "76492d1116743f0423413b16050a5345MgB8ADYAVgB3AG4ASQBqAEYASQBGAGMAMQBqAFMAVABUAFcAZQBGAEYAbwBqAHcAPQA9AHwAMAA0ADkAOAA4ADMAYQAzAGMAYwA2AGEAZAA2AGMAZgA2AGYAMwA4AGUAMQBlAGYANAA4ADEANwBiAGUANwBjADEAMwA3ADkAYgBmADMAMgBlADgAYwA0ADgAMQA0ADQAMQBhADAAYwA5ADIAZAAwADYAMAAyADMANwAxAGQANwA="

$p = $hash | ConvertTo-SecureString -Key $key

# get back the password as plaintext
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p)
$pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

Invoke-Expression "cmd.exe /c net user /add devops $pass"
cmd.exe /c net localgroup administrators devops /add
cmd.exe /c wmic useraccount where "name='devops'" set PasswordExpires=FALSE

Set-ExecutionPolicy -ExecutionPolicy bypass -Force

# RDP
#cmd.exe /c netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
#cmd.exe /c reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -Value 0
# Allow incoming RDP on firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# Only Network Level Authentication is enabled
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1

# WinRM
write-output "Setting up WinRM"
write-host "(host) setting up WinRM"

cmd.exe /c winrm quickconfig -q
cmd.exe /c winrm quickconfig '-transport:http'
cmd.exe /c winrm set "winrm/config" '@{MaxTimeoutms="1800000"}'
cmd.exe /c winrm set "winrm/config/winrs" '@{MaxMemoryPerShellMB="1024"}'
cmd.exe /c winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/client/auth" '@{Basic="true"}'
cmd.exe /c winrm set "winrm/config/service/auth" '@{CredSSP="true"}'
cmd.exe /c winrm set "winrm/config/listener?Address=*+Transport=HTTP" '@{Port="5985"}'

# Open firewall in all Profiles
New-NetFirewallRule -Action Allow -DisplayName "Open Port 5985" -Direction Inbound -Protocol TCP -LocalPort 5985
cmd.exe /c net stop winrm
cmd.exe /c sc config winrm start= auto #already auto after quickconfig
cmd.exe /c net start winrm


</powershell>