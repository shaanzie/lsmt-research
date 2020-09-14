FROM python:3.7-alpine
WORKDIR /code
RUN apk add --no-cache gcc musl-dev linux-headers
RUN pip install cassandra-driver
EXPOSE 5000
COPY . .
CMD ["python", "setup_cassandra.py"]
