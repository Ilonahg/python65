#!/usr/bin/env bash
set -e
if [ -f manage.py ]; then : ; elif [ -f app/manage.py ]; then cd app; fi
python manage.py migrate --noinput || true
python manage.py collectstatic --noinput || true
exec python manage.py runserver 0.0.0.0:8000
