# F5 Deployment with Terraform and Ansible in AWS

Here you will have access to different deployment leveraging Ansible and Terraform.

the *terraform_module* directory contains modules that are re-used between the different deployment: vpc creation, deploy F5 BIG-IP standalone, deploy ubuntu, ...

* make sure you set the GOOGLE_CREDENTIALS environment variable to point to your GCP service account key (JSON file) in the host running terraform. 
* if using the tkam8/tfansible container on docker hub, make sure that you mount your GCP credentials (JSON file) to /tmp/gcp_creds.json on the container. Terraform is configured to look here for GCP credentials via the GOOGLE_CREDENTIALS environment variable set in the dockerfile of the tfansible container. 