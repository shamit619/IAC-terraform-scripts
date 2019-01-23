#!/bin/bash

cookbook_name=$1
cd /mnt/recovery/root/chef-cookbooks
rm -rf IAC_Cookbooks
git clone https://github.com/shamit619/IAC_Cookbooks.git
if [[ "$cookbook_name" == "jenkins-demo" ]];
then
echo "hi"
cd /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/jenkins-demo/cookbooks/jenkins-demo
berks install
berks upload
knife cookbook upload --force --cookbook-path /mnt/recovery/root/chef-cookbooks/cookbooks -a
fi

knife cookbook upload --force --cookbook-path /mnt/recovery/root/chef-cookbooks/IAC_Cookbooks/$cookbook_name/cookbooks -a

