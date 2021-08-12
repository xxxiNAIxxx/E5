output "server_external_ip" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}
output "server_internal_ips" {
  value = module.server_remote_root_disk_1.server_internal_ips
}
