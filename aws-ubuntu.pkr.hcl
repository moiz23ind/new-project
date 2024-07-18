packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}
# Variables
# variable "aws_access_key" {
#   type = string
# }

# variable "aws_secret_key" {
#   type = string
# }

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Sources (Builders)
source "amazon-ebs" "demo" {
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  region     = "us-east-1"
  source_ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  vpc_id = "vpc-01d1dce7846534cf8"
  subnet_id = "subnet-0f5e505706a7cd0ae"
  ssh_username = "ubuntu"
  ami_name = "packer-demo-ami-${local.timestamp}"
}

# Builds
build {
  sources = [
    "source.amazon-ebs.demo",
  ]

  # Provisioners
  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo sed -i 's/#Port\s22/Port 8000/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd.service",
      "sudo apt-get install -y nginx",
      "sudo echo "<div><h1>$(cat /etc/hostname)</h1></div>" >> /var/www/html/index.html"
    ]
  }

  # Post-processors
  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
  }
}
