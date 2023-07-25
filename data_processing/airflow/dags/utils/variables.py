import os
from airflow.models import Variable


class Variables:
    kaggle_username = os.environ.get("KAGGLE_USERNAME", None)
    kaggle_key = os.environ.get("KAGGLE_KEY", None)
    airflow_home = os.environ.get(
        "AIRFLOW_HOME", os.path.abspath(".") if os.path.abspath(".").endswith("airflow") else f'{os.path.abspath(".")}/airflow'
    )
