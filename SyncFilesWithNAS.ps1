param (
    [string]$SiteUrl,
    [string]$TenantUrl,
    [string]$ClientId,
    [string]$CertificationPath,
    [SecureString]$CertificationPassword,
    [string]$ListName
)

#Connects to server
Connect-PnPOnline -ClientId $ClientId -CertificatePath $CertificationPath -CertificatePassword $CertificationPassword -Url $SiteUrl -Tenant $TenantUrl 

