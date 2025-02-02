param (
    [string]$SiteUrl = $env:SiteUrl,
    [string]$Tenant = $env:Tenant,
    [string]$ClientId = $env:ClientId,
    [string]$CertificatePath = $env:CertificatePath,
    [string]$CertificatePassword = $env:CertificatePassword
)

Function Backup-Entire-SPOFolder([Microsoft.SharePoint.Client.Folder]$Folder, $DestinationFolder)
{ 
    $FolderURL = $Folder.ServerRelativeUrl.Substring($Folder.Context.Web.ServerRelativeUrl.Length)
    $LocalFolder = Join-Path -Path $DestinationFolder -ChildPath $FolderURL
    If (!(Test-Path -Path $LocalFolder)) {
            New-Item -ItemType Directory -Path $LocalFolder | Out-Null
            Write-host -f Yellow "Created a New Folder '$LocalFolder'"
    }
           
    $FilesColl = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderURL -ItemType File
    Foreach($File in $FilesColl)
    {	
        $LocalFilePath = Join-Path -Path $LocalFolder -ChildPath $File.Name
        if (-not (Test-Path -Path $LocalFilePath)) {
            Get-PnPFile -ServerRelativeUrl $File.ServerRelativeUrl -Path $LocalFolder -FileName $File.Name -AsFile -Force
            Write-host -f Green "`tDownloaded File from '$($File.ServerRelativeUrl)'"
        }
        else {
            $SharePointFile = Get-PnPFile -Url $File.ServerRelativeUrl
            $LocalFile = Get-Item $LocalFilePath
            if ($SharePointFile.TimeLastModified -gt $LocalFile.LastWriteTime) {
                Get-PnPFile -ServerRelativeUrl $File.ServerRelativeUrl -Path $LocalFolder -FileName $File.Name -AsFile -Force
                Write-host -f Green "`tUpdated File from '$($File.ServerRelativeUrl)'"
            }
            else {
                Write-host -f Cyan "`tSkipped File '$($File.ServerRelativeUrl)' as it is up to date."
            }
        }
    }
    
    $SubFolders = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderURL -ItemType Folder
    Foreach ($SubFolder in $SubFolders | Where-Object {$_.Name -ne "Forms"})
    {
        Backup-Entire-SPOFolder $SubFolder $DestinationFolder
    }
} 

#Download Variables
$LibraryURL = "Shared Documents"
$DownloadPath = "/mnt"

#Connects to server
Connect-PnPOnline -ClientId $ClientId -CertificatePath $CertificatePath -CertificatePassword (ConvertTo-SecureString -AsPlainText $CertificatePassword -Force) -Url $SiteUrl -Tenant $Tenant 

#Gets Library Folder
$Folder = Get-PnPFolder -Url $LibraryURL

#Calls Function
Backup-Entire-SPOFolder $Folder $DownloadPath

Disconnect-PnPOnline