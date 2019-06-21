#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

sudo systemctl start sshd

echo '<meta http-equiv="refresh" content="3;url=/index.html">'