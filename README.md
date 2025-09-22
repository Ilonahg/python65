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
