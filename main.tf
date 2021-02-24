terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.24.1"
    }
  }
}

provider "hcloud" {
  token = var.token
}

resource "hcloud_ssh_key" "server_admin" {
  name       = "server_admin"
  public_key = file(var.ssh_public_key)
}

resource "hcloud_server" "minecraft-server" {
  name        = "minecraft-server"
  image       = "ubuntu-20.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.server_admin.id]

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for server to be initialized...'"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      agent       = var.agent
      private_key = file(var.ssh_private_key)
    }
  }


  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' minecraft-server-install.yml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' backup-minecraft-data.yml"
  }
}
