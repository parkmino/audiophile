#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

if [ "$dop" = on ]; then
 #sudo sed -i '/dop/s/^#*//g' /etc/mpd.conf.sav
 sudo sed -i 's/id="dop-id".*/id="dop-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/^dop/s/^/#/g' /etc/mpd.conf.sav
 sudo sed -i 's/id="dop-id".*/id="dop-id">/' /var/www/html/index.html
fi

if [ "$foler" = on ]; then
 #sudo sed -i '/^#*music_directory\|^#*db_file/s/^#*//' /etc/mpd.conf.sav
 sudo sed -i 's/id="folder-id".*/id="folder-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/^music_directory\|^db_file/s/^/#/g' /etc/mpd.conf.sav
 sudo sed -i 's/id="foler-id".*/id="folder-id">/' /var/www/html/index.html
fi

if [ "$tag" = on ]; then
 #sudo sed -i '/metadata.*none/s/^/#/' /etc/mpd.conf.sav
 sudo sed -i 's/id="tag-id".*/id="tag-id" checked>/' /var/www/html/index.html
else
 #sudo sed -i '/metadata.*none/s/^#*//' /etc/mpd.conf.sav
 sudo sed -i 's/id="tag-id".*/id="tag-id">/' /var/www/html/index.html
fi

echo '<meta http-equiv="refresh" content="3;url=/index.html">'