iso_url = "https://vault.centos.org/8.5.2111/isos/x86_64/CentOS-8.5.2111-x86_64-boot.iso"
iso_checksum = "9602c69c52d93f51295c0199af395ca0edbe35e36506e32b8e749ce6c8f5b60a"
name = "centos-8.5-base"
disk_size = "16G"
playbook = "centos/8.5/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos/8.5/base/ks.cfg<enter><wait>"]
