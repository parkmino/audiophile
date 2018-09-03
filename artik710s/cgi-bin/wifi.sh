#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#sudo sh -c "wpa_passphrase $ap $pass >> /etc/wpa_supplicant/wpa_supplicant.conf"
#sudo systemctl unmask wpa_supplicant
#sudo systemctl start  wlan_dhcp
#sudo systemctl start  wpa_supplicant
#sudo systemctl enable wlan_dhcp
#sudo systemctl enable wpa_supplicant
#sudo dhclient wlan0

sudo sed -i '/ap/s/value=".*"/value="'"$ap"'"/' /var/www/html/index.html
sudo sed -i '/pass/s/value=".*"/value="'"$pass"'"/' /var/www/html/index.html

echo '<meta http-equiv="refresh" content="3;url=/index.html">'