# AutoSave Highlights for Hunt Showdown

## In a nuthsell
This script will save every highlights in the folder of you choice everytime a new one is created.

## Why doing this?
I was tired of losing my highlights because I didn't save them in the summary page.

## What is this script doing exactly?
The script will:
- Test if the path you set exists
- Start Hunt if not already started
- Watch in the Nvidia Temporary highlights folder every time a file is created
- Then copy this file in the subfolders\year\month\day you set.


## Getting Started

These instructions will get you a copy of the powerShell script and explain you how to run it on your local machine.

#### 1. Download the script

First you need to download the ps1 scrit into your PC.
Latest version can be found [here](https://raw.githubusercontent.com/waibcam/AutoSave-Highlights-for-Hunt-Showdown/main/AutoSaveHighlights.ps1).  
Simply right-click on it and save it where you want.

#### 2. Configuration
Then, you'll have to edit (any simple text editor will work fine) and set (at the beginning that the script) 3 folders:
```
- $TempHighlightsPath = "C:\ADD\YOUR\PATH\TO\Temp Highlights" # <-- Configure this
- $DestinationPath = "C:\CONFIGURE\YOUR\DESTINATION\PATH" # <-- Configure this
- $SteamPath = "C:\Program Files\Steam" # <-- Configure this
```
$TempHighlightsPath should be the from the GeForce Experience Highlights Settings:  
```
ALT + Z -> Highlights -> Path of the folder "Temporary files".
```
![Highlights Folder](https://i.imgur.com/xjpMVci.png)  

$DestinationPath is the path wher you want to script to save your highlights (this path will be created if it doesn't exsist).  
$SteamPath is the path of your Steam.exe folder so the script cna run Hunt Showdown.  

#### 3. Run the script with PowerShell
To start the script, right click on the file and select "Run with PowerShell". It is simple as that!

That said, if the window closes automatically it is because, by default, the **PowerShell Execution policy** is set to *Restricted*. This means that PowerShell scripts won’t run at all.  
  
To fix it:
```
  1. Press Windows key + X (or right click on the start menu)  
  2. Choose Windows PowerShell (admin)  
  3. Run the following command "Set-ExecutionPolicy Unrestricted"  
  4. Press "Y"  
  5. Close the window  
  6. You should now be able to run PowerShell Scripts.
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how you can contribute to this project.

## Authors

* **Kamille92** - *Initial work* - [waibcam](https://github.com/waibcam)

See also the list of [contributors](https://github.com/waibcam/RSI_Companion/contributors) who participated in this project.

## License

This project is licensed under the GNU General Public License v3.0 - see the [COPYING](COPYING) file for details
