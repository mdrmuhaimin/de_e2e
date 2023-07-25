import os
from datetime import datetime

from airflow import DAG
from airflow.decorators import task
from airflow.operators.bash import BashOperator
from imdb.helpers.unload_data import meta_data_unload, ratings_data_unload, get_analytics
from utils.variables import Variables
from utils.common import log_info
from airflow.providers.postgres.operators.postgres import PostgresOperator

# A DAG represents a workflow, a collection of tasks
with DAG(
    dag_id="imdb", 
    start_date=datetime(2023, 7, 20), 
    schedule=None
) as dag:
    # Tasks are represented as operators
    download_data = BashOperator(
        task_id="download_data", 
        bash_command=f"kaggle datasets download rounakbanik/the-movies-dataset -p {Variables.airflow_home}/data"
    )
    extract_data = BashOperator(
        task_id="extract_data", 
        bash_command=f"unzip {Variables.airflow_home}/data/the-movies-dataset.zip -d {Variables.airflow_home}/data/{{{{ data_interval_end | ds_nodash }}}}"
    )
    create_movie_table = PostgresOperator(
        task_id="create_tables",
        postgres_conn_id="postgres_default",
        sql="sql/create_tables.sql",
    )

    @task(task_id="meta_data_unload")
    def task_meta_data_unload(data_interval_end=None):
        meta_data_unload(ds_end=data_interval_end.strftime("%Y%m%d"))
    
    @task(task_id="ratings_data_unload")
    def task_ratings_data_unload(data_interval_end=None):
        ratings_data_unload(ds_end=data_interval_end.strftime("%Y%m%d"))

    @task(task_id="get_analytics")
    def task_get_analytics(data_interval_end=None):
        sql_files = [
            "best_in_year.sql",
            "highest_rated.sql",
            "popular_genres.sql"
        ]
        for sql_file in sql_files:
            get_analytics(ds_end=data_interval_end.strftime("%Y%m%d"), sql_file=sql_file)
    
    # Set dependencies between tasks
    (
        download_data 
        >> extract_data
        >> create_movie_table
        >> task_meta_data_unload()
        >> task_ratings_data_unload()
        >> task_get_analytics()
    )
