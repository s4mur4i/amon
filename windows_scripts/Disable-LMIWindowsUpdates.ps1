<#
.SYNOPSIS
	Disables automatic windows updates

.DESCRIPTION
	Disables checking for and applying Windows Updates (does not prevent updates from being applied manually or being pushed down)
	Run on the machine that updates need disabling.

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Disable-LMIWindowsUpdates.ps1
   
#>

	[CmdletBinding()]
	param (
	)

	BEGIN {
	}
	
	PROCESS {

		$RunningAsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
		If ($RunningAsAdmin)
		{
			$Updates = (New-Object -ComObject "Microsoft.Update.AutoUpdate").Settings

			if ($Updates.ReadOnly -eq $True) { Write-Error "Cannot update Windows Update settings due to GPO restrictions." }
			else {
				$Updates.NotificationLevel = 1 #Disabled
				$Updates.Save()
				$Updates.Refresh()
				
				Write-Host "Automatic Windows updates are turned off."
			}
		}
		else
		{
			Write-Error "You need to run this script as an administrator!"
		}
	}
	
	END {
	}