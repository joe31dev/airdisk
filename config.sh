###############################
# config script for airdisk
###############################

# refresh software packages
apt-get -y update
apt-get -y upgrade

# install additional software
apt-get -y install samba samba-common-bin hostapd dnsmasq


#configure dhcp
wget https://github.com/joe31dev/airdisk/raw/main/dhcp.conf
sudo cat dhcp.conf >> /etc/dhcp.conf

# configure hostapd
wget https://github.com/joe31dev/airdisk/raw/main/hostapd.conf
sudo cp hostapd.conf /etc/hostapd.conf
sudo echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

# configure dnsmasq
wget https://github.com/joe31dev/airdisk/raw/main/dnsmasq.conf
sudo cp dnsmasq.conf /etc/dnsmasq.conf


# configure hostapd service
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

# create shared space
sudo mkdir /var/samba
sudo chmod 777 /var/samba
sudo chown root:sambashare /var/samba 

# configure samba
wget https://github.com/joe31dev/airdisk/raw/main/smb.conf
sudo cat smb.conf >> /etc/samba/smb.conf
sudo systemctl restart smb

# install rpiplay
sudo apt-get install libavahi-compat-libdnssd
sudo apt-get install libplist
sudo apt-get install libssl

# install nginx server
sudo apt-get -y install nginx
 


# reboot pi to launch services
sudo reboot