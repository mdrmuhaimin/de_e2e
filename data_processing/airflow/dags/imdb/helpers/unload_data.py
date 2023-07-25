# import opendatasets as od
from utils.variables import Variables
import pandas as pd
import os
import json
import ast
from airflow.providers.postgres.hooks.postgres import PostgresHook
from sqlalchemy import create_engine

data_path = f"{Variables.airflow_home}/data"


def meta_data_unload(ds_end):
    select_columns = [
        "original_title",
        "budget",
        "genres",
        "id",
        "imdb_id",
        "release_date",
        "revenue",
        "vote_average",
    ]
    json_columns = ["genres"]
    df = pd.read_csv(f"{data_path}/{ds_end}/movies_metadata.csv")[select_columns]
    for col in json_columns:
        df[col].fillna("{}", inplace=True)
        df[col] = df[col].apply(
            lambda x: json.dumps(ast.literal_eval(x))
            if not isinstance(x, dict)
            else json.dumps(x)
        )
    df["release_date"] = pd.to_datetime(
        df["release_date"], format="%Y-%m-%d", errors="coerce"
    )
    df.dropna(subset=["release_date"], inplace=True)
    engine = create_engine(PostgresHook().get_uri())
    df.drop_duplicates().to_sql("movies_metadata", con=engine, if_exists="replace")


def ratings_data_unload(ds_end):
    engine = create_engine(PostgresHook().get_uri())
    (
        pd.read_csv(f"{data_path}/{ds_end}/ratings.csv")
        .drop_duplicates()
        .to_sql("ratings", con=engine, if_exists="replace")
    )


def get_analytics(ds_end, sql_file):
    engine = create_engine(PostgresHook().get_uri())
    with open(f"{Variables.airflow_home}/dags/imdb/sql/{sql_file}", "r") as f:
        sql_query = f.read()
    s_path = f"{Variables.airflow_home}/data/analytics/{ds_end}"
    os.makedirs(s_path, exist_ok=True)
    pd.read_sql(sql_query, con=engine).to_csv(
        f"{s_path}/{sql_file.replace('.sql', '.csv')}",
        index=False,
    )
