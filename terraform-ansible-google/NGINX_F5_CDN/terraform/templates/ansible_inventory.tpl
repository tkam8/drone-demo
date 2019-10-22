[gcp_nginx_systems]
${gcp_nginx_data}

[gke_systems]
${gcp_gke_endpoint}

[gke_name]
${gcp_gke_cluster_name}

[F5_systems]
#Must be in the form of <public IP> vs_ip=<private ip of the F5>


[gcp_nginx_systems:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=ubuntu
ansible_ssh_private_key_file=/tmp/gcp_key

[F5_systems:vars]
ansible_user=admin
