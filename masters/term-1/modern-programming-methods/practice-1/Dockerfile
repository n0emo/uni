FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /build

COPY UrlShortener.fsproj ./
RUN dotnet restore

COPY appsettings.json ./
COPY migrations/ migrations/
COPY src/ src/
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app ./

USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "UrlShortener.dll"]
