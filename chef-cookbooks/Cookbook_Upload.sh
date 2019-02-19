#!/bin/bash

cookbook_name=$1
cd /mnt/recovery/root/chef-cookbooks
rm -rf IAC_Cookbooks
git clone https://github.com/shamit619/IAC_Cookbooks.git
if [[ "$cookbook_name" == "jenkins-demo" ]];
then
echo "hi"
cd /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/jenkins-demo-latest/cookbooks/jenkins-demo
berks install
berks upload
knife cookbook upload --force --cookbook-path /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/jenkins-demo-latest/cookbooks -a
elif [[ "$cookbook_name" == "grafana" ]];
cd 
berks install
berks upload
elif [[ "$cookbook_name" == "influxdb" ]];
berks install
berks upload
else
knife cookbook upload --force --cookbook-path /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/$cookbook_name/cookbooks -a
fi


