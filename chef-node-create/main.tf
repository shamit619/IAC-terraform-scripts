provider "aws" {
  region = "us-east-1"
}

#terraform {
#  backend "s3" {
#    region  = "ap-south-1"
#    bucket  = "shamit619"
#    key     = "terraform.tfstate"
#    encrypt = true
#  }
#}

resource "aws_instance" "chef" {
  #ami = "ami-0ff8a91507f77f867"
  ami = "ami-0f9cf087c1f27d9b1"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  count = "${var.node-count}"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get -y update
              sudo apt-get -y install awscli
              aws s3 cp s3://akhil510/chef-node.sh --region "us-east-1" .
              chmod 775 chef-node.sh
              ./chef-node.sh ${var.chef-server-ip} ${var.node-name}
              EOF

  tags {
    Name = "chef-node-${var.node-name}"
  }

  lifecycle {
    ignore_changes = ["user_data", "tags"]
  } 
  key_name = "chef-workstation"

  iam_instance_profile = "chef-workstation"
}

resource "aws_security_group" "instance" {
  name = "chef-security-node"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 18080
    to_port = 18080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

