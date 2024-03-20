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

#Define Query to Filter
$Query= "<View>
            <Query>
                <Where>
                    <Gt>
                        <FieldRef Name='Modified' Type='DateTime'/>
                        <Value Type='DateTime' IncludeTimeValue='TRUE'>
                            <Today OffsetDays='-1'/>
                        </Value>
                    </Gt>
                </Where>
            </Query>
        </View>"
 
$ListItems = Get-PnPListItem -List $ListName -Query $Query
Write-host "Total Number of Items Found:"$ListItems.count
 
#Get Each Item's Modified Date
$ListItems | ForEach-Object { Write-host ("List Item:{0} was Modified on {1}" -f $_["FileLeafRef"],$_["Modified"]) }