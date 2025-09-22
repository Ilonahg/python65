#!/usr/bin/env bash
set -e

# ждём базу
if [ -n "$DB_HOST" ]; then
  until nc -z "$DB_HOST" "${DB_PORT:-5432}"; do echo "waiting for db..."; sleep 1; done
fi

python manage.py migrate --noinput
python manage.py collectstatic --noinput

# gunicorn
exec gunicorn core.wsgi:application \
  --bind 0.0.0.0:8000 \
  --workers ${GUNICORN_WORKERS:-3} \
  --timeout ${GUNICORN_TIMEOUT:-30} \
  --access-logfile '-' --error-logfile '-'
