## Checking updated Nameservers 

After I changed the nameservers for my third-pary domain 
I checked to make sure they were updated using the whois command: 

```sh
sudo apt install whois
whois yemanenigusseresume.net | grep "Name Server" 
```

## Install Azure Bicep 

We could use Terraform but then we would have to manage the statefile, and if a company only uses 
Azure they lean towards using Azure Bicep. 

```sh
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Login to Azure 

```sh
az login
```

To test that we are logged into azure cli we can run the below command 

```sh
az account show
```

### Install Ansible 

Although we don't need Ansible to run Azure bicep, we want to do various configuration 
changes like uploading our website files so we will use Ansible beacuse its more flexible than bash or powershell scripting. 

```sh
pipx install --include-deps ansible 
```

### Install dependencies for Ansible 

```sh
cd azure
ansible-galaxy collection install -r requirements.txt
```
> fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to import the required Python library (ansible[azure] (azure >= 2.0.0)) on codespaces-b5331c's Python /usr/local/py-utils/venvs/ansible/bin/python. Please read the module documentation and install it in the appropriate location. If the required library is installed, but Ansible is using the wrong Python interpreter, please consult the documentation on ansible_python_interpreter"}

We need to directly install the dependecies to the venv 

```sh 
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade pip
/usr/local/py-utils/venvs/ansible/bin/python -m pip install --upgrade "ansible[azure]"
/usr/local/py-utils/venvs/ansible/bin/python -m pip install -r 
```
> Apparently, ansible[azure] no longer exists, so we need to ensure our collection is installed in the venv 

```sh 
/usr/local/py-utils/venvs/ansible/bin/python -m pip install -r \ 
/workspaces/cloud-resume-challenge/azure/requirements.txt
```
> The above is not working. Lets directly install 

```sh
ansible-galaxy collection install azure.azcollection 
```
This is also not resolving the issue 

## Resolving Install Issues with azure.azcollection [This one fixed the issue]

It turns out that the collection was not installing the deps correctly. 
So I created an `azure-requirements.txt` and then installed it manually. 

```sh
/usr/local/py-utils/venvs/ansible/bin/python -m pip install -r azure-requirements.txt
```
https://github.com/ansible-collections/azure/issues/1463#issuecomment-1964924662
https://github.com/ansible-collections/azure/blob/dev/requirements.txt


## Iac or Configuration Management for Container 

In AWS, a bucket should clearly be managed by IaC. 
In Azure a storage Account would be managed by Iac but wheater a container should be managed by Iac is uncertain. 

We observed that Azure Bicep when renaming our container, it didn't remove the previous name one making us think that maybe containers just like object files should be handle by ansible if containers are not going to act idempotent within Azure Bicep. 



