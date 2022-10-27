FROM python:3.10.8

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

RUN python manage.py migrate --noinput
RUN gunicorn --bind :$PORT --workers 4 --worker-class uvicorn.workers.UvicornWorker dtb.asgi:application
RUN celery -A dtb worker -P prefork --loglevel=INFO
RUN celery -A dtb beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler