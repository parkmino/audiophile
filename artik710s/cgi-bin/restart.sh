#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/restart.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

#[ "q" = reboot ] && sudo reboot
#[ "q" = poweroff ] && sudo poweroff

echo '<meta http-equiv="refresh" content="0;url=/index.html">'