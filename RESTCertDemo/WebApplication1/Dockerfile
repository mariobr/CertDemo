  # syntax=docker/dockerfile:1
  FROM mcr.microsoft.com/dotnet/aspnet:9.0
  # StartUp to initialize hasp...ini 
  # and the Wrapper
  COPY bin/Debug/net9.0/publish/ app/
  COPY bin/Debug/net9.0/publish/*.so /usr/local/lib/
  WORKDIR /app
  EXPOSE 8080


  ENTRYPOINT ["dotnet", "WebApplication1.dll"]