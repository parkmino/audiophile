#!/usr/bin/python

#https://github.com/Orochimarufan/vlyc2/blob/master/plugins/python/plugins/sbs.py

import sys
import base64
import Cryptodome.Cipher.DES

data = sys.argv[1]
key = b'7d1ff4ea8925c225'
ciphertext = base64.b64decode(data)
cipher = Cryptodome.Cipher.DES.new(key[:8], mode=Cryptodome.Cipher.DES.MODE_ECB)
text = cipher.decrypt(ciphertext)
print(text.decode('utf8'))
