param location string = resourceGroup().location
param name string
param envVars array = []
param containerAppEnvironmentId string
param repositoryImage string
param allowExternalIngress bool = false
param targetIngressPort int = 80
param registry string
param registryUsername string
param minReplicas int = 1
param maxReplicas int = 10
@secure()
param registryPassword string

resource containerApp 'Microsoft.App/containerApps@2022-10-01' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironmentId

    configuration: {
      secrets: [
        {
          name: 'container-registry-password'
          value: registryPassword
        }
      ]      
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: allowExternalIngress
        targetPort: targetIngressPort
      }
    }
    template: {
      containers: [
        {
          image: repositoryImage
          name: name
          env: envVars
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}
