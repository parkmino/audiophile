#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/restart.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#[ "f" = reboot ] && sudo reboot
#[ "f" = poweroff ] && sudo poweroff

echo '<meta http-equiv="refresh" content="0;url=/index.html">'