# A name prefix used in resource names to ensure uniqueness across a project
name_prefix = "terrytest1"

# The name of the GCP Project where all resources will be launched
project = "f5-gcs-4261-sales-apcj-japan"

# GCP Region to use
region = "asia-northeast1"

# The zone to create the F5 in. Must be within the subnetwork region
zone = "asia-northeast1-b"

# Public IPs used to access your instances
allowed_networks = ["210.226.41.0/24"]

# The machine type of the F5 instance
f5_instance_type = "n1-standard-4"

# The machine type of the NGINX instance
nginx_instance_type = "f1-micro"

# The machine type of the gke cluster
gke_instance_type = "n1-standard-1"

# # The username for gke basic auth
# gke_username = ${gke_user}

# # The password for gke basic auth
# gke_password = ${gke_pass}