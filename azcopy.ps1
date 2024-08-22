#######################################################################################################################
###                                                                                                                 ###
###    Script Name: azcopy.ps1                                                                                      ###
###    Script Function: This script is meant to download and install the azcopy utility to allow us to copy files   ### 
###                     from Azure Blob Storage.                                                                    ###
###                                                                                                                 ###
###    Script Usage: This template script does not require any parameters at this time, but if required they can    ###
###                  be added and called as part of the custom image template process.                              ###
###                                                                                                                 ###        
###    Script Version: 1.0                                                                                          ###
###                                                                                                                 ###
#######################################################################################################################
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine


# Logifle Path
$LogFilePath = "C:\ImageBuild\azcopy.log"
# Function to write logs
function Write-Log
{
	param (
		[string]$Message
	)

	try
	{
		# Check if the log file directory exists, create it if not
		$logDirectory = Split-Path -Path $LogFilePath
		if (-Not (Test-Path -Path $logDirectory))
		{
			New-Item -Path $logDirectory -ItemType Directory
			Write-Host "Log directory created at: $logDirectory"
		}
		# Get current date and time
		$dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
		# Log message with date and time to console and file
		$logMessage = "$dateTime - $Message"
		Write-Host $logMessage
		Add-Content -Path $LogFilePath -Value $logMessage
	}
	catch
	{
		write-host "Having issues creating or adding information to the logfile at $LogFilePath"
	}
}

# Azure Image Builder Portal Integration Inline Commands

# Inline command to download and extract AZCopy
try {
    # Create a new directory for ImageBuild
    New-Item -Type Directory -Path 'c:\\' -Name 'ImageBuild' -Force
    Write-Log -Message "Created directory c:\\ImageBuild"

    # Download the AZCopy utility
    invoke-webrequest -uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'c:\\ImageBuild\\azcopy.zip'
    Write-Log -Message "Downloaded azcopy.zip"

    # Extract the downloaded zip file
    Expand-Archive 'c:\\ImageBuild\\azcopy.zip' 'c:\\ImageBuild'
    Write-Log -Message "Extracted azcopy.zip"

    # Copy the AZCopy executable to the ImageBuild directory
    copy-item 'C:\\ImageBuild\\azcopy_windows_amd64_*\\azcopy.exe\\' -Destination 'c:\\ImageBuild'
    Write-Log -Message "Copied azcopy.exe to c:\\ImageBuild"
}
catch {
    Write-Log -Message "An error occurred: $($_.Exception.Message)"
}