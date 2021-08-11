#############################################
# Initialize OpenStack provider
#############################################
provider "openstack" {
  domain_name = var.domain_name
  tenant_id   = var.project_id
  user_name   = var.user_name
  password    = var.user_password
  auth_url    = "https://api.selvpc.ru/identity/v3"
  region      = var.region
}
###################################
# Create Flavor
###################################
resource "random_string" "random_name_1" {
  length  = 16
  special = false
}

resource "openstack_compute_flavor_v2" "flavor-node" {
  name      = var.instance_name
  ram       =  var.mem_size
  vcpus     = var.vcpu_count
  disk      = "0"
  is_public = "false"
}

###################################
# Get image ID
###################################
data "openstack_images_image_v2" "ubuntu" {
  most_recent = true
  name        = var.OS_image
}
###################################
# Create SSH-key
###################################
resource "openstack_compute_keypair_v2" "terraform_key" {
  name       = "terraform_key-${random_string.random_name_1.result}"
  region     = var.region
  public_key = file("~/.ssh/id_rsa.pub")
}

###################################
# Create Network and Subnet
###################################
data "openstack_networking_network_v2" "external_net" {
  name = "external-network"
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router_1"
  external_network_id = data.openstack_networking_network_v2.external_net.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

resource "openstack_networking_network_v2" "network_1" {
  name = "network_1"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  network_id      = openstack_networking_network_v2.network_1.id
  name            = "192.168.0.0/24"
  cidr            = "192.168.0.0/24"
  dns_nameservers = ["188.93.16.19", "188.93.17.19"]
}

###################################
# Create Server
###################################
module "server_remote_root_disk_1" {
  source = "./server"

  network_id = openstack_networking_network_v2.network_1.id
  subnet_id= openstack_networking_subnet_v2.subnet_1.id
  hdd_size = var.hdd_size
  vcpu_count= var.vcpu_count
  mem_size = var.mem_size
  OS_image=var.OS_image
  instance_name = var.instance_name

  image_id = 699c167a-6ea4-4847-a526-5f315bd2d424
  volume_type = var.volume_type
  az_zone = var.az_zone
  flavor_id = openstack_compute_flavor_v2.flavor-node.id
  key_pair_id = openstack_compute_keypair_v2.terraform_key.id
}

###################################
# Create floating IP
###################################
# resource "openstack_networking_floatingip_v2" "floatingip_1" {
#   pool = "external-network"
# }

###################################
# Link floating IP to internal IP
###################################
# resource "openstack_networking_floatingip_associate_v2" "association_1" {
#   port_id     = openstack_networking_port_v2.port_1.id
#   floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
# }
