#!/bin/bash

help() {
  echo -e "  - [ nixos-infect-cloud ] -\n\n  -y, --yandex             use yandex cloud[ !NOT IMPLEMENTED! ]\n  -v, --vk                 use vk cloud\n  -h, --help               output help menu\n  -dy, --destroyyandex     destroy yandex infra\n  -dv, --destroyvk	   destroy vk infra"
  exit
}

if [ $# -eq 0 ]
  then
    help
fi

if [ $1 == "--yandex" ] || [ $1 == "-y" ]; then
  export YC_TOKEN=$(yc iam create-token)
  export YC_CLOUD_ID=$(yc config get cloud-id)
  export YC_FOLDER_ID=$(yc config get folder-id)
  ip=$(cd ./terraform-yandex-cloud && terraform init && terraform fmt && terraform validate && terraform plan && terraform apply -auto-approve | tee /dev/tty)
  global_ip=$(echo "$ip" | tail -2 | cut -d' ' -f3 | head -n -1)
  global_ip="${global_ip:1:-1}"
  sed -i -E "s/((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])/$global_ip/" ./ansible/hosts.ini
  echo "Pseudo loading to wait when the infra is set up"
  (cd ansible && ansible-playbook ./playbooks/ab/main.yml)
elif [ $1 == "--vk" ] || [ $1 == "-v" ]; then
  ip=$(cd ./terraform/terraform-vk-cloud && terraform init && terraform fmt && terraform validate && terraform plan && terraform apply -auto-approve | tee /dev/tty)
  global_ip=$(echo "$ip" | tail -1 | cut -d' ' -f3)
  #zsh specific
  global_ip="$global_ip" | cut -c2- | rev | cut -c2- | rev
  #macOS specific
  sed -i '' -E "s/((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])/$global_ip/" ./ansible/hosts

  (cd ansible && ansible-playbook -i hosts install.yml)
elif [ $1 == "--help" ] || [ $1 == "-h" ]; then
  help
elif [ $1 == "--destroyyandex" ] || [ $1 == "-dy" ]; then
  (cd ./terraform-yandex-cloud && terraform destroy -auto-approve)
elif [ $1 == "--destroyvk" ] || [ $1 == "-dv" ]; then
  (cd ./terraform/terraform-vk-cloud && terraform destroy -auto-approve)
else
  help
fi

#ansible-playbook playbooks/ab/main.yml
