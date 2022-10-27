FROM python:3.10.8

ARG DJANGO_DEBUG
ARG DATABASE_URL
ARG DJANGO_SECRET_KEY
ARG DATABASE_URL
ARG REDIS_URL
ARG TELEGRAM_TOKEN
ENV PYTHONUNBUFFERED=1
ENV DJANGO_DEBUG=$DJANGO_DEBUG
ENV DATABASE_URL=$DATABASE_URL
ENV DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY
ENV DATABASE_URL=$DATABASE_URL
ENV REDIS_URL=$REDIS_URL
ENV TELEGRAM_TOKEN=$TELEGRAM_TOKEN

RUN mkdir /code
WORKDIR /code

COPY requirements.txt /code/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /code/

RUN python manage.py migrate --noinput \
    && gunicorn --bind :$PORT --workers 4 --worker-class uvicorn.workers.UvicornWorker dtb.asgi:application \
    && celery -A dtb worker -P prefork --loglevel=INFO \
    && celery -A dtb beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler