#!/bin/sh

echo "Content-type: text/html"
echo ""

cat /var/www/html/return.html

eval "$(echo "$QUERY_STRING" | tr '&' ';')"

kbsr () {
#url=$(curl -s "http://kong.kbs.co.kr/live_player/channelMini.php?id=kbsid&channel=$1" | tail -1)
#url="$(curl -s http://cfpwwwapi.kbs.co.kr/api/v1/landing/live/$1 | cut -d\" -f16)"
#url="$(echo "$url" | cut -d\/ -f-6)/$(curl -s "$url" | tail -1)"
 url="$(curl -s http://cfpwwwapi.kbs.co.kr/api/v1/landing/live/$1 | cut -d\" -f16 | cut -d\/ -f-6)/$(curl -s $(curl -s http://cfpwwwapi.kbs.co.kr/api/v1/landing/live/$1 | cut -d\" -f16) | tail -1)"
}

mbcr () {
 url=$(curl -s "http://miniplay.imbc.com/WebLiveURL.ashx?channel=$1&agent=android&protocol=M3U8&nocash=" | sed -n '3p' | cut -d\" -f2)
}

sbsr () {
 url=$(curl -s "http://apis.sbs.co.kr/play-api/1.0/onair/channel/S$1?v_type=2&platform=pcweb&protocol=hls" | sed 's/.*mediaurl":"//; s/".*//')
}

case $q in
 1fm)   #kbsr 1
        kbsr 24
	#url="http://112.175.138.137:1935/$1/$1.stream/playlist.m3u8"
	;;
 2fm)   #kbsr 2
	kbsr 25
	#url="http://112.175.138.137:1935/$1/$1.stream/playlist.m3u8"
	;;
 1r)    #kbsr 3
	kbsr 21
	#url="http://112.175.138.137:1935/${1}adio/${1}adio.stream/playlist.m3u8"
	;;
 2r)    #kbsr 4
	kbsr 22
	#url="http://112.175.138.137:1935/${1}adio/${1}adio.stream/playlist.m3u8"
	;;
 3r)    #kbsr 5
	kbsr 23
	;;
 dmb)   #kbsr 6
	kbsr dmb
	#url="http://112.175.138.137:1935/$1/$1.stream/playlist.m3u8"
	;;
 scr)   #kbsr 7
	kbsr I26
	;;
 rki)   #kbsr 8
	kbsr I92
	;;
 mbcm)  mbcr chm ;;
 mbc4u) mbcr mfm ;;
 mbcfm) mbcr sfm ;;
 sbsp)  sbsr 07  ;;
 sbsl)  sbsr 08  ;;
 cbs)   url="http://aac.cbs.co.kr/cbs939/cbs939.stream/playlist.m3u8" ;;
 tbs)   url="http://tbs.hscdn.com/tbsradio/fm/playlist.m3u8" ;;
 tbse)  url="http://tbs.hscdn.com/tbsradio/efm/playlist.m3u8" ;;
 gugak) url="http://mgugaklive.nowcdn.co.kr/gugakradio/gugakradio.stream/playlist.m3u8" ;;
esac

case $q in
 play|pause|stop) mpc "$q" ;;
 *) mpc add "$url" && mpc play $(mpc playlist | wc -l) ;;
esac

echo '<meta http-equiv="refresh" content="0;url=/index.html">'