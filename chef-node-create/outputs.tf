output "chef-node-public-IP" {
  value = "${aws_instance.chef.*.public_dns}"
}
