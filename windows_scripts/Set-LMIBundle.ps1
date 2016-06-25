<#
.SYNOPSIS
	Sets EC2 bundle configuration

.DESCRIPTION
	Sets EC2 bundle Autosysprep to Yes

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Set-LMIBundle.ps1
   
#>

	[CmdletBinding()]
	param (
		[string]$EC2SettingsFile="C:\Program Files\Amazon\Ec2ConfigService\Settings\BundleConfig.xml"
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
	
		foreach ($element in $xml.BundleConfig.Property)
		{
			if ($element.Name -eq "AutoSysprep")
			{
				$element.Value="Yes"
			}
		}
		$xml.Save($EC2SettingsFile)

	}
	
	END {
	}