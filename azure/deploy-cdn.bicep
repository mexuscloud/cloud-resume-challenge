@description('Front Door uses global location')
param location string = 'global'

@description('Origin hostname (e.g. mystorage.z13.web.core.windows.net)')
param origin_hostname string

@description('WWW custom domain')
param domain_fqdn string

@description('Apex/root domain')
param apex_fqdn string

@description('Azure DNS zone name')
param dns_zone_name string

@description('Resource group where DNS zone exists')
param dns_zone_rg string

@description('Stable Front Door profile name')
param fd_profile_name string = 'fd-profile-crc'

@description('Stable Front Door endpoint name')
param fd_endpoint_name string = 'fd-endpoint-crc'

/* ===============================
   Front Door Profile
   =============================== */
resource fd 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: fd_profile_name
  location: location
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
}

/* ===============================
   Endpoint
   =============================== */
resource fdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: fd_endpoint_name
  parent: fd
  location: location
  properties: {
    enabledState: 'Enabled'
  }
}

/* ===============================
   Origin Group + Origin
   =============================== */
resource og 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: 'og-static'
  parent: fd
  properties: {
    healthProbeSettings: {
      probePath: '/index.html'
      probeProtocol: 'Https'
      probeRequestType: 'GET'
      probeIntervalInSeconds: 120
    }
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 2
    }
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: 'origin-static-web'
  parent: og
  properties: {
    hostName: origin_hostname
    originHostHeader: origin_hostname
    httpPort: 80
    httpsPort: 443
    priority: 1
    weight: 1000
  }
}

/* ===============================
   Existing DNS Zone
   =============================== */
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dns_zone_name
  scope: resourceGroup(dns_zone_rg)
}

/* ===============================
   Custom Domains
   =============================== */
resource wwwDomain 'Microsoft.Cdn/profiles/customDomains@2021-06-01' = {
  name: 'cd-www'
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

resource apexDomain 'Microsoft.Cdn/profiles/customDomains@2021-06-01' = {
  name: 'cd-apex'
  parent: fd
  properties: {
    hostName: apex_fqdn
    azureDnsZone: {
      id: dnsZone.id
    }
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

/* ===============================
   Routes
   =============================== */
resource routeWww 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: 'route-www'
  parent: fdEndpoint
  properties: {
    originGroup: {
      id: og.id
    }
    supportedProtocols: ['Http', 'Https']
    httpsRedirect: 'Enabled'
    linkToDefaultDomain: 'Enabled'
    patternsToMatch: ['/*']
    forwardingProtocol: 'MatchRequest'
    enabledState: 'Enabled'
    ruleSets: [
      { id: rsApex.id }
    ]
    customDomains: [
      { id: wwwDomain.id }
    ]
  }
}

resource routeApex 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: 'route-apex'
  parent: fdEndpoint
  properties: {
    originGroup: {
      id: og.id
    } 
    supportedProtocols: ['Http', 'Https']
    patternsToMatch: ['/*']
    forwardingProtocol: 'MatchRequest'
    enabledState: 'Enabled'
    customDomains: [
      { id: apexDomain.id }
    ]
  }
}

/* ===============================
   Apex → WWW Redirect Rule
   =============================== */
resource rsApex 'Microsoft.Cdn/profiles/ruleSets@2025-04-15' = {
  name: 'rsApexRedirect'
  parent: fd
}

resource rsApexRule 'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15' = {
  name: 'redirectToWww'
  parent: rsApex
  properties: {
    order: 1
    actions: [
      {
        name: 'UrlRedirect'
        parameters: {
          redirectType: 'Moved'
          destinationProtocol: 'Https'
          customHostname: domain_fqdn
          typeName: 'DeliveryRuleUrlRedirectActionParameters'
        }
      }
    ]
  }
}

/* ===============================
   Outputs
   =============================== */
output afd_endpoint string = fdEndpoint.properties.hostName
output afd_profile_name string = fd.name
output afd_endpoint_id string = fdEndpoint.id
