@description('Azure region for the storage account (AFD is global)')
param location string

@description('Storage account name (3-24, lowercase letters + digits )')
param storage_account_name string

@description( 'Custom domain you will serve on Front Door (use subdomain like www)')
param domain_fqdn string

@description('Azure DNS zone name where that hosts your domain')
param dns_zone_name string 

@description('Resource group name where the Azure DNS zone is hosted')
param dns_zone_rg string 

// --------------------------------
// Storage Account + Static Website
// -------------------------------- 
resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storage_account_name
  location: location
  sku: {name: 'Standard_LRS'}
  kind: 'StorageV2'
}

resource staticWebsite 'Microsoft.Storage/storageAccounts/staticWebsites@2021-09-01' = {
  name: 'default'
  parent: sa
  properties: {
    indexDocument: 'index.html'
    errorDocument404Path: 'index.html'
  }
}

// Static website origin host
var staticHost = replace(replace(sa.properties.primaryEndpoints.web, 'https://', ''), '/', '')

// Azure Front Door Standard (Microsoft CDN )
resource fd 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: 'fd-profile-${uniqueString(resourceGroup().id)}'
  location: 'global'
  sku: {name: 'Standard_AzureFrontDoor'}
}

resource fdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: 'ep-${uniqueString(resourceGroup().id)}'
  parent: fd
  location: 'global'
  properties: {enabledState: 'Enabled'}
}

// -----------------------------------------
// origin group + origin pointing at storage static website
// -----------------------------------------
resource og 'Microsoft.Cdn/profiles/originGroups@2025-06-01' = {
  name: 'og-default'
  parent: fd
  properties: {
    healthProbeSettings: {
      probePath: '/index.html'
      probeRequestType: 'GET'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 120
    }
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 2
      additionalLatencyInMilliseconds: 0
    }
    sessionAffinityState: 'Disabled'
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2025-06-01' = {
  name: 'origin-staticweb'
  parent: og
  properties: {
    hostName: staticHost
    httpPort: 80
    httpsPort: 443
    originHostHeader: staticHost
    priority: 1
    weight: 1000
  }
}

// -----------------------------------------
// Custom domain + Managed TLS via Azure DNS 
// -----------------------------------------

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dns_zone_name
  scope: resourceGroup(dns_zone_rg)
}

resource customDomain 'Microsoft.Cdn/Profiles/customDomains@2021-06-01' = {
  name: 'cd-${uniqueString(resourceGroup().id)}'
  parent: fd
  properties: {
    hostName: domain_fqdn
    // Because your DNS is in Azure DNS, AFD can validate automatically
    azureDnsZone: {id: dnsZone.id}
    tlsSettings: {
      certificateType: 'ManagedCertificate' // Azure managed cert, auto-issues/renews
      minimumTlsVersion: 'TLS12'
    }
  }
}

 // Route: bind endpoint + origin group + custom domain, force HTTPS
resource route 'Microsoft.Cdn/profiles/routes@2023-05-01' = {
  name: 'route-static'
  parent: fd
  properties: {
    endpoint: { id: fdEndpoint.id }
    originGroup: {  id: og.id}
    supportedProtocols: ['Http', 'Https']
    httpsRedirect: 'Enabled' // force HTTPS
    linkToDefaultDomain: 'Disabled'
    customDomains: [{id: customDomain.id}]
    patternsToMatch: ['/*']
    forwardingProtocol: 'MatchRequest'
    enabledState: 'Enabled'
  }
}

output storageStaticWebsiteUrl string  = sa.properties.primaryEndpoints.web
output afdEndpointHost string          = fdEndpoint.properties.hostName
output customDomainHost string         = customDomain.properties.hostName
