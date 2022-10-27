release: python manage.py migrate --noinput
web: gunicorn -b 0.0.0.0:8000 -w 4 -k uvicorn.workers.UvicornWorker dtb.asgi:application
worker: celery -A dtb worker -P prefork --loglevel=INFO 
beat: celery -A dtb beat --loglevel=INFO --scheduler django_celery_beat.schedulers:DatabaseScheduler
