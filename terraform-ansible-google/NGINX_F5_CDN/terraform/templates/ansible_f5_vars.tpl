---

ADMIN_PASSWORD: "{{ VAULT_ADMIN_PASSWORD }}"
ADMIN_HTTPS_PORT: "8443"
ADMIN_USER: "admin"
APP_TAG_KEY: "Application"
APP_TAG_VALUE: "${gcp_tag_value}"
K8S_AUTH_USERNAME: "{{ admin }}"
K8S_AUTH_PASSWORD: "{{ VAULT_GKE_ADMIN_PASSWORD }}"
LIST_AS3_POOL_SERVERS: "['${gcp_f5_pool_members}']"
