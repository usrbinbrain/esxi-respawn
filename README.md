![GitHub top language](https://img.shields.io/github/languages/top/tr4kthebox/esxi-respawn?color=darckgreen&logo=Linux&logoColor=white)
![GitHub repo size](https://img.shields.io/github/repo-size/tr4kthebox/esxi-respawn?label=Size&logo=github)
![GitHub](https://img.shields.io/github/license/tr4kthebox/esxi-respawn?label=Licence)

# ESXi Respawn.
### _Massive backup and restore of VMware ESXi host configuration._


>This set of scripts is an automation of the backup and restore procedure for ESXi hosts [recommended by MVware](https://kb.vmware.com/s/article/2042141), these scripts use command execution via SSH, so they assume that [SSH authentication](https://kb.vmware.com/s/article/1002866) by public key already exists on ESXi hosts.

### _Install._

Execute the following commands to deploy the tool.

```bash
# Clone the repo.
git clone https://github.com/tr4kthebox/esxi-respawn.git

# Go to the directory and add the execute permissions to the scripts.
cd esxi-respawn && chmod +x esxi-*
```
---

### _Usage._

 - ESXi BACKUP.

The `esxi-backup.sh` script allows you to perform a massive backup task of several ESXi hosts, requiring only one list containing the IP or FQDN of one ESXi host per line.

The backup file is allocated in a directory structure that is created within the script's execution directory.

Example of performing a backup using a list as a parameter.

```bash
./esxi-backup.sh esxi_address_list.txt
```

- ESXi RESTORE.

The `esxi-restore.sh` script operates on only one host at a time, and only performs the restore on the remote ESXi if there is no virtualization running.

After uploading the configuration file to the remote host, it requires confirmation to put the host in maintenance mode and perform the host restore, which necessarily requires an ESXi reboot.

This script requires only the IP or FQDN of an ESXi host as the first argument and a configuration file as the second argument.

To perform ESXi configuration restore follow this example.

```bash
./esxi-restore.sh esxi_ip_or_fqdn /full/local/path/configfile.tgz
```
***
