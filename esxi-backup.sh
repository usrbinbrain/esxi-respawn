#!/usr/bin/env bash
#
# Script Name   :esxi-backup.sh
# Description   :Run VMware ESXi host backup configuration and save file on localhost.
# Args          :Require a file with IPv4 or hostname of VMware ESXi hosts.
# Script repo   :https://github.com/tr4kthebox/esxi-respawn
# Author        :G.A.Gama

t=$(date +%Y%m%d-%H%M%S)
cmdargs='-q -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o ConnectTimeout=10'

bkp () {
    esxi=$1
    echo -ne "[+] ESXi (\e[1m$esxi\e[0m) backup "
    path=$(ssh $cmdargs root@"$esxi" 'vim-cmd hostsvc/firmware/sync_config && vim-cmd hostsvc/firmware/backup_config' 2>/dev/null) &&
    [[ ! -d "./backup/bkp_$t/$esxi" ]] && mkdir -p ./backup/bkp_"$t"/"$esxi" &>/dev/null
    scp $cmdargs root@"$esxi":/scratch"${path##*\*}" ./backup/bkp_"$t"/"$esxi" 2>/dev/null &&
    echo -e "\e[32;1mDone!\e[0m" ||
    echo -e "\e[91;1mFail!\e[0m"
}


# If first arg is a file, start read file and run backup of hosts listed.
[[ -f "$1" ]] && 
for host in $(cat "$1"); do
    bkp $host
done &&
echo -e "\e[32;1;5m #\e[0m All backups are save on \e[1m./backup/bkp_$t/\e[0m" ||
echo "[-] Require ESXi list address file as argument."
