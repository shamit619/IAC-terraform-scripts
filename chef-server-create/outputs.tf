output "chef-server-public-IP" {
  value = "${aws_instance.chef.public_dns}"
}

output "chef-server-private-IP" {
  value = "${aws_instance.chef.private_dns}"
}
