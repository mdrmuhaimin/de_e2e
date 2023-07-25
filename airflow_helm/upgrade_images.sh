helm install airflow apache-airflow/airflow --namespace airflow --debug
helm upgrade --install airflow apache-airflow/airflow -n airflow -f airflow_value_custom_repo.yaml --debug