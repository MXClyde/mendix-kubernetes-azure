# Connectionstring to Keyvault (source: https://raw.githubusercontent.com/meanin/vsts-tasks/master/connectionstringtokeyvault/connectionstringtokeyvault.ps1)
# Adapted to remove modification of access policy (CWA, 02-07-2019)
[CmdletBinding()]
param(
    [string] [Parameter(Mandatory = $true)]
    $ConnectedServiceName, 
    [string] [Parameter(Mandatory = $true)]
    $ResourceGroupName, 
    [string] [Parameter(Mandatory = $true)]
    $StorageAccountName, 
    [string] [Parameter(Mandatory = $true)]
    $KeyVaultResourceGroupName, 
    [string] [Parameter(Mandatory = $true)]
    $KeyVaultName,
    [string] [Parameter(Mandatory = $true)]
    $KeyVaultKeyName,
    [string]
    $Location
)

try 
{   
    if(-not $Location)
    {
        $Location = (Get-AzureRmResourceGroup -Name $ResourceGroupName).Location
    }
    Write-Output "Get-AzureRmStorageAccount $ResourceGroupName/$StorageAccountName"
    $storageAccount = Get-AzureRmStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -ErrorAction Ignore
    if(-not $storageAccount)
    {
        throw "Storage account does not exist!"
    }
    else {
        Write-Output "Found: $ResourceGroupName/$StorageAccountName"
    }    

    Write-Output "Get-AzureRmKeyVault $KeyVaultResourceGroupName/$KeyVaultName"
    $KeyVault = Get-AzureRmKeyVault `
        -ResourceGroupName $KeyVaultResourceGroupName `
        -VaultName $KeyVaultName `
        -ErrorAction Ignore
    if(-not $KeyVault)
    {
        Write-Output "Key Vault does not exist. Creating with params: { "
        Write-Output "ResourceGroupName: $KeyVaultResourceGroupName, "
        Write-Output "KeyVaultName: $KeyVaultName, "
        Write-Output "Location: $Location }"
        $KeyVault=New-AzureRmKeyVault `
            -VaultName $KeyVaultName `
            -ResourceGroupName $KeyVaultResourceGroupName `
            -EnabledForDeployment `
            -Location $Location
        Write-Output "Created: $KeyVaultResourceGroupName/$KeyVaultName"
    }
    else {
        Write-Output "Key Vault already exists"
    }

#    Write-Output "Setting access right to key vault for current service principal"
#    Set-AzureRmKeyVaultAccessPolicy `
#        -VaultName $KeyVaultName `
#        -ResourceGroupName $KeyVaultResourceGroupName `
#        -ServicePrincipalName (Get-AzureRmContext).Account `
#        -PermissionsToKeys create,delete,list `
#        -PermissionsToSecrets set,delete,list `
#        -ErrorAction Ignore
    
    Write-Output "Adding key $KeyVaultKeyName"
    Add-AzureKeyVaultKey `
        -VaultName $KeyVaultName `
        -Name $KeyVaultKeyName `
        -Destination Software `
        -ErrorAction Ignore
    
    $StorageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName
    $ConnectionString = "DefaultEndpointsProtocol=https;AccountName={0};AccountKey={1};EndpointSuffix=core.windows.net" -f $StorageAccountName, $StorageAccountKey[0].Value
    $Secret = ConvertTo-SecureString -String $ConnectionString -AsPlainText -Force
    Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultKeyName -SecretValue $Secret  
    
    Write-Output "Created/Filled: $KeyVaultName/$KeyVaultKeyName"    
} catch 
{
    Write-Host $_.Exception.ToString()
    throw
}
