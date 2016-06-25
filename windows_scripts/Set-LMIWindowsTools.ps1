<#
.SYNOPSIS
	Configures some minor Windows setting

.DESCRIPTION
	Configures some minor Windows setting, including
		Disabling server manager
		Starting a component cleanup process
		Disabling StartComponentCleanup scheduled task which is partly responsible starting TiWorker.exe regularly

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.1

	Version history
	1.0		base version
	1.1		Added component cleanup part

.LINK
 
.EXAMPLE
   .\Set-LMIWindowsTools.ps1
   
#>

	[CmdletBinding()]
	param (
	)

	BEGIN {
	}
	
	PROCESS {

		# Disable server manager tool starting at log on of any user
		$ServerManagerTask = Get-ScheduledTask "ServerManager"
		Disable-ScheduledTask $ServerManagerTask
		Write-Host "Disabled server manager (scheduled task)"
		
		
		Write-Host "Start component cleanup process, this can take a while"
		Start-ScheduledTask -taskname "StartComponentCleanup" -TaskPath "\Microsoft\Windows\Servicing"
		
		$minutes = 0
		While($true) {
			Start-Sleep -Seconds 30
			$minutes++
			$t = Get-ScheduledTask "StartComponentCleanup"
			if($t.State -eq "Running") { Write-Host "Still running... $minutes"}
			else {
				Write-Host "Finished, status: $($t.State)"
				break
			}
		}
		
		Start-Sleep -Seconds 30
		$t = Get-ScheduledTask "StartComponentCleanup"
		Disable-ScheduledTask $t
		Write-Host "Disabled Component cleanup (scheduled task)"
	}
	
	END {
	}