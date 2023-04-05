#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 30000
EXPOSE 20044
EXPOSE 20045

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["OrleansOnAppService.Dashboard/OrleansOnAppService.Dashboard.csproj", "OrleansOnAppService.Dashboard/"]
COPY ["Orleans.Azure.Infrastructure/Orleans.Azure.Infrastructure.csproj", "Orleans.Azure.Infrastructure/"]
RUN dotnet restore "OrleansOnAppService.Dashboard/OrleansOnAppService.Dashboard.csproj"
COPY . .
WORKDIR "/src/OrleansOnAppService.Dashboard"
RUN dotnet build "OrleansOnAppService.Dashboard.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OrleansOnAppService.Dashboard.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OrleansOnAppService.Dashboard.dll"]