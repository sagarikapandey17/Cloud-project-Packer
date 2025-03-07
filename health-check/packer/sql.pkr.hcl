packer {
  required_plugins {
    amazon = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "mysql" {
  region                 = var.aws_region
  instance_type          = var.instance_type
  source_ami             = var.source_ami
  subnet_id              = var.subnet_id
  ami_name               = "mysql-ami-{{timestamp}}"
  ami_description        = "MySQL custom AMI with MySQL preinstalled"
  ssh_username           = var.ssh_username
  associate_public_ip_address = true

  launch_block_device_mappings {
    device_name           = "/dev/xvdg"
    volume_size           = var.instance_volume_size
    volume_type           = var.instance_volume_type
    delete_on_termination = true
  }

  tags = {
    Name  = "mysql-ami"
    Owner = "Sagarika"
  }

  aws_polling {
    delay_seconds = 120
    max_attempts  = 50
  }
}

build {
  sources = ["source.amazon-ebs.mysql"]

  # Copy SQL setup and import scripts
  provisioner "file" {
    source      = "./packer/sql_setup.sh"
    destination = "/tmp/sql_setup.sh"
  }

  provisioner "file" {
    source      = "./packer/import_data.sh"
    destination = "/tmp/import_data.sh"
  }

  # Copy dataset files
  provisioner "file" {
    source      = "./genre.csv"
    destination = "/tmp/genre.csv"
  }

  provisioner "file" {
    source      = "./movies.csv"
    destination = "/tmp/movies.csv"
  }

  provisioner "file" {
    source      = "./movie_genre.csv"
    destination = "/tmp/movie_genre.csv"
  }

  provisioner "file" {
    source      = "./ratings.csv"
    destination = "/tmp/ratings.csv"
  }

  provisioner "file" {
    source      = "./tags.csv"
    destination = "/tmp/tags.csv"
  }

  provisioner "file" {
    source      = "./links.csv"
    destination = "/tmp/links.csv"
  }

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y mysql-server",
      "sudo systemctl start mysql",
      "sudo systemctl enable mysql",

      # Modify MySQL config 
      "sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf",
      "echo '[mysqld]' | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf",
      "echo 'secure-file-priv=' | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf",
      "sudo systemctl restart mysql",

      # Move data files 
      "sudo mkdir -p /opt/mysql_data",
      "sudo chmod 755 /opt/mysql_data",
      "sudo chown mysql:mysql /opt/mysql_data",
      "sudo mv /tmp/movies.csv /opt/mysql_data/movies.csv",
      "sudo mv /tmp/genre.csv /opt/mysql_data/genre.csv",
      "sudo mv /tmp/movie_genre.csv /opt/mysql_data/movie_genre.csv",
      "sudo mv /tmp/tags.csv /opt/mysql_data/tags.csv",
      "sudo mv /tmp/links.csv /opt/mysql_data/links.csv",
      "sudo mv /tmp/ratings.csv /opt/mysql_data/ratings.csv",

      # Move and execute SQL setup script
      "sudo mv /tmp/sql_setup.sh /opt/sql_setup.sh",
      "sudo chmod +x /opt/sql_setup.sh",
      "sudo bash /opt/sql_setup.sh",

      # Move and execute import script
      "sudo mv /tmp/import_data.sh /opt/import_data.sh",
      "sudo chmod +x /opt/import_data.sh",
      "sudo bash /opt/import_data.sh"
    ]
  }
}
