data "vkcs_networking_network" "extnet" {
  name = "ext-net"
}

resource "vkcs_networking_network" "network" {
  name = "net"
}

resource "vkcs_networking_subnet" "subnetwork" {
  name       = "subnet_1"
  network_id = vkcs_networking_network.network.id
  cidr       = "192.168.199.0/24"
}

resource "vkcs_networking_router" "router" {
  name                = "router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "db" {
  router_id = vkcs_networking_router.router.id
  subnet_id = vkcs_networking_subnet.subnetwork.id
}
