terraform {
  required_providers {
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

provider "kubernetes" {
    config_path    = local.k8s_config_path
    config_context = "kind-${local.cluster_name}"
    # client_certificate = kind_cluster.airflow_cluster.client_certificate
    # client_key = kind_cluster.airflow_cluster.client_key    
    # cluster_ca_certificate = kind_cluster.airflow_cluster.cluster_ca_certificate
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

