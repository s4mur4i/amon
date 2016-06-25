<#
.SYNOPSIS

.DESCRIPTION

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK


.EXAMPLE
   .\Install-LMIHotfixKB2842230.ps1
   
#>

	[CmdletBinding()]
	param (
	)

	BEGIN {
	}
	
	PROCESS {

		$OSVersion = [System.Environment]::OSVersion.Version
		
		# Windows Server 2012 (not R2)
		if($OSVersion.Major -eq 6 -and $OSVersion.Minor -eq 2) {
			$hotfixPath = "C:\windows_installer\Windows8-RT-KB2842230-x64.msu"
			Invoke-Expression "wusa $hotfixPath /quiet /norestart"
			
			# Check result with Get-Hotfix
			try {
				Get-Hotfix -Id "KB2842230" -ErrorAction Stop
				Write-Host "Hotfix is installed."
			}
			catch {
				Write-error "Hotfix was not installed, something went wrong."
			}
		}
		else {
			Write-Host "Skipping install... only applies to Windows Server 2012"
		}
	}
	
	END {
	}