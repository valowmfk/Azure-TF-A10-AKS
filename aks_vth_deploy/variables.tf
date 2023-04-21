# The following two variable declarations are placeholder references.
# Set the values for these variable in terraform.tfvars
variable "aks_service_principal_app_id" {
  default = ""
}
variable "aks_service_principal_client_secret" {
  default = ""
}

variable "resource_group_name" {
  type = string
  description = "Resource Group name in Microsoft Azure"
  default = "<your values here>"
}

variable "prod_resource_group_name" {
  type = string
  description = "Storage Account Resource Group Name"
  default = "<your values here>"
}

variable "location" {
  type = string
  description = "Resources location in Microsoft Azure"
  default = "<your values here>" # Example: "westus"
}

variable "cluster_name" {
  type = string
  description = "AKS name in Microsoft Azure"
  default = "<your values here>"
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version"
  default ="1.24.9"
}

variable "system_node_count" {
  type = number
  description = "Number of AKS worker nodes"
  default ="2"
}

variable "node_resource_group" {
  type = string
  description = "Resource Group name for cluster resources in Microsoft Azure"
}

variable "cidr" {
  description = "Azure VPC CIDR"
  type        = string
  default     = "10.0.0.0/8"
}
variable "project" {
  description = "A10 Cloud Demo"
  # description = "Name of the project deployment."
  type = string
  default = "<your values here>" # Example: "A10CloudDemo"
}
variable "vth_admin_user" {
  description = "A10 vthunder Admin username"
  type = string
  default = "<your values here>" # Example: "admin"
}
variable "vth_admin_pass" {
  description = "A10 vThunder Admin Password"
  type = string
  default = "<your values here>" # Example: "a10"
  sensitive = true
}
variable "vth_mgmt_ip" {
  description = "A10 vThunder Management Public IP"
  type = string
  default = "<your values here>"
  sensitive = true
}