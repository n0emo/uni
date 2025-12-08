```yaml
volumes:
  pg_data:
  redis_data:
  caddy-config:
  caddy-data:

networks:
  web:
    driver: bridge
  backend:
    driver: bridge

services:
  postgres:
    image: docker.io/postgres:17
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      PG_DATA: /var/lib/postgresql/data/pgdata
    volumes:
      - pg_data:/var/lib/postgesql/data/pgdata
    restart: unless-stopped
    networks:
      - backend

  redis:
    image: docker.io/redis:latest
    volumes:
      - redis_data:/data
    restart: unless-stopped
    networks:
      - backend

  deanery-server:
    image: ${CONTAINER_REGISTRY}/server:latest
    depends_on:
      - postgres
    build:
      context: ../digital-deanery
      dockerfile: ../complete/server.Dockerfile
    environment:
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      API_EAISU_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      API_REDIS_URL: redis://redis:6379
    restart: unless-stopped
    networks:
      - backend
      - web

  deanery-web:
    image: ${CONTAINER_REGISTRY}/web:latest
    build:
      context: ..
      dockerfile: complete/web.Dockerfile
      args:
        PUBLIC_BASE_URL: ${APP_SCHEME}://${APP_DOMAIN}
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile
      - caddy-config:/config
      - caddy-data:/data
    restart: unless-stopped
    depends_on:
      - deanery-server
    networks:
      - web

  adminer:
    image: docker.io/adminer
    restart: unless-stopped
    networks:
      - backend
      - web

  watchtower:
    image: docker.io/containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /root/.docker/config.json:/config.json
    restart: unless-stopped
    command: --interval 30
```
