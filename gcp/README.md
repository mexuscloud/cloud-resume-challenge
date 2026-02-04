## Install Terraform 

We are going to use Terraform for IaC with GCP because that is the recommanded way to implement IaC 
on GCP despite there being a Deployment Manager. We should be able to manage Terraform state file with 
Infrastructure Manager. 

```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
```

### Terraform and GCP Authentication 

In GCP we created a new service account and gave it Infrastructure Adminstrator which for now should be 
enough permissions to create the resources we want. 

We need to set the following env variable and this will allow Terraform to authenticate to GCP. 

```sh
export GOOGLE_APPLICATION_CREDENTIALS=/workspaces/cloud-resume-challenge/gcp/gcp-key.json
```

To persist this we should add to our `.bach_profile` or `.bashrc`

edit, reload our bach profile and confirm 
```sh
vi ~/.bashrc
source ~/.bashrc
env | grep GOOGLE
```

## Install Ansible 

```sh
pipx install --include-deps ansible 
```

## Setup Ansible Vault with GCP credentials

We'll need to store the contents of the gcp key in our vault. 

eg. 

```sh
gcp_sa_key_json: |
  {
    "type": "service_account",
    "project_id": "my-sample-project",
    "private_key_id": "1234567890abcdef1234567890abcdef12345678",
    "private_key": "-----BEGIN PRIVATE KEY-----\nREDACTED-PRIVATE-KEY-DATA\n-----END PRIVATE KEY-----\n",
    "client_email": "my-service-account@my-sample-project.iam.gserviceaccount.com",
    "client_id": "123456789012345678901",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-service-account%40my-sample-project.iam.gserviceaccount.com"
  }
```
Run the create command and add the gcp_sa_key_json content in the newly created prod.yml file. 

```sh
cd gcp 
ansible-vault create playbooks/vaults/prod.yml  
ansible-vault edit playbooks/vaults/prod.yml  
ansible-vault view playbooks/vaults/prod.yml  
```


