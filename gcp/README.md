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

e.g. 

```sh
gcp_sa_key_json: |
  {
    "type": "service_account",
    "project_id": "my-sample-project",
    "private_key_id": "XXXX",
    "private_key": "-----BEGIN PRIVATE KEY-----\nREDACTED-PRIVATE-KEY-DATA\n-----END PRIVATE KEY-----\n",
    "client_email": "my-service-account@my-sample-project.iam.gserviceaccount.com",
    "client_id": "XXXX",
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

we encountered the below error when trying to deploy our bucket. The bucket name - `yemanenigusseresume.org` is the same as our domain and the ownership had to verified for it to pass as a bucket name. 

Follwed the verification link seen on the error message and then added a user with `owner` permission and then added the email ID of our  service account created in gcp inside the settings with in the google search console. 

> 
```text
[ERROR]: Task failed: Module failed: 
  Error: googleapi: Error 403: Another user owns the domain yemanenigusseresume.org or a parent domain. You can either verify domain ownership at https://search.google.com/search-console/welcome?new_domain_name=yemanenigusseresume.org or find the current owner and ask that person to create the bucket for you, forbidden

    with google_storage_bucket.static-site,
    on main.tf line 6, in resource "google_storage_bucket" "static-site":
    6: resource "google_storage_bucket" "static-site" {
  Origin: /workspaces/cloud-resume-challenge/gcp/playbooks/deploy.yml:31:7

  29         mode: '0600'
  30
  31     - name: Terraform init/plan/apply
          ^ column 7

  fatal: [localhost]: FAILED! => {"changed": false, "cmd": "/usr/bin/terraform apply -no-color -input=false -auto-approve -lock=true /tmp/tmpgl_2oplq.tfplan", "msg": "\nError: googleapi: Error 403: Another user owns the domain yemanenigusseresume.org or a parent domain. You can either verify domain ownership at https://search.google.com/search-console/welcome?new_domain_name=yemanenigusseresume.org or find the current owner and ask that person to create the bucket for you, forbidden\n\n  with google_storage_bucket.static-site,\n  on main.tf line 6, in resource \"google_storage_bucket\" \"static-site\":\n   6: resource \"google_storage_bucket\" \"static-site\" {", "rc": 1, "stderr": "\nError: googleapi: Error 403: Another user owns the domain yemanenigusseresume.org or a parent domain. You can either verify domain ownership at https://search.google.com/search-console/welcome?new_domain_name=yemanenigusseresume.org or find the current owner and ask that person to create the bucket for you, forbidden\n\n  with google_storage_bucket.static-site,\n  on main.tf line 6, in resource \"google_storage_bucket\" \"static-site\":\n   6: resource \"google_storage_bucket\" \"static-site\" {\n\n", "stderr_lines": ["", "Error: googleapi: Error 403: Another user owns the domain yemanenigusseresume.org or a parent domain. You can either verify domain ownership at https://search.google.com/search-console/welcome?new_domain_name=yemanenigusseresume.org or find the current owner and ask that person to create the bucket for you, forbidden", "", "  with google_storage_bucket.static-site,", "  on main.tf line 6, in resource \"google_storage_bucket\" \"static-site\":", "   6: resource \"google_storage_bucket\" \"static-site\" {", ""], "stdout": "google_storage_bucket.static-site: Creating...\n", "stdout_lines": ["google_storage_bucket.static-site: Creating..."]}
```

### Install gcloud 

```sh
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli
```

## Considerations for CDN 

GCP requires you to run a Global External Load Balancer and it appears to be more expensive than other provider. 
Even though using Cloud CDN would demonstrate GCP knowledge, we will implement a more cost effective solution. 

> If you have only a single domain/site and low traffic, the fixed cost (~US $18/month) could dominate. 

$18 for a personal website that just have CDN is not worth it. We'll attempt to use CloudFlare instead. 