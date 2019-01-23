provider "aws" {
  region = "us-east-1"
}

#terraform {
#  backend "s3" {
#    region  = "ap-south-1"
#    bucket  = "shamit619"
#    key     = "server.tfstate"
#    encrypt = true
#  }
#}

resource "aws_instance" "chef" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              #Adding hostname in hosts file
              sudo echo "127.0.0.1 AWSVC009 AWSVC009" >> /etc/hosts
              
              #Downloading and Installing chef server
              sudo yum update -y
              sudo wget -nv https://packages.chef.io/stable/el/5/chef-server-core-12.6.0-1.el5.x86_64.rpm
              sudo rpm -Uvh chef-server-core-12.6.0-1.el5.x86_64.rpm
              sudo chef-server-ctl reconfigure
              
              #Configuring chef server
              sudo mkdir /root/.chef/
              sudo chef-server-ctl user-create admin admin admin admin@bogotobogo.com password -f ~/.chef/admin.pem
              sudo chef-server-ctl org-create infosys "infosys.com" --association_user admin -f ~/.chef/infosys.pem
              
              #Configuring and Installing chef manage for UI
              sudo wget -nv https://packages.chef.io/files/stable/chef-manage/2.4.5/el/7/chef-manage-2.4.5-1.el7.x86_64.rpm
              sudo rpm -Uvh chef-manage-2.4.5-1.el7.x86_64.rpm
              sudo chef-manage-ctl reconfigure --accept-license
              
              echo "Your Chef server is ready!"
              aws s3 cp ~/.chef/infosys.pem s3://shamit619
              EOF

  tags {
    Name = "chef server"
  }
  key_name = "terraform-cheff"
  
  iam_instance_profile = "S3-Admin-Access"
}

resource "aws_security_group" "instance" {
  name = "chef-security"

  # Inbound HTTP from anywhere
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
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
