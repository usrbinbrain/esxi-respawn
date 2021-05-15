#!/usr/bin/env bash
#
# Script Name   :esxi-restore.sh
# Description   :Restore file configuration on VMware ESXi hosts through SSH.
# Args          :Require a ESXi address IPv4 or hostname and backup file (.tgz) as second argument to perform restore on remote host.
# Script repo   :https://github.com/tr4kthebox/esxi-respawn
# Author        :G.A.Gama

esxi=$1
bkp=$2
flags="-q -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o ConnectTimeout=10"

restore_check() {
  host=$1
  allvms=$(ssh ${flags} root@"$host" 'vim-cmd vmsvc/getallvms 2>/dev/null') &&
  for line in \
  $(echo "$allvms" |\
  sed -e '1d' -e 's/ \[.*$//' |\
  awk '$1 ~ /^[0-9]+$/ {print $1" "substr($0,8,80)}'); do
    ssh ${flags} root@"$host" 'vim-cmd vmsvc/power.getstate '${line%% *}' 2>/dev/null'|\
    grep 'Powered on' >/dev/null &&\
    echo "[WARNING] STILL VMs RUNNING ON HOST ($host)." &&\
    exit
  done
  echo "[INFO] HOST ALLOWED TO PERFORM RESTORE."

}


respawn() {
  host=$1
  backup=$2
  scp ${flags} ${backup} root@${host}:/tmp/configBundle.tgz &&\
  echo -e "[+] RESTORE FILE WAS UPLOAD TO HOST!" &&\
  read -p "[+] INSERT HOST ($host) ON MAINTENANCE MODE TO PERFORM RESTORE? (y/n): " sec_restore
  if [ "$sec_restore" == "y" ]; then
    ssh $cmdargs root@"$host" 'vim-cmd hostsvc/maintenance_mode_enter && vim-cmd hostsvc/firmware/restore_config /tmp/configBundle.tgz' &&\
    echo -e "[+] ESXi on maintenance mode!\n[+] Starting restore, ESXi will reboot after restore finish."
  else
    echo "[-] RESTORE CANCELED!" &&\
    exit
  fi

}


# First arg require exists and second maybe backup ESXi file.
[[ ! -z "$esxi" ]] && [[ -f "$bkp" ]] &&
# Starting execution.
echo -e "[ Checking host ]" &&
# Check for VMs running.
restore_check "$esxi" &&
# Upload file and restore host.
respawn "$esxi" "$bkp" ||
# Script usage example.
echo -e "[-] Require ESXi address and backup file.tgz.\nRUN: $0 my.esxi.example.com /my/local/file/backup/configBundle.tgz" &&
exit
