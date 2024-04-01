#!/usr/bin/env sh
# Setup
set -x
HOME=/var/acme
CONF=/var/acme
mkdir -p $HOME/http
mkdir -p $CONF
cd $HOME
mount -o "remount,exec" /var
curl https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh -o acme.sh
chmod +x acme.sh
curl https://raw.githubusercontent.com/uyauyaninja/datanetsis/main/renew.sh -o renew.sh
chmod +x renew.sh
curl https://raw.githubusercontent.com/uyauyaninja/datanetsis/main/setup.sh -o setup.sh
chmod +x setup.sh
if [ -e /var/acme/config.csv ]
then
    echo "config file already exists, skipping"
else
    curl https://raw.githubusercontent.com/uyauyaninja/datanetsis/main/config.csv -o $CONF/config.csv
fi
chmod +x $HOME/acme.sh
if [ -e /var/acme/ca/acme-v02.api.letsencrypt.org/directory/account.json ]
then
    echo "Account already registered (/var/acme/ca/.. exists)"
else
    echo "Please insert letsencrypt account email"
    read email
    $HOME/acme.sh --config-home $CONF --register-account -m $email --server letsencrypt
fi
mount -o "remount,noexec" /var


## install on boot
mount -o remount,rw /
curl https://raw.githubusercontent.com/uyauyaninja/datanetsis/main/S01acme -o /etc/rc.d/S01acme
chmod +x /etc/rc.d/S01acme
mount -o remount,ro /
echo "Installed sophos-xgs-letsencrypt"
