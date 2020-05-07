FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["TEST/TEST.csproj", "TEST/"]
RUN dotnet restore "TEST/TEST.csproj"
COPY . .
WORKDIR "/src/TEST"
RUN dotnet build "TEST.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TEST.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TEST.dll"]