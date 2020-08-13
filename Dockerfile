FROM python:3.8.5

COPY app app
COPY run.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

ENTRYPOINT ["python3"]
CMD ["run.py"]
