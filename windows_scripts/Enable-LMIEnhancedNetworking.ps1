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
	http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/enhanced-networking.html

.EXAMPLE
   .\Enable-LMIEnhancedNetworking.ps1
   
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
			Import-Module AWSPowerShell
			$wc = New-Object System.Net.WebClient

			# FIXED: this part did not work previously because of a typo in the method name
			$iam = ($wc.DownloadString(http://169.254.169.254/latest/meta-data/iam/security-credentials)).Content
			$iamProfileInfo = ConvertFrom-Json (Invoke-WebRequest http://169.254.169.254/latest/meta-data/iam/security-credentials/$iam).Content
			Set-AWSCredentials -AccessKey $iamProfileInfo.AccessKeyId -SecretKey $iamProfileInfo.SecretAccessKey -SessionToken $iamProfileInfo.Token
			Start-Process -FilePath "pnputil" -ArgumentList " -a c:/windows_installer/NDIS63/vxn63x64.inf"

			$instanceIdResult = $wc.DownloadString("http://169.254.169.254/latest/meta-data/instance-id")
			
			# instance need to be stopped for this
			
			# Set to simple to enable enhanced networking for this instance.
			# There is no way to disable enhanced networking at this time.
			# This option is supported only for HVM instances. Specifying this option with a PV instance can make it unreachable.
			Edit-EC2InstanceAttribute -InstanceId $instanceIdResult -SriovNetSupport simple
		}

	}
	
	END {
	}