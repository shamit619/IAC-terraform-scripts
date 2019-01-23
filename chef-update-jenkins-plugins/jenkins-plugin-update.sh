#!/bin/bash

cd /mnt/recovery/root/chef-node-create

terraform output chef-node-public-IP | awk -F',' '{print $1}' > /mnt/recovery/root/chef-update-jenkins-plugins/node-public-ip.txt
sed -i 's/o://g' /mnt/recovery/root/chef-update-jenkins-plugins/node-public-ip.txt
cat /mnt/recovery/root/chef-update-jenkins-plugins/node-public-ip.txt
for public_ip in $(cat /mnt/recovery/root/chef-update-jenkins-plugins/node-public-ip.txt);
do
echo $public_ip
cd /mnt/recovery/root/chef-update-jenkins-plugins
wget http://$public_ip:18080/jnlpJars/jenkins-cli.jar
UPDATE_LIST=$( java -jar /mnt/recovery/root/chef-update-jenkins-plugins/jenkins-cli.jar -auth jenkins.user1:jenkins123 -s http://$public_ip:18080/ list-plugins | grep -e ')$' | awk '{ print $1 }' ); 
if [ ! -z "${UPDATE_LIST}" ]; then 
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    java -jar /mnt/recovery/root/chef-update-jenkins-plugins/jenkins-cli.jar -auth jenkins.user1:jenkins123 -s http://$public_ip:18080/ install-plugin ${UPDATE_LIST};
    java -jar /mnt/recovery/root/chef-update-jenkins-plugins/jenkins-cli.jar -auth jenkins.user1:jenkins123 -s http://$public_ip:18080/ safe-restart;
fi
rm -rf /mnt/recovery/root/chef-update-jenkins-plugins/jenkins-cli.jar
done
rm -rf /mnt/recovery/root/chef-update-jenkins-plugins/node-public-ip.txt
