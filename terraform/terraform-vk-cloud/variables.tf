variable "image_flavor" {
  type    = string
  default = "debian-12-202407311328.gitefba813a"
}


variable "compute_flavor" {
  type    = string
  default = "Standard-2-4-50"
}


variable "key_pair_name" {
  type    = string
  default = "key"
}


variable "availability_zone_name" {
  type    = string
  default = "GZ1"
}
