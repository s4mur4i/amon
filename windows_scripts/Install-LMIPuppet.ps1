<#
.SYNOPSIS
    Installs Puppet on this machine.
	
.DESCRIPTION
    Downloads and installs the PuppetLabs Puppet MSI package.
    This script requires administrative privileges.
    You can run this script from an old-style cmd.exe prompt using the
    following:
      powershell.exe -ExecutionPolicy Unrestricted -NoLogo -NoProfile -Command "& '.\Install-LMIPuppet.ps1'"
	  
.PARAMETER MsiUrl
    This is the URL to the Puppet MSI file you want to install. This defaults
    to a version from PuppetLabs.
	
.PARAMETER PuppetVersion
    This is the version of Puppet that you want to install. If you pass this it will override the version in the MsiUrl.
    This defaults to x64-latest

.NOTES
	Author:
	Version: 1.1

	Version history
	1.0		base version
	1.1		changed puppet web link to version 3.8.2

#>

	[CmdletBinding()]
	param(
	   [string]$MsiUrl = "https://downloads.puppetlabs.com/windows/puppet-3.8.2-x64.msi",
	   [string]$PuppetVersion = "3.8.2-x64"
	)

	if ($PuppetVersion -ne $null) {
	  $MsiUrl = "https://downloads.puppetlabs.com/windows/puppet-$($PuppetVersion).msi"
	  #Write-Host "Puppet version $PuppetVersion specified, updated MsiUrl to `"$MsiUrl`""
	}

	$PuppetInstalled = $false
	try {
	  Get-Command puppet -ErrorAction Stop | Out-Null
	  $PuppetInstalled = $true
	  $PuppetVersion=&puppet "--version"
	  Write-Host "Puppet $PuppetVersion is installed. This process does not ensure the exact version or at least version specified, but only that puppet is installed. Exiting..."
	  Exit 0
	} catch {
	  Write-Host "Puppet is not installed, continuing..."
	}

	if (!($PuppetInstalled)) {
	  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
		Write-Host -ForegroundColor Red "You must run this script as an administrator."
		Exit 1
	  }

	  # Install it - msiexec will download from the url
	  $install_args = @("/qn", "/norestart","/i", $MsiUrl)
	  Write-Host "Installing Puppet. Running msiexec.exe $install_args"
	  $process = Start-Process -FilePath msiexec.exe -ArgumentList $install_args -Wait -PassThru
	  if ($process.ExitCode -ne 0) {
		Write-Host "Installer failed."
		Exit 1
	  }

	  # Stop the service that it autostarts
	  Write-Host "Stopping Puppet service that is running by default..."
	  Start-Sleep -s 5
	  Stop-Service -Name puppet
	  Set-Service -StartupType disabled -Name puppet

	  Write-Host "Puppet successfully installed."
	}