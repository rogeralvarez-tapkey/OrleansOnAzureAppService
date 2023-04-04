param location string = resourceGroup().location
param name string
param envVars array = []
param appServicePlanId string
param vnetSubnetId string

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlanId
    reserved: false
    virtualNetworkSubnetId: vnetSubnetId
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|7.0'
      vnetPrivatePortsCount: 2
      webSocketsEnabled: true
      appSettings: envVars
      netFrameworkVersion: 'v7.0'
      alwaysOn: true
    }
  }
}
