#!/usr/bin/python

chs = ["KBS 1FM", "KBS 2FM", "KBS 1R", "KBS 2R", "KBS 3R", "KBS SCR", "KBS RKI",  "KBS 1TV", "KBS 2TV", "KBS WORLD", "KBS24", "KBSN Sports", "KBSN Drama", "KBSN Joy", "KBSN W", "KBSN Life", "KBSN Kids", "MBC Channel M", "MBC FM4U", "MBC FM", "SBS", "SBS Power FM", "SBS Love FM", "SBS Plus", "SBS CNBC", "SBS funE", "SBS Golf", "SBS MTV", "SBS nick", "SBS Sports"]

ch = chs[0]

import urllib, urllib2, re
import xbmc, xbmcgui

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
        url = kbs_func('24')
    elif ch == chs[1]:
        url = kbs_func('25')
    elif ch == chs[2]:
        url = kbs_func('21')
    elif ch == chs[3]:
        url = kbs_func('22')
    elif ch == chs[4]:
        url = kbs_func('23')
    elif ch == chs[5]:
        url = kbs_func('I26')
    elif ch == chs[6]:
        url = kbs_func('I92')
    elif ch == chs[7]:
        url = kbs_func('11')
    elif ch == chs[8]:
        url = kbs_func('12')
    elif ch == chs[9]:
        url = kbs_func('14')
    elif ch == chs[10]:
        url = kbs_func('81')
    elif ch == chs[11]:
        url = kbs_func('N95')
    elif ch == chs[12]:
        url = kbs_func('N91')
    elif ch == chs[13]:
        url = kbs_func('N92')
    elif ch == chs[14]:
        url = kbs_func('N94')
    elif ch == chs[15]:
        url = kbs_func('N93')
    elif ch == chs[16]:
        url = kbs_func('N96')
    elif ch == chs[17]:
        url = mbc_func('chm')
    elif ch == chs[18]:
        url = mbc_func('mfm')
    elif ch == chs[19]:
        url = mbc_func('sfm')
    elif ch == chs[20]:
        url = sbs_func('powerpc', 'powerfm')
    elif ch == chs[21]:
        url = sbs_func('lovepc', 'lovefm')
    elif ch == chs[22]:
        url = sbs_func('sbsch6pc', 'sbsch60')
    elif ch == chs[23]:
        url = sbs_func('sbspluspc', 'sbsplus0')
    elif ch == chs[24]:
        url = sbs_func('sbscnbc', 'sbscnbc0')
    elif ch == chs[25]:
        url = sbs_func('sbsetvpc', 'sbsetv0')
    elif ch == chs[26]:
        url = sbs_func('sbsgolf', 'sbsgolf')
    elif ch == chs[27]:
        url = sbs_func('sbsmtvpc', 'sbsmtv0')
    elif ch == chs[28]:
        url = sbs_func('sbsnickpc', 'sbsnick0')
    elif ch == chs[29]:
        url = sbs_func('sbsespn', 'sbsespn0')
    else:
        print 'Argument(s) is missing or invalid!'
        quit()
    return url

def play_func(ch, url):
    listitem = xbmcgui.ListItem(ch)
    xbmc.Player().play(url, listitem)

url = ch_func(ch)
#print(url)
play_func(ch, url)
