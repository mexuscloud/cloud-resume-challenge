@description('front door uses global location')
param location string = 'global'

@description('Origin hostname(e.g., mystorage.z13.web.core.windows.net)')
param origin_hostname string 

@description('Custom domain you will serve on Front Door (use subdomain like www)')
param domain_fqdn string

@description('Azure DNS zone name where that hosts your domain')
param dns_zone_name string 

@description('Resource group name where the Azure DNS zone is hosted')
param dns_zone_rg string 

// -----------------------------------------
// Azure Front Door Standard Profile
// -----------------------------------------
resource fd 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: 'fd-profile-${uniqueString(resourceGroup().id)}'
  location: location
  sku: { name: 'Standard_AzureFrontDoor' }
}

resource fdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: 'ep-${uniqueString(resourceGroup().id)}'
  parent: fd
  location: location
  properties: {
    enabledState: 'Enabled'
  }
}

// -----------------------------------------
// Origin Group + Origin
// -----------------------------------------
resource og 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: 'og-default'
  parent: fd
  properties: {
    healthProbeSettings: {
      probePath: '/index.html'
      probeRequestType: 'GET'
      probeProtocol: 'Https'
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

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: 'origin-staticweb'
  parent: og
  properties: {
    hostName: origin_hostname
    httpPort: 80
    httpsPort: 443
    originHostHeader: origin_hostname
    priority: 1
    weight: 1000
  }
}

// -----------------------------------------
// DNS Zone (existing)
// -----------------------------------------
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dns_zone_name
  scope: resourceGroup(dns_zone_rg)
}

// -----------------------------------------
// Custom Domain + Managed TLS
// -----------------------------------------
resource customDomain 'Microsoft.Cdn/profiles/customDomains@2021-06-01' = {
  name: 'cd-${uniqueString(resourceGroup().id)}'
  parent: fd
  properties: {
    hostName: domain_fqdn
    azureDnsZone: {
      id: dnsZone.id
    }
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

// -----------------------------------------
// Route
// -----------------------------------------
resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: 'route-static'
  parent: fdEndpoint
  dependsOn: [
    origin
  ]
  properties: {
    originGroup: {
      id: og.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    httpsRedirect: 'Enabled'
    linkToDefaultDomain: 'Disabled'
    customDomains: [
      { id: customDomain.id }
    ]
    patternsToMatch: ['/*']
    forwardingProtocol: 'MatchRequest'
    enabledState: 'Enabled'
  }
}

output afd_endpoint string = fdEndpoint.properties.hostName
