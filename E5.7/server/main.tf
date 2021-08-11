###################################
# Create port
###################################
resource "openstack_networking_port_v2" "port_1" {
  name       = "node-eth0"
  network_id = var.network_id

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

###################################
# Create Volume/Disk
###################################
resource "openstack_blockstorage_volume_v3" "volume_1" {
  name                 = "volume-for-node"
  size                 = var.hdd_size
  image_id             = var.image_id
  volume_type          = var.volume_type
  availability_zone    = var.az_zone
  enable_online_resize = true

  lifecycle {
    ignore_changes = [image_id]
  }
}
###################################
# Create Server
###################################
resource "openstack_compute_instance_v2" "instance_1" {
  name              = var.instance_name
  flavor_id         = var.flavor_id
  key_pair          = var.key_pair_id
  availability_zone = var.az_zone

  network {
    port = openstack_networking_port_v2.port_1.id
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  vendor_options {
    ignore_resize_confirmation = true
  }

}