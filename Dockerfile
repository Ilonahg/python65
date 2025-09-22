FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# установим bash (и чуть-чуть базовых пакетов)
RUN apt-get update && apt-get install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# если есть requirements.txt — установим зависимости
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    if [ -f /app/requirements.txt ]; then pip install -r /app/requirements.txt; fi

# код и entrypoint
COPY . /app
COPY docker/entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh

EXPOSE 8000
