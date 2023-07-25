import logging

def get_loogger():
    return logging.getLogger("airflow.task")

def log_info(msg):
    logger = get_loogger()
    logger.info(msg)