FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5083

ENV ASPNETCORE_URLS=http://+:5083

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["chizoma.csproj", "./"]
RUN dotnet restore "chizoma.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "chizoma.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "chizoma.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "chizoma.dll"]
