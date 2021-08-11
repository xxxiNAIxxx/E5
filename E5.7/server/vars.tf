variable "network_id" {}
variable "subnet_id" {}
variable "hdd_size" {
  default = "5"
}

variable "vcpu_count" {
  default ="1"
}
variable "mem_size" {
  default ="2048"
}
variable "OS_image" {
  default ="CentOS 7 Minimal 64-bit"
}
variable "instance_name" {
  default ="ds0"
}

variable "instance_count" {
  default ="1"
}


variable "image_id" {}
variable "volume_type" {}
variable "flavor_id" {}
variable "key_pair_id" {}
variable "az_zone" {}