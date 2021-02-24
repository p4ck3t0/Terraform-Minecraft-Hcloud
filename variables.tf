variable "token" {
  description = "Hetzner Cloud api token. At least read and write access is needed!"
}

variable "server_type" {
  description = "Determine the size of your server"
  default     = "cx31"
}

variable "location" {
  description = "Server location. Choose between nbg1, fsn1 or hel1"
  default     = "nbg1"
}

variable "agent" {
  description = "If you want to use the SSH agent"
  default     = false
}

variable "ssh_private_key" {
  description = "Private Key to access the server via. ssh"
  default     = "~/.ssh/id_minecraft-server"
}

variable "ssh_public_key" {
  description = "Public Key to authorized the access for the server"
  default     = "~/.ssh/id_minecraft-server.pub"
}
