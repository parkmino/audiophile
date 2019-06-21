#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

#eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#sudo sed -i '/^network={/,$d' /etc/wpa_supplicant/wpa_supplicant.conf
#sudo systemctl disable wpa_supplicant
#sudo systemctl disable wlan_dhcp
#sudo systemctl mask    wpa_supplicant

sudo sed -i '/ap\|pass/s/value=".*"/value=""/' /var/www/html/index.html

echo '<meta http-equiv="refresh" content="3;url=/index.html">'