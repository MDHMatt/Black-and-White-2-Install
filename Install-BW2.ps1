### -------------------------------- ###
##-- Auto Black & White 2 installer --##
### -------------------------------- ###
#- Orignal https://github.com/N00bScriptr/Black-and-White-2-Install -#
#- Updated MDHMatt 20-10-24 -#
# add the required .NET assembly to run from vscode

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

Start-Sleep -Seconds "1"

#Show option to cancel if run by mistake
$msgBoxInput =  [System.Windows.MessageBox]::Show('Would you like to install BW2?','Confirm BW2 Install','YesNo','Information')
switch  ($msgBoxInput) {
    'Yes' {
        # Select folder where setup files are stored
        Start-Sleep -Seconds "1"
        Function Get-Folder($initialDirectory="$home\Downloads"){
            [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")  | Out-Null
            $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
            $foldername.Description = "Select a folder"
            $foldername.rootfolder = "UserProfile"
            $foldername.SelectedPath = $initialDirectory
            if($foldername.ShowDialog() -eq "OK")    {
                $folder = $foldername.SelectedPath
            }
            return $folder
        }

        #Set working folder to user selected folder
        $isoDir = Get-Folder
        Set-Location $isoDir
        #Find iso file within folder
        $isoFile = Get-ChildItem | Where-Object Name -like "*.iso"
        
        #Mount the iso file
        Mount-DiskImage $isoFile

        #Grab mounted drive letter
        $isoDriveLetter = (Get-Volume | Where-Object FileSystemLabel -like "*BW2*").DriveLetter

        #Run install
        Start-Process "$isoDriveLetter`:\arun.exe" -Wait
        
        Start-Sleep -Seconds "1"
        #Install official patches
        Start-Process "BW2Patch_v11.exe" -Wait
        Start-Sleep -Seconds "1"
        Start-Process "bw2patch_v12.exe" -Wait
        Start-Sleep -Seconds "1"

        #Install Win 10+ fan patch
        Start-Process "B&W2 Fan Patch v1.42 Installer.exe" -Wait
        
        #Dismount ISO image
        Dismount-DiskImage $isoFile
    }
    'No' {
        [System.Windows.MessageBox]::Show('Canceled','Error')
    }
}
#Start-Process "msg" -ArgumentList "$env:UserName", "Installation completed. Click OK to exit"