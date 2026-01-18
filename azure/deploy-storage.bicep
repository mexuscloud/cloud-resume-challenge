@description('Azure region for the storage account (AFD is global)')
param location string

@description('Storage account name (3-24, lowercase letters + digits )')
param storage_account_name string


// --------------------------------
// Storage Account + Static Website
// -------------------------------- 
resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storage_account_name
  location: location
  sku: {name: 'Standard_LRS'}
  kind: 'StorageV2'
}

output storage_account_name string = storage_account_name
