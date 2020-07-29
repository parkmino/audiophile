#!/usr/bin/python
# -*- coding: utf-8 -*-

chs = ["JTBC 뉴스", "KBS 뉴스", "tbs TV", "연합뉴스", "YTN 라이브", "YTN 라이프", "YTN 사이언스", "맛있는 녀석들"]

ch = chs[7]

import urllib, urllib2, re
import xbmc

def url_func(url):
    WebSock = urllib.urlopen(url)
    WebHTML = WebSock.read()
    WebHTML = WebHTML.decode('utf-8')
    WebSock.close()
    return WebHTML

def ut_func(ch):
    Base_URL = 'http://www.youtube.com/' + ch
    WebHTML = url_func(Base_URL)
    Temp_Web_URL = re.compile('"videoId":"[0-9a-zA-Z-_]*"').findall(WebHTML)
    url = Temp_Web_URL[0].split('"', 4)[3]
    url = 'plugin://plugin.video.youtube/play/?video_id=' + url
    return url

def ch_func(ch):
    if   ch == chs[0]:
        url = ut_func('user/JTBC10news')
    elif ch == chs[1]:
        url = ut_func('user/NewsKBS')
    elif ch == chs[2]:
        url = ut_func('user/seoultbstv/featured')
    elif ch == chs[3]:
        url = ut_func('channel/UCTHCOPwqNfZ0uiKOvFyhGwg')
    elif ch == chs[4]:
        url = ut_func('user/ytnnews24')
    elif ch == chs[5]:
        url = ut_func('channel/UCDww6ExpwQS0TzmREIOo40Q')
    elif ch == chs[6]:
        url = ut_func('user/ytnscience')
    elif ch == chs[7]:
        url = ut_func('channel/UCsOW9TPy2TKkqCchUHL04Fg')
    else:
        print("Argument is missing or invalid!")
        quit()
    return url

def play_func(url):
    xbmc.executebuiltin("PlayMedia("+url+")")

url = ch_func(ch)
#print(url)
play_func(url)
