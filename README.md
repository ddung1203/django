# django

``` bash
python3 -m venv .venv
pip install django

django-admin startproject mysite .

python3 manage.py migrate

python3 manage.py runserver
```

``` bash
python3 manage.py startapp blog

python3 manage.py makemigrations blog
python3 manage.py migrate blog

python3 manage.py createsuperuser
```

``` bash

```

``` bash
pip freeze > requirements.txt
```

`Dockerfile`
``` Dockerfile
# For Normal Buster
FROM python:3.9-buster

# For Slim Buster
#FROM python:3.9-slim-buster
#RUN apt update && apt install -y gcc libc6-dev

# For Alpine Linux
#FROM python:3.9-alpine
#RUN apk add gcc musl-dev

COPY . /app


WORKDIR /app/mysite
RUN pip3 install -r requirements.txt
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
EXPOSE 8000
```

`.dockerignore`
```
.venv/
Dockerfile
.dockerignore
.gitignore
README.md
```