# Django + Postgres + Redis + Celery (Docker Compose)

Мини-стек для домашки: **Django backend**, **PostgreSQL**, **Redis**, **Celery worker** и **Celery Beat**.  
Проверка живости: `GET /healthz → {"status":"ok"}`.

## Сервисы

| Сервис   | Описание                  | Порт/URL              |
|----------|---------------------------|-----------------------|
| backend  | Django dev server         | http://localhost:8000 |
| db       | PostgreSQL 15             | 5432                  |
| redis    | Redis 7                   | 6379                  |
| celery   | Celery worker             | —                     |
| beat     | Celery beat (scheduler)   | —                     |

---

## Быстрый старт

```bash
# 1) Переменные окружения
cp .env.example .env
# при необходимости поправь значения в .env

# 2) Сборка и запуск
docker compose up -d --build

# 3) Миграции и суперпользователь (опционально)
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
## Деплой

1. При push в ветку `develop` запускается GitHub Actions.
2. Выполняются тесты.
3. Если тесты прошли успешно, запускается шаг "deploy".
4. В реальном проекте деплой выполняется на удалённый сервер через SSH.
5. Для безопасности используются GitHub Secrets (`SERVER_IP`, `SERVER_USER`, `SSH_KEY`).

## Как запустить локально
```bash
pytest
## Продакшен (Yandex Cloud)

### Подготовка сервера (один раз)
1. Создай ВМ в Yandex Cloud (Ubuntu LTS, 2CPU/2GB достаточно). Открой 80/tcp.
2. Подключись по SSH и установи Docker + docker compose plugin:
   ```bash
   curl -fsSL https://get.docker.com | sh
   DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
   mkdir -p $DOCKER_CONFIG/cli-plugins
   curl -SL https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
   chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
