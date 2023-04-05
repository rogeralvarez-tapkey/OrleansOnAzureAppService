param location string = resourceGroup().location
param acrName string = toLower('${replace(resourceGroup().name, '-', '')}acr')

resource acr 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output registryName string = acr.name
output loginServer string = acr.properties.loginServer
