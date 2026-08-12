[all:vars]
ansible_user=root
ansible_ssh_private_key_file=~/.ssh/id_ed25519

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