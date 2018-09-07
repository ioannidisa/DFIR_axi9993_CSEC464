#!/bin/bash

# Alexandra Ioannidis 
# Computer Forensics Lab 1
		
# TIME
echo -e "CurrentTime:\tTime Zone:\t PC Uptime:"
time=$(date +%T)
timeZone=$(date +%Z)
up=$(uptime -p)
echo -e "$time\t$timeZone\t\t $up\n"

# OS VERSION
osVer=$(uname -r)
typName=$(uname -n)
kernel=$(uname -v)
echo -e "Numerical OS Version:\tTypical Name:\t  Kernel Version:"
echo -e "$osVer\t$typName\t  $kernel\n"

# SYSTEM HARDWARE SPECS
cpuBrand=$(cat /proc/cpuinfo | grep 'vendor_id' | sed 's/.*: //' | head -n 1)
cpuType=$(cat /proc/cpuinfo | grep 'model name' | sed 's/.*: //' | head -n 1)
ram=$(cat /proc/meminfo | grep 'MemTotal' | sed 's/.*: //' | head -n 1)
hdName=$(lsblk -o NAME -d | tail -n +2)
fileSys=$(df -h | cut -c 1-15)
echo -e "CPU Brand:\tCPU Type:\t\t\t\t\t\tRAM Amount:\t HDD:"
echo -e "$cpuBrand\t$cpuType\t $ram\t $hdName\t\n$fileSys\n"

# HOSTNAME AND DOMAIN
host=$(hostname)
domain=$(domainname)
echo -e "Hostname:\t\t Domain:"
echo -e "$host\t\t $domain\n"

# LIST OF USERS
users=$(cut -d: -f1,3 /etc/passwd)
echo -e "User:SID"
echo -e "$users"
lastLogin=$(last)
echo -e "Login History:"
echo -e "$lastLogin\n"

# START AT BOOT
serv=$(initctl list | awk '{print $1}')
prog=$(ls -1 /etc/init.d)
echo -e "Services starting at Boot:" 
echo -e "$serv"
echo -e "Programs starting at Boot:"
echo -e "$prog\n"


# LIST OF SCHEDULED TASKS
echo -e "List of Scheduled Tasks:"
tasks=$(crontab -l)
echo -e "$tasks\n"

# NETWORK
echo -e "Arp Table:"
arp -e
echo -e "Interface:  MAC Addr:"
ifconfig | grep 'HWaddr' | awk '{print$1, $NF}'
route -n
echo -e "IPv4:"
ifconfig | grep 'inet addr' | cut -d: -f2 | awk '{print $1}' 
echo -e "IPV6:"
ifconfig | grep 'inet6 addr:' | awk '{print $3}'
echo -e "DHCP Server:"
grep dhcp-server-identifier /var/lib/dhcp3/dhclient.leases
cat /etc/resolv.conf | grep nameserver
echo -e "Gateway:"
ip r | grep 'default' | awk '{print $3}'
echo -e "Listening Services:"
netstat --listen | grep "Active UNIX" -B 5000 | head -n -1
echo -e "Established Connections:"
netstat | grep 'ESTABLISHED'

# NET SHARES, PRINTERS, WIFI
echo -e "Network Shares"
smbstatus --shares
echo -e "Printers:"
lpstat -p | awk '{print $2}'
echo -e "Wifi:"
nmcli dev wifi
echo -e "\n"

# LIST OF INSTALLED SOFTWARE
echo -e "List of installed packages:"
dpkg -l | grep ^ii

# PROCESS LIST
echo -e "\nProcesses:"
ps -A

# DRIVER LIST
drivers=$(lsmod | awk -F '\\s' '{print $1}' | tail -n +2)
echo -e "Drivers:"
echo -e "$drivers\n"

#LIST ALL FILES IN DOC/DOWNLOADS FOR EACH USER
# COMPLETE FOR EACH USER
doc=$(ls -1 ~/Documents)
downloads=$(ls -1 ~/Downloads)
echo -e "$doc\t$downloads\n"

# THREE OF MY OWN
freeMem=$(free -mh | grep 'Mem' | awk '{print $4}')
byteOrder=$(lscpu | grep 'Byte Order' | awk '{print $3, $4}')
who=$(whoami)
echo -e "Free Memory:\tCPU Byte Order:\t\tWhoAmI:"
echo -e "$freeMem\t\t$byteOrder\t\t$who"

echo "Credentials:"
read -p "Username:" USER
read -s -p "Password:" PASS


