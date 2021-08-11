output "server_internal_ips" {
  value = openstack_compute_instance_v2.instance_1.*.access_ip_v4
}