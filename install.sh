#!/bin/bash
apt-get update
apt-get install wget wireguard -y
# wireguard-go
wget https://cdn.jsdelivr.net/gh/peng4740/euserv-wgcf/wireguard-go-linux-amd64.tar.gz
tar zxf wireguard-go-linux-amd64.tar.gz
mv wireguard-go /usr/local/sbin
rm -f wireguard-go-linux-amd64.tar.gz
# wgcf
wget https://cdn.jsdelivr.net/gh/peng4740/euserv-wgcf/wgcf_2.2.2_linux_amd64 -O /usr/local/sbin/wgcf
chmod +x /usr/local/sbin/wgcf
echo|wgcf register
wgcf generate
sed -i '/\:\:\/0/d' wgcf-profile.conf
mkdir -p /etc/wireguard
cp -f wgcf-profile.conf /etc/wireguard/wgcf.conf
# systemctl
ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf
ln -sf /lib/systemd/system/systemd-resolved.service /etc/systemd/system/dbus-org.freedesktop.resolve1.service
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
echo "完成了，可以 ping 1.1.1.1 试试看了"
