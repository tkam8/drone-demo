[gcp_nginx_systems]
${gcp_nginx_data}

[gke_systems]
${gcp_gke_endpoint}

[gke_name]
${gcp_gke_cluster_name}

#[F5_systems]
#Must be in the form of <public IP> vs_ip=<private ip of the F5>
#${gcp_F5_public_ip} vs_ip=${gcp_F5_private_ip}

[gcp_nginx_systems:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=ubuntu

[F5_systems:vars]
ansible_user=admin
