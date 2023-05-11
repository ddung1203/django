# For Normal Buster
FROM python:3.8.10-buster

# For Slim Buster
#FROM python:3.8.10-slim-buster
#RUN apt update && apt install -y gcc libc6-dev

# For Alpine Linux
#FROM python:3.8.10-alpine
#RUN apk add gcc musl-dev

COPY . /app


WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
EXPOSE 8000