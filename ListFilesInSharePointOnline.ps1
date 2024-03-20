param (
    [string]$SiteUrl,
    [string]$TenantUrl,
    [string]$ClientId,
    [string]$CertificationPath,
    [string]$CertificationPassword,
    [string]$Folder
)

#Connects to server
Connect-PnPOnline -ClientId $ClientId -CertificatePath $CertificationPath -CertificatePassword (ConvertTo-SecureString -AsPlainText $CertificationPassword -Force) -Url $SiteUrl -Tenant $TenantUrl 

# Get files in the folder
$files = Get-PnPFolderItem -FolderSiteRelativeUrl $Folder -ItemType File

# Output file names
foreach ($file in $files) {
    Write-Host $file.Name
}

Disconnect-PnPOnline