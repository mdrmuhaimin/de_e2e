poetry export -f requirements.txt --output requirements.txt --without-hashes
docker build -t airflow-custom:latest .
kind load docker-image airflow-custom:latest --name airflow-cluster 