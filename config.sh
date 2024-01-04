###############################
# config script for airdisk
###############################

# refresh software packages
apt-get -y update
apt-get -y upgrade

# install additional software
apt-get -y install samba samba-common-bin hostapd dnsmasq



# add lines to dhcpd.conf file
echo >>/etc/dhcpd.conf <<EOF 
interface wlan0
static ip_address=192.168.0.254/24
nohook wpa_supplicant
EOF

# configure address space
echo > /etc/dnsmasq.conf <<EOF 
# define interface
interface=wlan0
# dhcp address space
dhcp-range=192.168.0.1,192.168.0.100,255.255.255.0,24h 
EOF 

# configure hostapd
echo > /etc/hostapd/hostapd.conf <<EOF 
# interface wlan 
interface=wlan0

# nl80211 driver for pi
driver=nl80211

# SSID
ssid=AirDisk

# mode  : a = IEEE 802.11a (5GHz) , b = IEEE 802.11b (2.4GHz), g = IEEE 802.11g) (2.4GHz)
hw_mode=g

# channel (1-14)
channel=6
EOF 

echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

# configure hostapd
systemctl unmask hostapd
systemctl enable hostapd

# create shared space
mkdir /var/samba

# configure samba
echo  <<EOF 
[airdisk]
path = /var/samba
writeable=Yes
create mask=0777
directory mask=0777
public=no
EOF >> /etc/samba/smb.conf

# reboot pi to launch services
reboot