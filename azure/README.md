## Checking updated Nameservers 

After I changed the nameservers for my third-pary domain 
I checked to make sure they were updated using the whois command: 

```sh
sudo apt install whois
whois yemanenigusseresume.net | grep "Name Server" 
```