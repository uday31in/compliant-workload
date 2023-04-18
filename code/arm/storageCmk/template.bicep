targetScope = 'resourceGroup'

// Parameters
@description('Specifies the location for all resources.')
param location string = 'eastus'
@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of the deployment.')
param environment string = 'dev'
@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string = 'mabuss70'
@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Variables
var name = toLower('${prefix}-${environment}')
var userAssignedIdentityName = '${name}-uai001'
var keyvaultName = '${name}-vault001'
var storageNameCleaned = replace('${name}-stg001', '-', '')

// Resources
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userAssignedIdentityName
  location: location
  tags: tags
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyvaultName
  location: location
  tags: tags
  properties: {
    accessPolicies: []
    createMode: 'default'
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: subscription().tenantId
  }
}

resource keyVaultCmk 'Microsoft.KeyVault/vaults/keys@2023-02-01' = {
  parent: keyVault
  name: 'cmk'
  properties: {
    attributes: {
      enabled: true
      exportable: false
    }
    curveName: 'P-256'
    keyOps: [
      'decrypt'
      'encrypt'
      'sign'
      'unwrapKey'
      'verify'
      'wrapKey'
    ]
    keySize: 2048
    kty: 'RSA'
    rotationPolicy: {
      attributes: {
        expiryTime: 'P13M'
      }
      lifetimeActions: [
        {
          action: {
            type: 'rotate'
          }
          trigger: {
            timeAfterCreate: 'P12M'
          }
        }
      ]
    }
  }
}

resource roleAssignmentKeyVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, userAssignedIdentity.id)
  scope: keyVault
  properties: {
    description: 'User Assigned Identity Role Assignment for CMK'
    principalId: userAssignedIdentity.properties.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6')
    principalType: 'ServicePrincipal'
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  dependsOn: [
    roleAssignmentKeyVault
  ]

  name: storageNameCleaned
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowedCopyScope: 'AAD'
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Keyvault'
      identity: {
        userAssignedIdentity: userAssignedIdentity.id
      }
      keyvaultproperties: {
        keyname: keyVaultCmk.name
        keyvaulturi: keyVault.properties.vaultUri
      }
      requireInfrastructureEncryption: true
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Account'
        }
        table: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    // immutableStorageWithVersioning:{
    //   enabled: false
    //   immutabilityPolicy: {
    //     state: 'Disabled'
    //     allowProtectedAppendWrites: true
    //     immutabilityPeriodSinceCreationInDays: 7
    //   }
    // }
    isHnsEnabled: false
    isLocalUserEnabled: false
    isNfsV3Enabled: false
    isSftpEnabled: false
    keyPolicy: {
      keyExpirationPeriodInDays: 7
    }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Disabled'
    routingPreference: {
      routingChoice: 'MicrosoftRouting'
      publishInternetEndpoints: false
      publishMicrosoftEndpoints: false
    }
    supportsHttpsTrafficOnly: true
    // sasPolicy: {
    //   expirationAction: 'Log'
    //   sasExpirationPeriod: ''
    // }
  }
}

// Outputs
