iso_url = "https://cdimage.debian.org/cdimage/archive/9.13.0/amd64/iso-cd/debian-9.13.0-amd64-netinst.iso"
iso_checksum = "71c7e9eb292acc880f84605b1ca2b997f25737fe0a43fc9586f61d35cd2eb43b"
name = "debian-stretch-base"
disk_size = "16G"
playbook = "debian/stretch/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = [
  "<esc><wait>install<wait>",
  " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian/stretch/base/preseed.cfg<wait>",
  " debian-installer=en_US<wait>",
  " auto<wait>",
  " locale=en_US<wait>",
  " kbd-chooser/method=us<wait>",
  " keyboard-configuration/xkb-keymap=us<wait>",
  " netcfg/get_hostname={{ .Name }}<wait>",
  " netcfg/get_domain=vagrantup.com<wait>",
  " fb=false<wait>",
  " debconf/frontend=noninteractive<wait>",
  " console-setup/ask_detect=false<wait>",
  " console-keymaps-at/keymap=us<wait>",
  " -- <wait>",
  "<enter><wait>"
]
