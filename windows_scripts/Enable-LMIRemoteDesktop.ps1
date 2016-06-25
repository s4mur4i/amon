<#
.SYNOPSIS
	Enables remote desktop

.DESCRIPTION
	Enables RDP connections in registry, creates firewall rule fr inbound port 3389

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
	.\Enable-LMIRemoteDesktop.ps1
#>

	[CmdletBinding()]
	param (
	)

	BEGIN {
	}
	
	PROCESS {

		# Enable Remote Desktop in registry
		Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
	
		# add firewall rule
		New-NetFirewallRule -Action Allow -DisplayName "Open Port 3389" -Direction Inbound -Protocol TCP -LocalPort 3389
		# Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

		# Enable secure RDP authentication
		Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1
	}
	
	END {
	}