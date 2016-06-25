<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER Param1
 
.INPUTS

.OUTPUTS
 
.NOTES
	Author: Zoltan Kovacs
	Version: 1.0

	Version history
	1.0		base version

.LINK
 
.EXAMPLE
#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)]
		[ValidateScript({
			# your validation logic
			if (1 -eq 1) { $true }
			else { Throw "Your custom error message" }
		})]
		[string]$Parameter1,
		
		[switch]$Parameter2
	)

	BEGIN {
		# Init
	}
	
	PROCESS {
		
		# Do your logic here
		
		# Use Write-Verbose instead of Write-Host
		Write-Verbose "Your message"
		
		try {
			# error might occur here
		}
		catch {
			# handle any errors
		}

		
		<# 
			Creating the custom output object if needed, Powershell 2.0 way
			Example: http://blogs.technet.com/b/heyscriptingguy/archive/2013/11/07/a-powershell-object-lesson-part-3.aspx
			For easier reading we create the hashtable first and then use the New-Object command with our hashtable
		#>
		
		# Create a hashtable with your values
		$Output = @{
			Field1 = $Yourvariable;
			Field2 = $Yourvariable.Property1;
			Field3 = "Your string";
			Field4 = 1234;
		}
		# Now create the object, defining our hashtable as input parameter
		# This line eventually gives it back to the caller because we did not use variable to store it, so no need to specify 'return' or any other command
		New-Object PSObject -Property $Output
	}
	
	END {
		# Close
	}
