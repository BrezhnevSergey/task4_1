#!/bin/bash

work_folder=$(pwd);
file="task4_1.out";
touch $work_folder/$file;
echo "--- Hardware ---" > $file;
cpu=$(cat /proc/cpuinfo | grep "name" | cut -d: -f2 | uniq);
echo "CPU:$cpu" >> $file;
mem=$(free | grep Mem | sed 's/\s\+/,/g' | cut -d , -f2 );
echo "RAM: $mem" >> $file;
bb_manf=$(sudo dmidecode -s baseboard-manufacturer);
bb_pro_name=$(sudo dmidecode -s baseboard-product-name);
echo "Motherboard: $bb_manf / $bb_pro_name" >> $file;
sys_sn=$(sudo dmidecode -s system-serial-number);
if [ -z "$sys_sn" ]; then
	sys_sn=Unknown;
fi;
echo "System Serial Number: $sys_sn" >> $file;
echo "--- System ---" >> $file;
distrib=$(lsb_release -cd | cut -f2 | paste -s -d ' ' 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om);
echo "OS Distribution: $distrib" >> $file;
kernel=$(uname -r);
echo "Kernel version: $kernel" >> $file;
install_date=$(sudo ls -alct --time-style=+"%a %b %d %H:%M:%S %Y" / | tail -1 | awk '{print $6, $7, $8, $9,$10}');
echo "Installation date: $install_date" >> $file;
hostname=$(hostname --fqdn);
echo "Hostname: $hostname" >> $file;
uptime=$(uptime -p | cut -c4-);
echo "Uptime: $uptime" >> $file;
process_cout=$(ps -A --no-headers | wc -l);
echo "Processes running: $process_cout" >> $file;
login_user=$( users | wc -w);
echo "Users logged in: $login_user" >> $file;
echo "--- Network ---" >> $file;
for IF in $(ip addr show | awk -F: '$1>0 {print $2}');
do
	ipaddr=$(ip addr show dev "$IF" | grep "inet\b" | awk '{print $2}' | xargs | sed 's/ /, /g');
	if [ -z "$ipaddr" ]; then
		ipaddr="-";
	fi;
	echo "$IF: $ipaddr" >> $file;
done

