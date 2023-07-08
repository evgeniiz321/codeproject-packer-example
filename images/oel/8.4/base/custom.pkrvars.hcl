iso_url = "https://yum.oracle.com/ISOS/OracleLinux/OL8/u4/x86_64/x86_64-boot.iso"
iso_checksum = "b92b49553690420053b32dff54c7cce89463eb98c35a1b57706b7408a2ec24bc"
name = "oel-8.4-base"
disk_size = "16G"
playbook = "oel/8.4/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/oel/8.4/base/ks.cfg<enter><wait>"]
