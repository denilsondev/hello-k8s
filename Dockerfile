# Usa a imagem base do ASP.NET Core para rodar a aplicação
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# Define o diretório de trabalho como /app
WORKDIR /app
# Expõe a porta 80 para acesso externo
EXPOSE 80

# Usa a imagem do SDK do .NET para compilar a aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Define o diretório de trabalho como /src
WORKDIR /src
# Copia os arquivos do projeto da pasta src para o container
COPY src/. .
# Publica a aplicação em modo Release na pasta /app/publish
RUN dotnet publish -c Release -o /app/publish

# Cria a imagem final baseada na imagem base
FROM base AS final
# Define o diretório de trabalho como /app
WORKDIR /app
# Garante que o ASP.NET rode na porta 8080
ENV ASPNETCORE_URLS=http://+:8080
# Copia os arquivos publicados da etapa de build para o diretório de trabalho
COPY --from=build /app/publish .
# Define o ponto de entrada para rodar a aplicação
ENTRYPOINT ["dotnet", "HelloK8s.dll"]