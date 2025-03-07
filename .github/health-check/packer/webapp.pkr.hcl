source "amazon-ebs" "webapp" {
  region                     = var.aws_region 
  instance_type              = var.instance_type
  ssh_username               = var.ssh_username
  subnet_id                  = var.subnet_id
  associate_public_ip_address = true
  source_ami                 = var.source_ami
  ami_name                   = "webapp-ami-${formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())}"
  
  launch_block_device_mappings {
    device_name            = "/dev/xvdh"
    volume_size            = var.instance_volume_size
    volume_type            = var.instance_volume_type
  }

  aws_polling {
    delay_seconds = 120
    max_attempts  = 50
  }
}

build {
  sources = ["source.amazon-ebs.webapp"]
  provisioner "file" {
    source      = "./packer/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    source      = "./packer/health-check.service"
    destination = "/tmp/health-check.service"
  }
  provisioner "shell" {
    inline = [
      "export SECRET_TOKEN=${var.github_token}",
      "chmod +x /tmp/deploy.sh",      
      "/tmp/deploy.sh"  
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-17-jre authbind mysql-client",
      "sudo touch /etc/authbind/byport/80",
      "sudo chown ubuntu /etc/authbind/byport/80",
      "sudo chmod 500 /etc/authbind/byport/80",
      "sudo cp /tmp/health-check.service /etc/systemd/system/health-check.service",
      "sudo systemctl daemon-reload",
    ]
  }
}
