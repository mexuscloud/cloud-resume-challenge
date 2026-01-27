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
  kind: 'StorageV2'
  sku: {name: 'Standard_LRS'}
}

resource staticWebsite 'Microsoft.Storage/storageAccounts/staticWebsites@2021-09-01' = {
  name: 'default'
  parent: sa
  properties: {
    indexDocument: 'index.html'
    error404Document: 'index.html'
  }
}

// Static website origin host (e.g., mystorage.z13.web.core.windows.net)
var staticHost = replace(replace(sa.properties.primaryEndpoints.web, 'https://', ''), '/', '')

output storageStaticSiteUrl string = sa.properties.primaryEndpoints.web
