resource "null_resource" "example1" {
  triggers {
    timestamp = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "sh /mnt/recovery/root/chef-update-jenkins-plugins/jenkins-plugin-update.sh"
  }
}
