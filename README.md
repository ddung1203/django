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