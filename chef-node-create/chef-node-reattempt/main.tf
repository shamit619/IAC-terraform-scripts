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
  #sg_id = "${output.node-sg-idi}"
  vpc_security_group_ids = ["${var.node-sg-id}"]
  #vpc_security_group_ids = ["${var.node-reattempt == "n" ? aws_security_group.instance.id : "sg-077f689c9801f153f"}"]
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
