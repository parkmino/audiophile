#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

#eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#[ -n "$(which connmanctl)" ] && eth=$(connmanctl services | grep -om1 ethernet.*)
#connmanctl config $eth --ipv4 dhcp

for i in ip1 ip2 ip3 ip4; do
 sudo sed -i '/'"$i"'/s/value=".*"/value=""/' /var/www/html/index.html
done

echo '<meta http-equiv="refresh" content="3;url=/index.html">'