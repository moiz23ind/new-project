terraform {
backend "s3" {
  bucket = "my-store1"
  key    = "key/terraform.tfstate"
  region = "us-east-1"
}
}


# Configure the AWS Provider

  


resource "aws_instance" "web" {

  instance_type          = "t2.micro"
  key_name               = "aws46-laptop"
  ami  			= "ami-067d1e60475437da2"
  monitoring             = true
  vpc_security_group_ids = ["sg-0e511317440c98a0d"]
  subnet_id              = "subnet-03092947a677264f6"
  tags = {
  Name = "devloper2-my testing"
}

}