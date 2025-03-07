# variables.pkr.hcl

variable "github_token" {
  type    = string
  default = ""
}


variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "source_ami" {
  type    = string
   default = "ami-0884d2865dbe9de4b"
 
}

variable "ssh_username" {
  type    = string
   default = "ubuntu"
}

variable "mysql_sec_group" {
  type    = string
   default = "sg-0026fe067975f4936"
}


variable "subnet_id" {
  type    = string
   default = "subnet-077303a3470268153"
}

variable "instance_type" {
  type    = string
   default = "t2.micro"
}

variable "instance_volume_size" {
  type    = number
   default = 8
}

variable "instance_volume_type" {
  type    = string
   default = "gp2"
}


