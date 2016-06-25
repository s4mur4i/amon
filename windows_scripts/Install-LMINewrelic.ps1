<#
.SYNOPSIS
	Installs newrelic from local drive

.DESCRIPTION
	Installs newrelic from local drive

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Install-LMINewrelic.ps1
   
#>

	[CmdletBinding()]
	param (
		[string]$InstallerPath = "C:\windows_installer\newrelic_latest.msi",
		[string]$LicenseKey = "26788f58e00682cbbcb12aadfb3b476a8a467cb9"
	)

	BEGIN {
	}
	
	PROCESS {

		# /L*v install.log means log verbose output to install.log | /qn means display no user interface
		$arguments = "/i $InstallerPath /L*v install.log /qn NR_LICENSE_KEY=$LicenseKey"

		if ($InstallerPath -ne $null) {
			$exitCode = (Start-Process -FilePath "msiexec" -ArgumentList $arguments -Wait -PassThru).ExitCode;
			if($exitCode -eq 0) {
				Write-Host "NewRelic installation successful!" -ForegroundColor Green
			} 
			else {
				Write-Host "Newrelic installation unsuccessful. Exitcode: $exitCode" -ForegroundColor Red
			}
		}

	}
	
	END {
	}