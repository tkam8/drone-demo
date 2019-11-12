/* import shared library */
// @Library('jenkins-shared-library')_

pipeline {
    agent {
        docker {
            image 'tkam8/tfansible:latest'
             //Mount the below items for use by Ansible and Terraform
	         //gcp service account creds in json format
	         //metadata ssh key for compute instance access via ssh
	         //BYOCDN repo details in json format
	         //pre-generated ansible vault file
            args '--entrypoint= -v /home/ubuntu/gcp/gcp_creds.json:/tmp/gcp_creds.json -v /home/ubuntu/gcp/gcp_ssh_key:/tmp/gcp_ssh_key -v /home/ubuntu/gcp/byocdn_user_repo.json:/tmp/user_repo.json -v /home/ubuntu/gcp/f5_gke_vault:/home/tfansible/NGINX-F5-CDN/terraform-ansible-google/NGINX_F5_CDN/ansible/playbooks/group_vars/F5_systems/f5_gke_vault'
        }
    }
    stages {
        stage('Init') {
            steps {
                echo 'Initializing!!'
            }
        }
        stage('Initializing terraform') {
            steps {
                dir("NGINX-F5-CDN/terraform-ansible-google/NGINX_F5_CDN/terraform") {
                    echo 'Running Terraform init'
                    //Below echo commands for debug purposes
                    echo "sh pwd"
                    echo "PATH : ${env.PATH}"
                    //Run init in non-interactive mode to load all required modules
                    sh 'terraform init -input=false'
                }
            }
        }
        stage('Applying terraform') {
            steps {
                //Terraform will use credentials from the GOOGLE_CREDENTIALS env var
                dir("NGINX-F5-CDN/terraform-ansible-google/NGINX_F5_CDN/terraform") {
                        echo 'Running Terraform apply'
                        sh 'terraform apply -input=false -auto-approve'
                     //   sh 'terraform destroy -force'
                }
            }
        }
        stage('Ansible Playbook1') {
            steps {
                echo 'Running ansible playbook plugin verbose'
                ansiblePlaybook(
                    playbook: 'NGINX-F5-CDN/terraform-ansible-google/NGINX_F5_CDN/ansible/playbooks/site.yml',
                    inventory: 'NGINX-F5-CDN/terraform-ansible-google/NGINX_F5_CDN/ansible/playbooks/inventory/hosts',
                    //You must configure vault creentials in Jenkins
                    vaultCredentialsId: 'ansiblevaultpasswd',
                    extras: '-vv'
                )
            }
        }
    }
    // post {
    //     success {
    //         slackSend (color: '#00FF00', message: "SUCCESS! _Grab a beer_: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    //     }
    //     failure {
    //         slackSend (color: '#FF0000', message: "FAILED! _Practice makes perfect_: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})") 
    //     }
    // }
}

