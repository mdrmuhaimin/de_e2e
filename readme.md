# Data Engineering with airflow and Kubernetes

## Prerequisite

- Install terraform, this would be used to provision kubernetes cluster, for development we will use a local kubernetes cluster; and we can also use terraform to provision kubernetes cluster in cloud
- Install a local Kubernetes cluster, here we have used [kind](https://kind.sigs.k8s.io/docs/user/quick-start#installing-with-a-package-manager)
- Install kubectl and helm if you use a mac you can simply install them using `brew install kubectl helm`

## Setup

For each of them navigate to terraform directory and simply terraform apply

### Provision Database

- Deploy [kind cluster](kind_cluster)
- Deploy [kubernetes namespaces](kubernetes_namespace)
- Deploy [postgres helm chart](pg_helm)
- Open up a running postgres by running `kubectl port-forward svc/my-release-postgresql 5432:5432 -n airflow`

### Deploy Data Pipeline

- Navigate to [Data_processing](data_processing)
- Build the docker image by running

    ```bash
    poetry export -f requirements.txt --output requirements.txt --without-hashes
    docker build -t airflow-custom:latest .
    ``````

- Add two env variable
  
  ```bash
  KAGGLE_USERNAME=<user>
  KAGGLE_KEY=<pass>
  ``````

  at [data_processing/dev.env.list](data_processing/dev.env.list)
- Run `docker-compose up` it will launch an airflow cluster locally, this will demonstrate a local server you need to configure connectivity to host postgres
- Alternatively run `airflow webserver` and navigate to airflow connections and change default postgres as defined [here](Connection.png)
- Use password `q1w2e3r4`
- You can load the docker image to [kind cluster](data_processing/build-docker.sh) and also deploy the airflow using helm chart. A terraform script is provided [here](airflow_helm)
- You also need to update the env [here](airflow_helm/airflow_values.yaml)

### Datapipelines

- All the code for the data pipelines are [data_processing/airflow/dags/imdb](data_processing/airflow/dags/imdb)
- This is part of an airflow dag
- All the required SQL can be found [data_processing/airflow/dags/imdb/sql](data_processing/airflow/dags/imdb/sql)

### Productionization

- How would you package the pipeline code for deployment?
  - Using CI/CD pipeline as a docker image
- How would you schedule a pipeline that runs the ingestion and the transformation tasks sequentially every day?
  - Using airflow this is demonstrated here
- How would you ensure the quality of the data generated from the pipeline?
  - Using a data validation tool like [Great expections](https://greatexpectations.io/community)