iso_url = "http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/20101020ubuntu614/legacy-images/netboot/mini.iso"
iso_checksum = "0e79e00bf844929d40825b1f0e8634415cda195ba23bae0b041911fde4dfe018"
name = "ubuntu-20.04-base"
disk_size = "16G"
playbook = "ubuntu/20.04/base/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
boot_command = [
        "<esc><wait>",
        "linux auto<wait>",
        " console-setup/ask_detect=false<wait>",
        " console-setup/layoutcode=us<wait>",
        " console-setup/modelcode=pc105<wait>",
        " debconf/frontend=noninteractive<wait>",
        " debian-installer=en_US<wait>",
        " fb=false<wait>",
        " initrd=initrd.gz<wait>",
        " kbd-chooser/method=us<wait>",
        " keyboard-configuration/layout=USA<wait>",
        " keyboard-configuration/variant=USA<wait>",
        " locale=en_US<wait>",
        " netcfg/get_domain=vm<wait>",
        " netcfg/get_hostname=ubuntu-20.04<wait>",
        " grub-installer/bootdev=/dev/sda<wait>",
        " noapic<wait>",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/18.04/base/preseed.cfg<wait>",
        " -- <wait>",
        "<enter><wait>"
      ]
