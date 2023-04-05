#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["OrleansOnAppService.Client/OrleansOnAppService.Client.csproj", "OrleansOnAppService.Client/"]
COPY ["Orleans.Azure.Infrastructure/Orleans.Azure.Infrastructure.csproj", "Orleans.Azure.Infrastructure/"]
COPY ["OrleansOnAppService.Abstractions/OrleansOnAppService.Abstractions.csproj", "OrleansOnAppService.Abstractions/"]
COPY ["OrleansOnAppService.Grains/OrleansOnAppService.Grains.csproj", "OrleansOnAppService.Grains/"]
RUN dotnet restore "OrleansOnAppService.Client/OrleansOnAppService.Client.csproj"
COPY . .
WORKDIR "/src/OrleansOnAppService.Client"
RUN dotnet build "OrleansOnAppService.Client.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OrleansOnAppService.Client.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OrleansOnAppService.Client.dll"]