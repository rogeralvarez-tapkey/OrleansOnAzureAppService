param (
    $resourceBaseName="orleanscontapp$( Get-Random -Maximum 1000)",
    $location='westeurope'
)

Write-Host 'Compiling app code' -ForegroundColor Cyan

dotnet restore
dotnet build

Write-Host 'Creating resource group' -ForegroundColor Cyan
az group create -l $location -n $resourceBaseName

Write-Host 'Creating Azure Container Registry instance' -ForegroundColor Cyan
$Env:acrRegistry=$(az deployment group create --resource-group $resourceBaseName --template-file 'deploy/acr.bicep' --query properties.outputs.registryName.value).replace('"', '')

Write-Host 'Created ACR registry' $Env:acrRegistry -ForegroundColor Green

$Env:acrLoginServer="$($Env:acrRegistry).azurecr.io"

Write-Host 'Logging in to ACR registry' $Env:acrLoginServer -ForegroundColor Cyan
az acr login -n $Env:acrRegistry

Write-Host 'Building and pushing container images ' -ForegroundColor Cyan
Start-Sleep -Seconds 1.5
docker compose build
docker compose push
$Env:acrUser=$(az acr credential show -n $Env:acrRegistry --query username -o tsv)
$Env:acrPass=$(az acr credential show -n $Env:acrRegistry --query "passwords[0].value" -o tsv)

Write-Host 'Creating Azure Container Apps Environment and deploying code to it ' -ForegroundColor Cyan

az deployment group create --resource-group $resourceBaseName --template-file 'deploy/main.bicep' `
--parameters siloImage="$($Env:acrLoginServer)/silo:latest" `
--parameters dashboardImage="$($Env:acrLoginServer)/dashboard:latest" `
--parameters clientImage="$($Env:acrLoginServer)/client:latest" `
--parameters registry=$Env:acrLoginServer `
--parameters registryUsername=$Env:acrUser `
--parameters registryPassword=$Env:acrPass

Write-Host 'Environment deployed.' -ForegroundColor Cyan

az deployment group create --resource-group $resourceBaseName --template-file 'deploy/main.bicep' `
--parameters siloImage="$($Env:acrLoginServer)/silo:latest" `
--parameters dashboardImage="$($Env:acrLoginServer)/dashboard:latest" `
--parameters clientImage="$($Env:acrLoginServer)/client:latest" `
--parameters registry=$Env:acrLoginServer `
--parameters registryUsername=$Env:acrUser `
--parameters registryPassword=$Env:acrPass