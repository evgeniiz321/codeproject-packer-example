
variable "iso_checksum" {
  type    = string
  default = ""
}

variable "iso_url" {
  type    = string
  default = ""
}

variable "boot_command" {
  type    = list(string)
  default = [""]
}

variable "name" {
  type    = string
  default = ""
}

variable "cpus" {
  type    = string
  default = "30"
}

variable "memory" {
  type    = string
  default = "8192"
}

variable "datastore" {
  type    = string
  default = "108"
}

variable "disk_size" {
  type    = string
  default = "12G"
}

variable "disk_image" {
  type    = bool
  default = false
}

variable "deploy_image_params" {
  type    = string
  default = ""
}

variable "playbook" {
  type = string
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "ONE_ACCESS_TOKEN" {
  type    = string
  default = "${env("ONE_ACCESS_TOKEN")}"
}

variable "ONE_RPC_URI" {
  type    = string
  default = "${env("ONE_RPC_URI")}"
}

variable "ONE_USER" {
  type    = string
  default = "${env("ONE_USER")}"
}

source "qemu" "qemu_source" {
  boot_command     = var.boot_command
  boot_wait        = "10s"
  disk_discard     = "unmap"
  disk_interface   = "virtio-scsi"
  disk_size        = var.disk_size
  disk_image       = var.disk_image
  format           = "qcow2"
  http_directory   = "${path.root}"
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  output_directory = "${path.root}/output/${var.name}"
  shutdown_command = "echo 'ChangeMe'|sudo -S /sbin/halt -h -p"
  ssh_handshake_attempts = 1000
  ssh_password     = "ChangeMe"
  ssh_port         = 22
  ssh_username     = "my-fav-username"
  ssh_wait_timeout = "10000s"
  net_device       = "virtio-net"
  vm_name          = "${var.name}.qcow2"
  cpus             = var.cpus
  accelerator      = "kvm"
  disk_compression = true
  headless         = true
  vnc_bind_address = "0.0.0.0"
  qemuargs = [[ "-cpu", "host" ]]
  memory           = var.memory
}

build {
  sources = ["source.qemu.qemu_source"]

  provisioner "ansible-local" {
    extra_arguments = [
      "--extra-vars", "ansible_become_pass=ChangeMe"
    ]
    playbook_file   = "${path.root}/${var.playbook}"
    playbook_dir = "${path.root}/ansible"
  }

  post-processor "shell-local" {
    environment_vars = [
      "EXEC_DIR=${path.root}/post-processors",
      "IMAGE=${path.root}/output/${var.name}/${var.name}.qcow2",
      "DEPLOY_IMAGE_PARAMS=${var.deploy_image_params}",
      "AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY_ID}",
      "AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_ACCESS_KEY}",
      "ONE_RPC_URI=${var.ONE_RPC_URI}",
      "ONE_USER=${var.ONE_USER}",
      "ONE_ACCESS_TOKEN=${var.ONE_ACCESS_TOKEN}"
    ]
    execute_command  = ["/bin/bash", "-c", "{{ .Vars }} {{.Script}}"]
    inline           = [
      "$EXEC_DIR/deploy-image.py -i $IMAGE $DEPLOY_IMAGE_PARAMS"
    ]
    name             = "cloud_deploy"
  }
}
