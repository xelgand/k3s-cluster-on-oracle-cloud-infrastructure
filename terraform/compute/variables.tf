variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "cluster_subnet_id" {
  description = "Subnet for the bastion instance"
  type        = string
}

variable "permit_ssh_nsg_id" {
  description = "NSG to permit SSH"
  type        = string
}

variable "ssh_authorized_keys" {
  description = "List of authorized SSH keys"
  type        = list(any)
}

variable "master_1_user_data" {
  description = "Commands to be ran at boot for the bastion instance. Default installs Kali headless"
  type        = string
  default     = <<EOT
#!/bin/sh
sudo apt-get update
EOT
}

variable "master_2_user_data" {
  description = "Commands to be ran at boot for the bastion instance. Default installs Kali headless"
  type        = string
  default     = <<EOT
#!/bin/sh
sudo apt-get update
EOT
}

variable "worker_user_data" {
  description = "Commands to be ran at boot for the bastion instance. Default installs Kali headless"
  type        = string
  default     = <<EOT
#!/bin/sh
sudo apt-get update
EOT
}

variable "ubuntu_image_ocid" {
  // https://docs.oracle.com/en-us/iaas/images/ubuntu-2204/
  description = "OCID of the Ubuntu image for your region"
  type        = string
  // Canonical-Ubuntu-22.04-aarch64-2022.06.16-0
  default = "ocid1.image.oc1.eu-marseille-1.aaaaaaaaladulvn5fa42vbtqrszvs2javuye4w2k4c72y5wfqfz666gqalzq"
}

locals {
  server_instance_config = {
    shape_id    = "VM.Standard.A1.Flex"
    ocpus       = 2
    ram         = 12
    source_id   = var.ubuntu_image_ocid
    source_type = "image"
    server_ip_1 = "10.0.0.11"
    server_ip_2 = "10.0.0.12"
    // release: v0.21.5-k3s2r1
    k3os_image = "https://github.com/rancher/k3os/releases/download/v0.21.5-k3s2r1/k3os-arm64.iso"
    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
  worker_instance_config = {
    shape_id    = "VM.Standard.E2.1.Micro"
    ocpus       = 1
    ram         = 1
    source_id   = var.ubuntu_image_ocid
    source_type = "image"
    worker_ip_0 = "10.0.0.21"
    worker_ip_1 = "10.0.0.22"
    // release: v0.21.5-k3s2r1
    k3os_image = "https://github.com/rancher/k3os/releases/download/v0.21.5-k3s2r1/k3os-amd64.iso"
    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
  }
}
