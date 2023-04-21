#
# Variables for TKC Demo
# Include vThunder Username of Admin, default password of a10
# 
# IP address should be updated from the deployment. Instance IDs can be used, or you can ssh via provided keys and configure admin/10 admin credentials
# API version supports the use of Instance IDs if that is preferred
# 
variable "vth_admin_user" {
  description = "A10 vthunder Admin username"
  type = string
  default = "admin"
}
variable "vth_admin_pass" {
  description = "A10 vThunder Admin Password"
  type = string
  default = "a10"
}
variable "vth_mgmt_ip" {
  description = "A10 vThunder Management Public IP"
  type = string
  default = "####"
}
variable "vth_public_ip" {
  description = "Public facing Interface IP"
  type = string
  default = "10.0.11.4"
}
variable "thunder_vip" {
  description = "VIP IP for vThunder in AWS"
  type = string
  default = "10.0.11.230"
}
