iso_url = "base_image"
iso_checksum = "none"
disk_image = true
name = "ubuntu-22.04-jenkins-agent"
disk_size = "64G"
playbook = "ubuntu/22.04/jenkins-agent/provision.yml"
deploy_image_params = "cloud -bc base_cloud_config.json"
