<#
.SYNOPSIS
	Sets EC2 configuration

.DESCRIPTION
	Sets EC2 configuration, enables SetPassword, SetComputername, HandleUserData

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Set-LMIEC2.ps1
   
#>

	[CmdletBinding()]
	param (
		[string]$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\Config.xml"
	)

	BEGIN {
	}
	
	PROCESS {

		
		$xml = New-Object -TypeName XML
		try {
			$xml.Load($EC2SettingsFile)
		}
		catch {
			Write-Error "Cannot load xml: $($_.Exception.Message)"
			Exit
		}
		# XML successfully loaded

		foreach ($element in $xml.Ec2ConfigurationSettings.Plugins.Plugin)
		{
			Switch ($element.name) {
				"Ec2SetPassword" { $element.State="Enabled" }
				"Ec2SetComputerName" { $element.State="Enabled" }
				"Ec2HandleUserData" { $element.State="Enabled" }
			}
		}
		$xml.Save($EC2SettingsFile)
	
	}
	
	END {
	}