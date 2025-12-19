## Using CloudFormation 

We have multiple options for IaC: 
- CloudFormation 
- CDK 
- Terraform 

We are going to use CloudFormation because it is very simple to use in respect to our project. 

## Install Ansible 

```sh
pip install boto3 botocore
pipx install --include-deps ansible 
ansible-galaxy collection install amazon.aws

```

## Edit Vault 

We are going to store all of our configuration in a vault. 
We don't have to but just for learning we'll use a vault even for non-sensetive information. 

```sh
cd aws 
ansible-vault create playbooks/vaults/prod.yml  
ansible-vault edit playbooks/vaults/prod.yml  
ansible-vault view playbooks/vaults/prod.yml  
```

This is an encrypted file and we can safly push it to our repo. 

## Consideration with boto3

When trying to deploy the CloudFormation template, i had complaints about boto3 not being installed despite running 
'pip install boto3'. 

It looks as though ansible creates their own Python virtual environment

> DEPRECATION WARNING]: Param 'template' is deprecated. See the module docs for more information. This feature will be removed from collection 'amazon.aws' in a release after 2026-05-01.
[ERROR]: Task failed: Module failed: Failed to import the required Python library (botocore and boto3) on codespaces-b5331c's Python /usr/local/py-utils/venvs/ansible/bin/python. Please read the module documentation and install it in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter
Origin: /workspaces/cloud-resume-challenge/aws/playbooks/deploy.yml:14:7

12     - vaults/prod.yml
13   tasks:
14     - name: Deploy/Update stack
         ^ column 7

fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to import the required Python library (botocore and boto3) on codespaces-b5331c's Python /usr/local/py-utils/venvs/ansible/bin/python. Please read the module documentation and install it in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter"}

We'll attempt to install directly against the ansible venv and see if that resolves the issue. 

```sh 
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade pip
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade botocore boto3
```

## Install dependencies for Ansible 

```sh
ansible-galaxy collection install -r requirements.txt
```

## Installing cfn lint 

```sh
pip install cfn-lint
cfn-lint template.yaml
```

## Redirect consideration

our yemanenigusseresume.com is'nt redirecting to www.yemanenigusseresume.com 

First i used the below command to check the status. 

```sh
curl -I yemanenigusseresume.com
curl -I www.yemanenigusseresume.com
```

```code 
HTTP/1.1 301 Moved Permanently
Server: CloudFront
Date: Thu, 18 Dec 2025 19:06:57 GMT
Content-Type: text/html
Content-Length: 167
Connection: keep-alive
Location: https://yemanenigusseresume.com/
X-Cache: Redirect from cloudfront
Via: 1.1 ad83caccc6df40ffae4e42b842df398e.cloudfront.net (CloudFront)
X-Amz-Cf-Pop: LAX54-P3
Alt-Svc: h3=":443"; ma=86400
X-Amz-Cf-Id: QEjN7YnstghjRPO_Y3_M7BwU14TzfqLD36rcUqSNqLQmP3LP_oQ5eA==
```
Then, i cleaned the cache on the redirect CloudFront by using invalidation 

invalidation
```sh
/
/* 
```


