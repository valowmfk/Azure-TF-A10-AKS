# resource "local_file" "kubeconfig" {
#   depends_on   = [azurerm_kubernetes_cluster.cluster]
#   filename     = "kubeconfig"
#   content      = azurerm_kubernetes_cluster.cluster.kube_config_raw
# }

#
# Generate outputs to display information once apply is complete
#

output "public_ip_address_id" {
  value = azurerm_network_interface.vth-public-nic.ip_configuration
}
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "cluster_password" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].password
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].username
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vth_mgmt_public_ip" {
  value = azurerm_network_interface.vth-mgmt.ip_configuration
}