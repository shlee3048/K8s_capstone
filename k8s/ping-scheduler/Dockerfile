FROM python:3.8-slim

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY config config
COPY zero_scheduler.py zero_scheduler.py

CMD [ "python", "zero_scheduler.py" ]
