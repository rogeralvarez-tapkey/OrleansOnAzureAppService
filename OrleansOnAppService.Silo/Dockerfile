#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 11111
EXPOSE 30000
EXPOSE 20044
EXPOSE 20045

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["OrleansOnAppService.Silo/OrleansOnAppService.Silo.csproj", "OrleansOnAppService.Silo/"]
COPY ["Orleans.Azure.Infrastructure/Orleans.Azure.Infrastructure.csproj", "Orleans.Azure.Infrastructure/"]
COPY ["OrleansOnAppService.Abstractions/OrleansOnAppService.Abstractions.csproj", "OrleansOnAppService.Abstractions/"]
COPY ["OrleansOnAppService.Grains/OrleansOnAppService.Grains.csproj", "OrleansOnAppService.Grains/"]
RUN dotnet restore "OrleansOnAppService.Silo/OrleansOnAppService.Silo.csproj"
COPY . .
WORKDIR "/src/OrleansOnAppService.Silo"
RUN dotnet build "OrleansOnAppService.Silo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OrleansOnAppService.Silo.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OrleansOnAppService.Silo.dll"]