#!/usr/bin/python

#https://github.com/Orochimarufan/vlyc2/blob/master/plugins/python/plugins/sbs.py

import base64
import Crypto.Cipher.AES
import Crypto.Cipher.DES

#data = 'cac4d4e664757c1d5e805bcec4a2ca6ff7046e08a88de41f55a5f0626e4b00f7f0e17e8e5e4da22da8f8963c9486'
data = 'Y2FjNGQ0ZTY2NDc1N2MxZDVlODA1YmNlYzRhMmNhNmZmNzA0NmUwOGE4OGRlNDFmNTVhNWYwNjI2ZTRiMDBmN2YwZTE3ZThlNWU0ZGEyMmRhOGY4OTYzYzk0ODY='
#key = 'ckvosejfkeldh'
key = 'Y2t2b3NlamZrZWxkaA=='
#ciphertext = base64.b64decode(data)
#ciphertext = 'Y2FjNGQ0ZTY2NDc1N2MxZDVlODA1YmNlYzRhMmNhNmZmNzA0NmUwOGE4OGRlNDFmNTVhNWYwNjI2ZTRiMDBmN2YwZTE3ZThlNWU0ZGEyMmRhOGY4OTYzYzk0ODY='
ciphertext = data
#iv = ciphertext[1:17]
#counter = Counter.new(256, initial_value = bytes_to_long(iv))
#cipher = Crypto.Cipher.AES.new(key, Crypto.Cipher.AES.MODE_CTR, counter = counter)
cipher = Crypto.Cipher.AES.new(key[:16], Crypto.Cipher.AES.MODE_CTR)
text = cipher.decrypt(ciphertext)
print(text)
#print(text.decode('utf8'))

#data = text
#key = b'7d1ff4ea8925c225'
##ciphertext = base64.b64decode(data)
#ciphertext = data
#cipher = Crypto.Cipher.DES.new(key[:8], mode=Crypto.Cipher.DES.MODE_ECB)
#text = cipher.decrypt(ciphertext)
#print(text.decode('utf8'))
