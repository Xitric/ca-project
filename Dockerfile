FROM xitric/ca-project-test:latest

COPY app app
COPY run.py .
COPY config.py .
COPY create_db.py .

RUN python3 config.py
RUN python3 create_db.py

ENTRYPOINT ["python3"]
CMD ["run.py"]
