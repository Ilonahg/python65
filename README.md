 Описание проекта

Этот проект — учебное задание, в котором настроен CI/CD процесс для Python/Django приложения с использованием GitHub Actions и (теоретически) деплоя на удалённый сервер через Docker.

Новый функционал

Добавлен docker-compose.prod.yaml для запуска проекта в продакшене.
В нём описаны сервисы:

web — приложение (Django + Gunicorn),

db — база PostgreSQL,

redis — брокер для Celery,

celery и beat — фоновые задачи,

nginx — отдаёт статику и проксирует запросы.

Создан Dockerfile.prod и скрипт entrypoint.prod.sh, который перед стартом Gunicorn выполняет миграции и сбор статики.

Настроен CI/CD workflow в GitHub Actions:

проверка линтеров и тестов,

(опционально) сборка Docker-образа,

деплой на сервер по SSH.

Все тесты успешно проходят, код проверяется линтерами (flake8, black, isort, mypy).

Настройка сервера (теория)

Этот раздел нужен только как документация. Делать это реально для сдачи ДЗ не обязательно.

На сервере (Ubuntu 22.04+) установить Docker и docker compose plugin.

Создать папку для проекта:

mkdir -p /home/deploy/apps/python65


Добавить туда файл .env с настройками окружения. Пример:

SECRET_KEY=замени_на_свой
DEBUG=False
ALLOWED_HOSTS=*

DB_HOST=db
DB_PORT=5432
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=postgres

REDIS_HOST=redis
REDIS_PORT=6379


Запустить проект:

cd /home/deploy/apps/python65
docker compose -f docker-compose.prod.yaml up -d --build

CI/CD через GitHub Actions
Как устроено

Job CI — проверка стиля, типизации и тестов.

Job Deploy — при успешном CI подключается по SSH к серверу и выполняет команды:

обновление кода,

docker compose pull && docker compose up -d --build.

Секреты

В разделе Settings → Secrets and variables → Actions добавляются:

SSH_HOST — IP сервера,

SSH_USER — пользователь (например, deploy),

SSH_KEY — приватный ключ для подключения,

(опц.) SSH_PORT — порт SSH,

(опц.) REMOTE_DIR — путь к папке проекта.

Запуск workflow вручную

Перейти во вкладку Actions в GitHub.

Выбрать workflow CI/CD.

Нажать Run workflow, выбрать ветку (например, develop или main).

Дождаться завершения job ci и (если включён) deploy.

Ручной деплой без Actions

На сервере можно выполнить:

cd /home/deploy/apps/python65
git pull origin main
docker compose -f docker-compose.prod.yaml up -d --build --remove-orphans

Траблшутинг

Permission denied (publickey) — проверь SSH-ключи.

docker: command not found — установи Docker.

502 Bad Gateway через nginx — смотри логи контейнера web:

docker logs web


Статика не отображается — проверь, что отработал collectstatic и тома static_volume смонтированы к Nginx.