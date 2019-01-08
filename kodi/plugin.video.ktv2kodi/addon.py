
import sys, xbmcgui, xbmcplugin
import urllib, urllib2, re

addon_handle = int(sys.argv[1])

xbmcplugin.setContent(addon_handle, 'video')

def url_func(url):
    WebSock = urllib.urlopen(url)
    WebHTML = WebSock.read()
    WebSock.close()
    return WebHTML

def kbs_func(code):
    Base_URL = 'http://onair.kbs.co.kr/index.html?sname=onair&stype=live&ch_code=' + code
    WebHTML = url_func(Base_URL)
    Temp_Web_URL = re.compile('http://.*_lsu_sa_=[0-9a-z]*').findall(WebHTML)
    url = Temp_Web_URL[0].split('\\', 1)[0]
    ### Double query
    #url_root = url.rsplit('/', 1)[0]
    #M3U = url_func(url)
    #M3U = re.compile('.*m3u.*').findall(M3U)[0]
    #url = url_root + '/' + M3U
    ###
    return url

def mbc_func(code):
    Base_URL = 'http://miniplay.imbc.com/AACLiveURL.ashx?channel=' + code + '&agent=android&protocol=M3U8'
    url = url_func(Base_URL)
    ### Double query
    #url_root = url.rsplit('/', 1)[0]
    #M3U = url_func(url)
    #M3U = re.compile('.*m3u.*').findall(M3U)[0]
    #url = url_root + '/' + M3U
    ###
    return url

def sbs_func(code1, code2):

    Base_URL = 'http://api.sbs.co.kr/vod/_v1/Onair_Media_Auth_Security.jsp?channelPath=' + code1 + '&streamName=' + code2 + '.stream&playerType=mobile'
    data = url_func(Base_URL)

    import base64, Crypto.Cipher.DES

    key = b'7d1ff4ea8925c225'
    ciphertext = base64.b64decode(data)
    cipher = Crypto.Cipher.DES.new(key[:8], mode=Crypto.Cipher.DES.MODE_ECB)
    text = cipher.decrypt(ciphertext)
    url = text.decode('utf8')

    ### Double query
    #print(url)
    #M3U = url_func(url)
    #url = re.compile('.*m3u.*').findall(M3U)[0]
    ###
    return url

def ch_func(ch):
    if   ch == 'KBS 1TV':
        url = kbs_func('11')
    elif ch == 'KBS 2TV':
        url = kbs_func('12')
    elif ch == 'KBS WORLD':
        url = kbs_func('14')
    elif ch == 'KBS24':
        url = kbs_func('81')
    elif ch == 'KBSN Sports':
        url = kbs_func('N95')
    elif ch == 'KBSN Drama':
        url = kbs_func('N91')
    elif ch == 'KBSN Joy':
        url = kbs_func('N92')
    elif ch == 'KBSN W':
        url = kbs_func('N94')
    elif ch == 'KBSN Life':
        url = kbs_func('N93')
    elif ch == 'KBSN Kids':
        url = kbs_func('N96')
    elif ch == 'SBS':
        url = sbs_func('sbsch6pc', 'sbsch60')
    elif ch == 'SBS Plus':
        url = sbs_func('sbspluspc', 'sbsplus0')
    elif ch == 'SBS CNBC':
        url = sbs_func('sbscnbc',   'sbscnbc0')
    elif ch == 'SBS funE':
        url = sbs_func('sbsetvpc',  'sbsetv0')
    elif ch == 'SBS Golf':
        url = sbs_func('sbsgolf',   'sbsgolf')
    elif ch == 'SBS MTV':
        url = sbs_func('sbsmtvpc',  'sbsmtv0')
    elif ch == 'SBS nick':
        url = sbs_func('sbsnickpc', 'sbsnick0')
    elif ch == 'SBS Sports':
        url = sbs_func('sbsespn',   'sbsespn0')
    else:
        print 'Argument(s) is missing or invalid!'
        quit()
    return url

def add_func(ch, url):
    url = url
    li = xbmcgui.ListItem(ch, iconImage='DefaultVideo.png')
    xbmcplugin.addDirectoryItem(handle=addon_handle, url=url, listitem=li)

chs = ["KBS 1TV", "KBS 2TV", "KBS WORLD", "KBS24", "KBSN Sports", "KBSN Drama", "KBSN Joy", "KBSN W", "KBSN Life", "KBSN Kids", "SBS", "SBS Plus", "SBS CNBC", "SBS funE", "SBS Golf", "SBS MTV", "SBS nick", "SBS Sports"]
for ch in chs:
    ch = ch
    url = ch_func(ch)
    add_func(ch, url)

add_func('EBS1',  'http://ebsonair.ebs.co.kr/groundwavefamilypc/familypc1m/playlist.m3u8')
add_func('EBS2',  'http://ebsonair.ebs.co.kr/ebs2familypc/familypc1m/playlist.m3u8')
add_func('EBSU',  'http://ebsonair.ebs.co.kr/ebsufamilypc/familypc1m/playlist.m3u8')
add_func('EBSi',  'http://ebsonair.ebs.co.kr/plus1familypc/familypc1m/playlist.m3u8')
add_func('EBS+2', 'http://ebsonair.ebs.co.kr/plus2familypc/familypc1m/playlist.m3u8')
add_func('EBSe',  'http://ebsonair.ebs.co.kr/plus3familypc/familypc1m/playlist.m3u8')
add_func('Gukak', 'http://mgugaklive.nowcdn.co.kr/gugakvideo/gugakvideo.stream/playlist.m3u8')
add_func('MNet',  'http://d1cdshhn0sj9xt.cloudfront.net/529/QualityLevels(2628000,as=video)/Fragments(video=i,format=hls).m3u8')

xbmcplugin.endOfDirectory(addon_handle)