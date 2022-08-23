###############################################################################
###############################################################################
######################## Script made by Kamille92 #############################
##################### https://twitter.com/Kamille_92/ #########################
###############################################################################
### This script is made to automatically copy your Hunt Showdown Highlights ###
### into a folder of your choice. #############################################
### This way, you'll never forget to manually save them :-) ###################
###############################################################################
###############################################################################

<#
Note:
To start the script, right click on the file and select "Run with PowerShell".

If the window closes automatically it is because, by default, the PowerShell Execution policy is set to Restricted.
This means that PowerShell scripts won’t run at all.

To fix it:
	1. Press Windows key + X (or right click on the start menu)
	2. Choose Windows PowerShell (admin)
	3. Run the following command "Set-ExecutionPolicy Unrestricted"
	4. Press "Y"
	5. Close the window
	6. You should now be able to run PowerShell Scripts.
#>


#Configuration:

#ALT + Z -> Highlights -> Path of the folder "Temporary files"
$TempHighlightsPath = "C:\ADD\YOUR\PATH\TO\Temp Highlights" # <-- Configure this

#Path where you want to move the Highlights
$DestinationPath = "C:\CONFIGURE\YOUR\DESTINATION\PATH" # <-- Configure this

#Change if necessary
$SteamPath = "C:\Program Files\Steam" # <-- Configure this



Write-Host "Starting script." -ForegroundColor DarkGray


#############################################################
####################### Testing Paths #######################
#############################################################
if ((Test-Path -Path $TempHighlightsPath) -eq $false) {
	Write-Error "`nTemp Highlights Path `"$TempHighlightsPath`" doesn't exist.`nExiting in 10 sec."
	Start-Sleep -Seconds 10
	exit
}

if ((Test-Path -Path $DestinationPath) -eq $false) {
	Write-Host "`nDestination Path `"$DestinationPath`" doesn't exist.`nTrying to create it..." -NoNewline -ForegroundColor Yellow
	
	$result = New-Item "$DestinationPath" -ItemType Directory
	
	if ((Test-Path -Path $DestinationPath) -eq $false) {
		Write-Host "`nImpossible to create `"$DestinationPath`".`nExiting in 10 sec.".
		Start-Sleep -Seconds 10
		exit
	}else {
		Write-Host " OK, folder has been created." -ForegroundColor Yellow
	}
}



#############################################################
# This Part if not mandatory, you can remove it if you want #
#############################################################

#testing steam path
if ((Test-Path -Path "$SteamPath\steam.exe") -eq $false) {
	Write-Warning "`nsteam.exe can't be found in `"$SteamPath`".`nExiting in 10 sec."
	Start-Sleep -Seconds 10
	exit
}else {
	#Checking if Hunt game is started and starts it if needed.
	if ( (Get-Process -Name "HuntGame" -ErrorAction SilentlyContinue).Count -eq 0) {
		$counter = 0;
		#Waiting for Hunt Showdown to start
		while ( (Get-Process -Name "HuntGame" -ErrorAction SilentlyContinue).Count -eq 0) {
			Start-Sleep -Seconds 1
			if ($counter -eq 0) {
				#Starting Hunt Showdown
				& "$SteamPath\steam.exe" "steam://rungameid/594650"
				
				Write-Host "`nWaiting for Hunt Showdown to start..." -NoNewline
			}
			$counter++
		}

		Write-Host " OK." -ForegroundColor Cyan
	}
}
#############################################################
#############################################################
#############################################################


# specify which files you want to monitor
$FileFilter = '*.mp4'  

# specify whether you want to monitor subfolders as well:
$IncludeSubfolders = $true

# specify the file or folder properties you want to monitor:
$AttributeFilter = [IO.NotifyFilters]::FileName

# specify the type of changes you want to monitor:
$ChangeTypes = [System.IO.WatcherChangeTypes]::Created

# specify the maximum time (in milliseconds) you want to wait for changes:
$Timeout = 1000

# define a function that gets called for every change:
function Invoke-MoveCreatedFile
{
	param
	(
		[Parameter(Mandatory)]
		[System.IO.WaitForChangedResult]
		$ChangeInformation
	)

	$Name = $ChangeInformation.Name
	
	# Waiting 5 seconds so file can be fully created
	Start-Sleep -Seconds 5

	Write-Host "`n`tNew Highlights detected" -ForegroundColor Green
	
	$FullFromPath = "$TempHighlightsPath\$Name"
	$FileName = [System.IO.Path]::GetFileName($FullFromPath)
	$FromPath = $FullFromPath.Replace($FileName,"")
	$GameName = $Name.Replace("\$FileName","")
	
	#There can be several files added, so we are going to get them and move them one by one.
	$Files_To_Move = Get-ChildItem -Path "$FromPath\$FileFilter" | select Name,CreationTime
		
	foreach ($File_To_Move in $Files_To_Move){
		$FileName = $File_To_Move.Name
		$FileCreationTime = $File_To_Move.CreationTime

		$year = Get-Date -Date $FileCreationTime -Format "yyyy"
		$month = Get-Date -Date $FileCreationTime -Format "MM"
		$day = Get-Date -Date $FileCreationTime -Format "dd"
		
		$FullDestinationPath = "$DestinationPath\$GameName\$year\$month\$day"
		
		if ((Test-Path -Path $FullDestinationPath) -eq $false) {
			#Create directory if not exists
			$result = New-Item "$FullDestinationPath" -ItemType Directory
		}

		if ((Test-Path -Path $FullDestinationPath) -eq $true) {
			$result = Move-Item -Path "$FromPath\$FileName" -Destination "$FullDestinationPath" -Force -PassThru

			$New_FileName = $result.Name
			if ((Test-Path -Path "$FullDestinationPath\$New_FileName") -eq $true) {
				Write-Host "`t`t$FileName moved" -ForegroundColor DarkGreen
			}
			else {
				Write-Host "`t`t$FileName hasn't been moved :(" -ForegroundColor Red
			}
		}
		else {
			Write-Host "`tFolder $GameName\$year\$month\$day doesn't exist or can't be created" -ForegroundColor Red
			Write-Host "`tFile hasn't been moved." -ForegroundColor Red
		}
	}
}

# use a try...finally construct to release the
# filesystemwatcher once the loop is aborted
# by pressing CTRL+C


try
{
	Write-Host "`nWaiting for new Highlights... " -NoNewline
	Write-Host "GL,HF!" -ForegroundColor Cyan

	# create a filesystemwatcher object
	$watcher = New-Object -TypeName IO.FileSystemWatcher -ArgumentList $TempHighlightsPath, $FileFilter -Property @{
		IncludeSubdirectories = $IncludeSubfolders
		NotifyFilter = $AttributeFilter
	}

	# start monitoring manually in a loop:
	do
	{
		# wait for changes for the specified timeout
		# IMPORTANT: while the watcher is active, PowerShell cannot be stopped
		# so it is recommended to use a timeout of 1000ms and repeat the
		# monitoring in a loop. This way, you have the chance to abort the
		# script every second.
		$result = $watcher.WaitForChanged($ChangeTypes, $Timeout)
		# if there was a timeout, continue monitoring:
		if ($result.TimedOut) { continue }

		Invoke-MoveCreatedFile -Change $result
		# the loop runs forever until you hit CTRL+C    
	} while ( (Get-Process -Name "HuntGame" -ErrorAction SilentlyContinue).Count -gt 0) {
		$true
	}
	
	$watcher.Dispose()
	Write-Host 'FileSystemWatcher removed.' -ForegroundColor DarkYellow
}
finally
{
	# release the watcher and free its memory:
	$watcher.Dispose()
	Write-Host 'FileSystemWatcher removed.' -ForegroundColor DarkYellow
}
