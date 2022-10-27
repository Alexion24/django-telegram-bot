FROM python:3.10.8

ENV PYTHONUNBUFFERED=1

RUN mkdir /code
WORKDIR /code

COPY requirements.txt /code/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /code/

CMD python manage.py migrate --noinput
    && gunicorn --bind :$PORT --workers 4 --worker-class uvicorn.workers.UvicornWorker dtb.asgi:application
    && celery -A dtb worker -P prefork --loglevel=INFO
    && celery -A dtb beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler