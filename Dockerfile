FROM python:3.8.5

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app app
COPY run.py .
COPY config.py .
COPY create_db.py .

RUN python3 config.py
RUN python3 create_db.py

ENTRYPOINT ["python3"]
CMD ["run.py"]
