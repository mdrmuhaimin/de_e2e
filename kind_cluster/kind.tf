terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.0"
    }
  }
}

locals {
  k8s_config_path = pathexpand("~/.kube/config")
  cluster_name    = "airflow-cluster"
}

provider "kind" {}

resource "kind_cluster" "airflow_cluster" {
  name            = local.cluster_name
  kubeconfig_path = local.k8s_config_path
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    
    ## TODO use dynamic block for loop
    node {
      role = "control-plane"
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

        # extra_port_mappings {
        #   container_port = 8080
        #   host_port      = 8080
        # }
      #   extra_port_mappings {
      #     container_port = 443
      #     host_port      = 443
      #   }
    }

    node {
      role = "worker"
      kubeadm_config_patches = [
        "kind: JoinConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"node=worker_1\"\n"
      ]
      extra_mounts {
        container_path = "/temp/data"
        host_path      = "./data"
      }
    }
    node {
      role = "worker"
      kubeadm_config_patches = [
        "kind: JoinConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"node=worker_2\"\n"
      ]
      extra_mounts {
        container_path = "/temp/data"
        host_path      = "./data"
      }
    }
    node {
      role = "worker"
      kubeadm_config_patches = [
        "kind: JoinConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"node=worker_3\"\n"
      ]
      extra_mounts {
        container_path = "/temp/data"
        host_path      = "./data"
      }
    }
 }
}

