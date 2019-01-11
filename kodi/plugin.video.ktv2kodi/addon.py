# -*- coding: utf-8 -*-

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
    if   ch == chs[0]:
        url = kbs_func('11')
    elif ch == chs[1]:
        url = kbs_func('12')
    elif ch == chs[2]:
        url = kbs_func('14')
    elif ch == chs[3]:
        url = kbs_func('81')
    elif ch == chs[4]:
        url = kbs_func('N95')
    elif ch == chs[5]:
        url = kbs_func('N91')
    elif ch == chs[6]:
        url = kbs_func('N92')
    elif ch == chs[7]:
        url = kbs_func('N94')
    elif ch == chs[8]:
        url = kbs_func('N93')
    elif ch == chs[9]:
        url = kbs_func('N96')
    elif ch == chs[10]:
        url = sbs_func('sbsch6pc', 'sbsch60')
    elif ch == chs[11]:
        url = sbs_func('sbspluspc', 'sbsplus0')
    elif ch == chs[12]:
        url = sbs_func('sbscnbc',   'sbscnbc0')
    elif ch == chs[13]:
        url = sbs_func('sbsetvpc',  'sbsetv0')
    elif ch == chs[14]:
        url = sbs_func('sbsgolf',   'sbsgolf')
    elif ch == chs[15]:
        url = sbs_func('sbsmtvpc',  'sbsmtv0')
    elif ch == chs[16]:
        url = sbs_func('sbsnickpc', 'sbsnick0')
    elif ch == chs[17]:
        url = sbs_func('sbsespn',   'sbsespn0')
    else:
        print 'Argument(s) is missing or invalid!'
        quit()
    return url

def add_func(ch, url):
    url = url
    li = xbmcgui.ListItem(ch, iconImage='DefaultVideo.png')
    xbmcplugin.addDirectoryItem(handle=addon_handle, url=url, listitem=li)

chs = ["KBS 1TV", "KBS 2TV", "KBS 월드", "KBS24", "KBSN 스포츠", "KBSN 드라마", "KBSN 조이", "KBSN W", "KBSN 라이프", "KBSN 키즈", "SBS", "SBS 플러스", "SBS CNBC", "SBS funE", "SBS 골프", "SBS MTV", "SBS nick", "SBS 스포츠"]

for ch in chs:
    url = ch_func(ch)
    add_func(ch, url)

add_func('EBS1',  'http://ebsonair.ebs.co.kr/groundwavefamilypc/familypc1m/playlist.m3u8')
add_func('EBS2',  'http://ebsonair.ebs.co.kr/ebs2familypc/familypc1m/playlist.m3u8')
add_func('EBSU',  'http://ebsonair.ebs.co.kr/ebsufamilypc/familypc1m/playlist.m3u8')
add_func('EBSi',  'http://ebsonair.ebs.co.kr/plus1familypc/familypc1m/playlist.m3u8')
add_func('EBS+2', 'http://ebsonair.ebs.co.kr/plus2familypc/familypc1m/playlist.m3u8')
add_func('EBSe',  'http://ebsonair.ebs.co.kr/plus3familypc/familypc1m/playlist.m3u8')
add_func('국악 TV', 'http://mgugaklive.nowcdn.co.kr/gugakvideo/gugakvideo.stream/playlist.m3u8')
add_func('MNet',  'http://d1cdshhn0sj9xt.cloudfront.net/529/QualityLevels(2628000,as=video)/Fragments(video=i,format=hls).m3u8')

xbmcplugin.endOfDirectory(addon_handle)