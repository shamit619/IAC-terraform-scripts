resource "null_resource" "example1" {
  triggers {
    timestamp = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "sh /mnt/recovery/root/chef-add-run-list/add_role_run_list.sh ${var.recipe-name} ${var.server-name}"
  }
}
