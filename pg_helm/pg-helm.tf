terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
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

resource "helm_release" "postgres" {
  name       = "my-release"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  namespace  = "airflow"
  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = "q1w2e3r4"
  }
}
