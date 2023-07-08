iso_url = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.6-x86_64-boot.iso"
iso_checksum = "fe77cc293a2f2fe6ddbf5d4bc2b5c820024869bc7ea274c9e55416d215db0cc5"
name = "rockylinux-8.6-base"
disk_size = "24G"
playbook = "rockylinux/8.6/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux/8.6/base/ks.cfg<enter><wait>"]
