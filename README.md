# Docker Geoserver

[![Build and Push Docker Image](https://github.com/arszp10/geoserver/actions/workflows/docker.yml/badge.svg)](https://github.com/arszp10/geoserver/actions/workflows/docker.yml)

Этот проект основан на [tomcat java 11](https://hub.docker.com/_/tomcat) и использует плагин [GWC SQLite Plugin](https://docs.geoserver.org/latest/en/user/community/gwc-sqlite/index.html).

Как скачать?
```
docker pull ghcr.io/arszp10/geoserver:2.22.2
```

## Важно

Если вы используете прокси, например, traefik, то нужно в docker-compose.yml:
```
environment:
  PROXY_BASE_URL: https://geo.server.com/geoserver
```

Пример [демо](docker-compose.demo.yml) готового использования.

## Лицензия

Этот проект распространяется под лицензией MIT. Подробнее см. в файле [LICENSE](LICENSE).