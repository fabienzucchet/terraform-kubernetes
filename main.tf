terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "terraform" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "docker_pull_secret" {
  metadata {
    name      = "registry-vr"
    namespace = kubernetes_namespace.terraform.metadata.0.name
  }

  data = {
    ".dockercfg" = file("${path.module}/docker-registry.json")
  }

  type = "kubernetes.io/dockercfg"
}

