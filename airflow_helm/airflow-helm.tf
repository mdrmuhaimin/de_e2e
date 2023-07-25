terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }
}

locals {
  k8s_config_path = pathexpand("~/.kube/config")
  cluster_name    = "airflow-cluster"
}


provider "helm" {
  kubernetes {
    config_path = local.k8s_config_path
  }
}

resource "helm_release" "airflow" {
  repository = "https://airflow.apache.org"
  chart      = "airflow"
  name       = "airflow"
  namespace  = "airflow"
  values     = [
    file("${path.module}/airflow_values.yaml")
  ]
  # wait = false
}

# resource "null_resource" "localstack_port_forwarding" {
#   provisioner "local-exec" {
#     command = "kubectl port-forward svc/airflow-webserver 8080:8080  -n airflow --context kind-airflow-cluster"
#   }
#   depends_on = [ helm_release.airflow ]
# }