# company
variable "company" {
  type        = string
  description = "This variable defines the name of the company"
  default = "a10se"
}
# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default = ""
}
# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "westus"
}