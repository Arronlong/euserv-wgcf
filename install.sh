#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ -f /etc/redhat-release ]; then
        echo -e "暂仅支持 Linux(Ubuntu/Debian) 系统\n其他系统可参考[https://haoduck.com/774.html]手动进行配置"
    elif [ -f /etc/debian_version ]; then
        if [ "$(cat /etc/apt/sources.list|grep debian)" ]; then
            echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
            printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable
        fi
    fi
else
    echo -e "暂仅支持 Linux(Ubuntu/Debian) 系统\n其他系统可参考[https://haoduck.com/774.html]手动进行配置"
fi

apt-get update
apt-get install wget wireguard -y
# wireguard-go
wget https://git.haoduck.cf/github.com/peng4740/wireguard-go-builder/releases/download/0.0.20201118/wireguard-go-linux-amd64.tar.gz
tar zxf wireguard-go-linux-amd64.tar.gz
mv wireguard-go /usr/local/sbin
rm -f wireguard-go-linux-amd64.tar.gz
# wgcf
wget https://git.haoduck.cf/github.com/ViRb3/wgcf/releases/download/v2.2.2/wgcf_2.2.2_linux_amd64 -O /usr/local/sbin/wgcf
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
echo -e "完成了，可以 ping 1.1.1.1 试试看了\n如果没出问题，这里应该能显示你的IP：$(wget -qO- ipv4.ip.sb) <=如果这里是空的，大概是失败了"
