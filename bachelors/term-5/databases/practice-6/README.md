# ПГУПС Галерея

## Требования

- [rustup.rs - The Rust toolchain installer](https://rustup.rs/)
- S3-совместимое хранилище

## Быстрый старт

Проект имеет `docker-compose.yaml` для запуска S3-совместимого хранилища
[SeaweedFS](https://github.com/seaweedfs/seaweedfs). Запуск компоуза и проекта:

```bash
$ docker compose up -d
$ cargo run
```

В результате по адресу http://localhost:3000 станет доступно веб-приложение.
