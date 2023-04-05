param location string = resourceGroup().location
param storageAccountName string = toLower('${replace(resourceGroup().name, '-', '')}str')
param siloAppName string = toLower('${resourceGroup().name}-silo')
param dashboardAppName string = toLower('${resourceGroup().name}-dashboard')
param apiAppName string = toLower('${resourceGroup().name}-api')

param siloImage string
param clientImage string
param dashboardImage string
param registry string
param registryUsername string

@secure()
param registryPassword string

module env 'env.bicep' = {
  name: 'containerAppEnvironment'
  params: {
    location: location
  }
}

module storage 'storage.bicep' = {
  name: storageAccountName
}


module silo 'container-app.bicep' = {
  name: siloAppName
  params: {
    location: location
    name: siloAppName
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: siloImage
    allowExternalIngress: true    
    maxReplicas: 1
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'OrleansAzureStorageConnectionString'
        value: format('DefaultEndpointsProtocol=https;AccountName=${storage.outputs.storageName};AccountKey=${storage.outputs.accountKey};EndpointSuffix=core.windows.net')
      }
    ]
  }
}

module api 'container-app.bicep' = {
  name: apiAppName
  params: {
    location: location
    name: apiAppName
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: clientImage
    allowExternalIngress: true
    maxReplicas: 1
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'OrleansAzureStorageConnectionString'
        value: format('DefaultEndpointsProtocol=https;AccountName=${storage.outputs.storageName};AccountKey=${storage.outputs.accountKey};EndpointSuffix=core.windows.net')
      }
    ]
  }
}

module dashboard 'container-app.bicep' = {
  name: dashboardAppName
  params: {
    location: location
    name: dashboardAppName
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: dashboardImage
    allowExternalIngress: true
    maxReplicas: 1
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'OrleansAzureStorageConnectionString'
        value: format('DefaultEndpointsProtocol=https;AccountName=${storage.outputs.storageName};AccountKey=${storage.outputs.accountKey};EndpointSuffix=core.windows.net')
      }
    ]
  }
}
