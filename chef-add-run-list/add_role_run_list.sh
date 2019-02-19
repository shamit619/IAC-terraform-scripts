#!/bin/bash
recipe_name=$1
server_name=$2
#recipe_name2=$3

#knife role from file /mnt/recovery/root/chef-add-run-list/roles/chef-client-interval.json

knife node list > /mnt/recovery/root/chef-add-run-list/node_name.txt

#while read node
#do
#echo "attaching role"
#knife node run_list set $node "role[chef-client-interval]"
#done < /mnt/recovery/root/chef-add-run-list/node_name.txt

knife node list | grep "$server_name" > /mnt/recovery/root/chef-add-run-list/server_name.txt

while read server
do
echo "Uploading recipe"
knife node run_list add $server $recipe_name
done < /mnt/recovery/root/chef-add-run-list/server_name.txt

#rm -rf /mnt/recovery/root/chef-add-run-list/node_name.txt /mnt/recovery/root/chef-add-run-list/server_name.txt

#cd /mnt/recovery/root/chef-node-create

#terraform output chef-node-public-IP | awk -F',' '{print $1}' > /mnt/recovery/root/chef-add-run-list/node-public-ip.txt
#cat /mnt/recovery/root/chef-add-run-list/node-public-ip.txt
while read  node
do
echo $node
#knife ssh 'role:chef-client-interval' 'sudo chef-client' -x ubuntu -i ~/.ssh/terraform-cheff.pem -a $public_ip
knife ssh name:$node 'sudo chef-client' -x ubuntu -i ~/.ssh/chef-workstation.pem
done < /mnt/recovery/root/chef-add-run-list/node_name.txt

#rm -rf /mnt/recovery/root/chef-add-run-list/node-public-ip.txt

while read server
do
echo "Removing recipe"
knife node run_list remove $server "recipe[$recipe_name]"
done < /mnt/recovery/root/chef-add-run-list/server_name.txt

#while read public_ip
#do
#echo $public_ip
#knife ssh 'role:chef-client-interval' 'sudo chef-client' -x ubuntu -i ~/.ssh/terraform-cheff.pem -a $public_ip
#done < /mnt/recovery/root/chef-add-run-list/node-public-ip.txt

rm -rf /mnt/recovery/root/chef-add-run-list/node_name.txt /mnt/recovery/root/chef-add-run-list/server_name.txt /mnt/recovery/root/chef-add-run-list/node-public-ip.txt

