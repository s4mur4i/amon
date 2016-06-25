<#
.SYNOPSIS
	Disables netbios on all network cards

.DESCRIPTION
	Disables netbios on all network cards
	https://msdn.microsoft.com/en-us/library/aa393601(v=vs.85).aspx

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Disable-LMINetbios.ps1
   
#>

	[CmdletBinding()]
	param (
		[int]$State = 2
	)

	BEGIN {
	}
	
	PROCESS {

		$adapters=(gwmi win32_networkadapterconfiguration)
		Foreach ($adapter in $adapters) {
			$adapter.settcpipnetbios($State) | Out-Null
		}
		Write-Host "Disabled Netbios on all interfaces"
		
		$service = Get-Service "lmhosts"
		if ($service.Status -eq "Running") { Stop-Service $service }
		Set-Service "lmhosts" -StartupType Disable
		Write-Host "Disabled lmhosts service"

	}
	
	END {
	}