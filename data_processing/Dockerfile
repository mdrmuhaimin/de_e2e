ARG AIRFLOW_VERSION="2.4.3"
ARG PY_VERSION="3.9"
# AIRFLOW_HOME is set by default at /opt/airflow/ airflow docker image
# https://airflow.apache.org/docs/docker-stack/index.html#usage
FROM apache/airflow:${AIRFLOW_VERSION}-python${PY_VERSION}
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends\
    unzip

USER airflow
RUN python -m pip install --upgrade pip
RUN mkdir -p ${AIRFLOW_HOME}/logs
COPY ./airflow/dags ${AIRFLOW_HOME}/dags
COPY requirements.txt ${AIRFLOW_HOME}/
RUN pip install --no-cache-dir -r ${AIRFLOW_HOME}/requirements.txt
