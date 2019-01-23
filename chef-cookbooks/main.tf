resource "null_resource" "example1" {
  triggers {
    cookbook_name = "${timestamp()}"
  }
  #cookbook_name = "${var.cookbook}"
  provisioner "local-exec" {
    #command = <<-EOF
    #          #!/bin/bash
    #          cd /mnt/recovery/root/chef-cookbooks
    #          rm -rf IAC_Cookbooks
    #          git clone https://github.com/shamit619/IAC_Cookbooks.git
    #          knife cookbook upload --force --cookbook-path /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/${var.cookbook}/cookbooks -a
    #          EOF
    command = "sh /mnt/recovery/root/chef-cookbooks/Cookbook_Upload.sh ${var.cookbook}"
  }
}
