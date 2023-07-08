iso_url = "http://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
iso_checksum = "84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"
name = "ubuntu-22.04-base"
disk_size = "64G"
playbook = "ubuntu/22.04/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = [
  "<esc><esc><esc><esc>e<wait>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "<del><del><del><del><del><del><del><del>",
  "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/22.04/base/preseed/\"<enter><wait>",
  "initrd /casper/initrd<enter><wait>",
  "boot<enter>",
  "<enter><f10><wait>"
]

