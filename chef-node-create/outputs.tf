output "chef-node-public-IP" {
  value = "${aws_instance.chef.*.public_dns}"
}

output "node-sg-id" {
  value = "${aws_security_group.instance.*.id}"
}
