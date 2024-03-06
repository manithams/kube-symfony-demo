variable "resource_group_name" {
  type        = string
  description = "The group name of resources"
  default     = "symfony-demo"
}

variable "environment" {
  type        = string
  description = "The environment name"
  default     = "dev"

}

variable "default_tags" {
  type        = map(string)
  description = "label to identify service/purpose"
  default     = { "managed" = "terraform" }
}

variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}