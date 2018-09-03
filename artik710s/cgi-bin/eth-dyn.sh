#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

#eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#[ -n "$(which connmanctl)" ] && eth=$(connmanctl services | grep -om1 ethernet.*)
#connmanctl config $eth --ipv4 dhcp

sudo sed -i '/ip4/s/value=".*"/value=""/' /var/www/html/index.html

echo '<meta http-equiv="refresh" content="3;url=/index.html">'