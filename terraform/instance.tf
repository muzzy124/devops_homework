data "vkcs_compute_flavor" "compute" {
  name = "Basic-1-2-20"
}

data "vkcs_images_image" "compute" {
  name = "Ubuntu-18.04-Standard"
}

resource "vkcs_compute_instance" "compute" {
  name                    = "user04-homework"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  security_groups         = ["default", "all"]
  availability_zone       = "GZ1"
  key_pair = vkcs_compute_keypair.test-keypair.name

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 8
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 8
    boot_index            = 1
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.compute.id
  }

  depends_on = [
    vkcs_networking_network.compute,
    vkcs_networking_subnet.compute
  ]
}

resource "vkcs_compute_keypair" "test-keypair" {
  name       = "user04-homework"
  public_key = file("../keys/id_rsa.pub")
}

resource "vkcs_networking_floatingip" "fip" {
  pool = data.vkcs_networking_network.extnet.name
}

resource "vkcs_compute_floatingip_associate" "fip" {
  floating_ip = vkcs_networking_floatingip.fip.address
  instance_id = vkcs_compute_instance.compute.id
}

output "instance_fip" {
  value = vkcs_networking_floatingip.fip.address
}


# resource "local_file" "ansible_inventory" {
#   content = templatefile("./ansible/env/inventory.tmpl"),
#     {
#      hostname_ip = instance_fip
#     }
#   )
#   filename = "./ansible/env/inventory"

