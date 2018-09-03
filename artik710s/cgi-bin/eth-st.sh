#!/bin/sh

cat /var/www/html/return.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#[ -n "$(which connmanctl)" ] && eth=$(connmanctl services | grep -om1 ethernet.*)
#connmanctl config $eth --ipv4 manual $ip1.$ip2.$ip3.$ip4 $mask1.$mask2.$mask3.$mask4 $gw1.$gw2.$gw3.$gw4
#systemctl disable dhcpcd.service

for i in ip1 ip2 ip3 ip4 mask2 mask3 gw1 gw2 gw3 gw4; do
 sudo sed -i '/'"$i"'/s/value=".*"/value="'"$(eval echo \"\$"$i"\")"'"/' /var/www/html/index.html
done

echo '<meta http-equiv="refresh" content="3;url=/index.html">'