# variable "subscription_id" {
#     description = "Azure Tenant Subscription ID"
#     type = string
#     default = "b0cdab2f-abd4-43ae-a3d2-f0b7afd8e52e"
# }
# variable "client_id" {
#     description = "Service Principal App ID"
#     type = string
#     default = "cc884e38-67da-client-id"
# }
# variable "client_secret" {
#     description = "Service Principal Password"
#     type = string
#     default = "3t.8Q~C31mf-client-secret"
# }
# variable "tenant_id" {
#     description = "Azure Tenant ID"
#     type = string
#     default = "91d27ab9-8c5e-41d4-82e8-3d1bf81fcb2f"
# }
variable "resource_group_name" {
  type = string
  description = "Resource Group name in Microsoft Azure"
  default = "A10CloudDemoRG"
}

variable "prod_resource_group_name" {
  type = string
  description = "Storage Account Resource Group Name"
  default = "a10se-prod-rg"
}

variable "location" {
  type = string
  description = "Resources location in Microsoft Azure"
  default = "westus"
}

variable "cluster_name" {
  type = string
  description = "AKS name in Microsoft Azure"
  default = "A10CloudDemoCluster"
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
  default = "A10CloudDemo"
}
variable "azs" {
  description = "The number of AZs."
  type        = number
  default     = 2
}
variable "vth_admin_user" {
  description = "A10 vthunder Admin username"
  type = string
  default = "seclouddemo"
}
variable "vth_admin_pass" {
  description = "A10 vThunder Admin Password"
  type = string
  default = "aNetw0rks!(10)"
}