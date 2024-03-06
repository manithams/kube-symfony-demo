terraform {
  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.26.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
  backend "s3" {
    bucket = "lingoda-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_version = "~>1.7"
}

provider "kubernetes" {
  config_path = pathexpand(var.kind_cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}