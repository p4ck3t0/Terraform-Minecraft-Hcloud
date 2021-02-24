# Terraform Minecraft Server on Hetzner Cloud

This repository will help to setup an Minecraft Server at the Hetzner Cloud using [Terraform](https://www.terraform.io/), [Ansible](https://www.ansible.com/) and [itzg docker container](https://github.com/itzg/docker-minecraft-server)
and a backup will be created automatically when you stop playing. If you start the Server again, the backup is restored.


## Requirements

### Packages

* Terraform
* Ansible

#### Tested with Versions

* Terraform [v0.14.7](https://github.com/hashicorp/terraform/blob/v0.14.7/CHANGELOG.md)
* provider.hcloud [v1.24.1](https://github.com/terraform-providers/terraform-provider-hcloud)
* Ansible [2.10.6](https://github.com/ansible-community/ansible-build-data/blob/main/2.10/CHANGELOG-v2.10.rst#v2-10-6)

### SSH Key

By default the script uses the ssh key `~/.ssh.id_minecraft-server`. This key must be available and can be created using `ssh-keygen`, or you can set the value of the
variables `ssh_private_key` and `ssh_public_key` in a `.tfvars` file and change the value of `ansible_ssh_private_key_file` in `provision/ansible-variables.yml`. If
you want to use a password protected ssh key, you can use the `ssh-agent`.

#### Using SSH Agent

Use the following commands to add your ssh-key to the ssh-agent.

```bash
$ eval $(ssh-agent)
$ ssh-add /path/to/your/password/protected/key
```

After that, the following line in main.tf must be commented out.

|  Before                                   |   After                                     |
|:------------------------------------------|:--------------------------------------------|
| `private_key = file(var.ssh_private_key)` | `# private_key = file(var.ssh_private_key)` |

## The Minecraft Server

The Minecraft server is a docker container from itzg, all credits for the docker container itself belong to him! In itzg [Repo](https://github.com/itzg/docker-minecraft-server) you can also find more configuration options for your container. Most
of the configuration can be done with environment variables. It is best to simply extend the `provision/ansible-variables.yml` file and add your variables as a `KEY=VALUE` pair.
Whitelisting is already present but commented out, as well as OP. Comment it in and your player name to make use of this feature.

## Usage

### Create the Server

It will took up to 5 Minutes! At the end you will be given an ip address which is the ip of your Minecraft server. Even than it is possible, that the docker container hast not fully
started yet.

```bash
$ terraform init
$ terraform apply
```

If you did not specify your token as environment variable or in a `.tfvars` file, then terraform will ask you for this token.

### Delete the Server

Your server backup ist stored in backup with the name of the variable `backup_name`. If you run again `terraform apply` than this backup will be restored, that you can start again
where you left off playing

```bash
$ terraform destroy
```

## Variables

### Terraform Variables

|  Name                    |  Default     |  Description                                                                      |
|:-------------------------|:-------------|:----------------------------------------------------------------------------------|
| `token`                  |              |API Token that will be generated through your hetzner cloud project https://console.hetzner.cloud/projects |
| `server_type`            | `cx31`       |Hetzner Server Type for more information visit https://www.hetzner.com/de/cloud |
| `location`            | `nbg1`            |Location of the Hetzner Server. Choose between `nbg1`, `fsn1` or `hel1` |
| `agent`               | `false`         | If you want to se the ssh-agent to provision your machine. If set to true, private_key must be commented out |
| `ssh_private_key`     | `~/.ssh/id_minecraft-server`     | Private Key to access the machines. Same value as `ansible_ssh_private_key_file` in Ansible Variables required! |
| `ssh_public_key`      | `~/.ssh/id_minecraft-server.pub` | Public Key to authorized the access for the machines |

All Terraform variables can be specified as environment variables or in a .tfvars file.

#### Example .tfvars file

```toml
# terraform.tfvars
hcloud_token = "<yourgeneratedtoken>"
server_type = "cx41"
location = "hel1"
```

### Ansible Variables

|  Name                    |  Default     |  Description                                                                      |
|:-------------------------|:-------------|:----------------------------------------------------------------------------------|
| `ansible_ssh_private_key_file` | `~/.ssh/id_minecraft-server` | Private Key to access the machines. Same value as `ssh_private_key` in Terraform Variables required! |
| `backup_name` | `deploy.tar.gz` | The name of your Backup stored in backup/. Every Terraform destroy a new one is created and the old backup overwritten |
| `docker_name` | `minecraft` | The name of the docker container used for the mineraft server |
| `docker_env` | `TZ=Europe/Berlin, EULA=TRUE` | The Environment variables passed to the docker container |
| `docker_port` | `25565:25565` | The docker container ports used to publish the server |

Ansible variables can be specified in `provision/ansible-variables.yml/`. You can add additional KEY=VALUE pairs to the `docker_env` variable.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/p4ck3t0/terraform-minecraft-hcloud/issues) to report any bugs or request a new feature.

### Gitlab <=> Github

This Repository is Mirrored from my private Gitlab.
Link to this project on [Github](https://github.com/p4ck3t0/terraform-minecraft-hcloud)
Link to this project on my private [Gitlab](https://gitlab.p4ck3t0.de/public-group/server/terrform-minecraft-hcloud)
