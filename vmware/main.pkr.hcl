
packer {
  required_version = ">= 1.9.0"
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type    = string
  default = "packer"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
}


source "vmware-iso" "basic-example" {
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  shutdown_command = "shutdown -P now"

  vm_name       = "vm-01"
  // guest_os_type = "ubuntu64Guest"
  version       = "16"
  headless      = false
  // Virtual Hardware Specs
  memory        = 2048
  cpus          = 2
  cores         = 2
  disk_size     = 20000
  sound         = false
  disk_type_id  = 0

  iso_target_path   = "./iso"
  output_directory  = "./vm"
  // snapshot_name     = "clean"

  boot_wait        = "5s"

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]

  // boot_command     = [
  //   "<esc><wait>",
  //   "<enter><wait>",
  //   "/install/vmlinuz",
  //   " auto",
  //   " console-setup/ask_detect=false",
  //   " console-setup/layoutcode=us",
  //   " console-setup/modelcode=pc105",
  //   " debconf/frontend=noninteractive",
  //   " debian-installer=en_US",
  //   " fb=false",
  //   " initrd=/install/initrd.gz",
  //   " kbd-chooser/method=us",
  //   " keyboard-configuration/layout=USA",
  //   " keyboard-configuration/variant=USA",
  //   " locale=en_US",
  //   " netcfg/get_domain=vm",
  //   " netcfg/get_hostname=vagrant",
  //   " grub-installer/bootdev=/dev/sda",
  //   " noapic",
  //   " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
  //   " -- <enter>"
  // ]

  http_directory = "http"
  vnc_disable_password = true

}

build {
  sources = ["sources.vmware-iso.basic-example"]
}


source "vmware-iso" "jammy-daily" {

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]
}
