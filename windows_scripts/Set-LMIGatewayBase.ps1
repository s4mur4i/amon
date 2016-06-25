<#
.SYNOPSIS
	Sets TCIPIP parameters for broker.

.DESCRIPTION
	Modifies some tcp/ip parameters.
	https://wiki.3amlabs.net/display/XIV/Deployment+Guide+Live#DeploymentGuideLive-3.Brokerinstallworkflow	

.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
   .\Set-LMIGatewayBase.ps1
   
#>

	[CmdletBinding()]
	param (
	)

	BEGIN {
	}
	
	PROCESS {

		netsh int tcp set security mpp=disabled
		netsh int tcp set heuristics disabled
		netsh int tcp set global rss=enabled chimney=disabled autotuninglevel=normal
		auditpol.exe /set /SubCategory:"Filtering Platform Packet Drop" /success:disable /failure:disable
		auditpol.exe /set /SubCategory:"Filtering Platform Connection" /success:disable /failure:disable
		auditpol.exe /set /subcategory:"Registry" /success:disable /failure:disable
		
	}
	
	END {
	}