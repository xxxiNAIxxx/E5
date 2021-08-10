variable "domain_name" {}
variable "project_id" {}
variable "user_name" {}
variable "user_password" {}
variable "region" {}
variable "az_zone" {}
variable "volume_type" {}
variable "public_key" {}
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
  default ="ds01.s015382"
}
