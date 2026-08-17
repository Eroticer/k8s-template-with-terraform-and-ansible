[all:vars]
ansible_user=root
ansible_ssh_private_key_file=~/.ssh/id_ed25519
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'


[master]#Полученые адреса и терра 
%{ for ip in master_ips ~}
${ip}
%{ endfor ~}

[workers]#Полученые адреса и терра 
%{ for ip in worker_ips ~}
${ip}
%{ endfor ~}

[kubernetes:children]
master
workers