#!/bin/sh

cat /var/www/html/return.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

if [ "$mpd" = on ]; then
 #sudo sed -i '/musicpd_bg &/,+2s/^#*//' /etc/rc.local
 sudo sed -i 's/id="mpd-id".*/id="mpd-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/musicpd_bg &/,+2s/^/#/' /etc/rc.local
 sudo sed -i 's/id="mpd-id".*/id="mpd-id">/' /var/www/html/index.html
fi

if [ "$roon" = on ]; then
 #sudo sed -i '/(roon_bridge/s/^#*//' /etc/rc.local
 sudo sed -i 's/id="roon-id".*/id="roon-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/(roon_bridge/s/^/#/' /etc/rc.local
 sudo sed -i 's/id="roon-id".*/id="roon-id">/' /var/www/html/index.html
fi

if [ "$airplay" = on ]; then
 #sudo sed -i '/(shairport_sync/s/^#*//' /etc/rc.local
 sudo sed -i 's/id="airplay-id".*/id="airplay-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/(shairport_sync/s/^/#/' /etc/rc.local
 sudo sed -i 's/id="airplay-id".*/id="airplay-id">/' /var/www/html/index.html
fi

echo '<meta http-equiv="refresh" content="3;url=/index.html">'