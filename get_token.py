#!/bin/env python
# coding: utf-8

#import urllib3.contrib.pyopenssl
#urllib3.contrib.pyopenssl.inject_into_urllib3()

import sys
from twython import Twython
import key

twitter = Twython(key.APP_KEY, key.APP_SECRET)
auth = twitter.get_authentication_tokens()

print "Visit %s and enter your PIN: " % auth.get('auth_url'),

pin = sys.stdin.readline().strip()

twitter = Twython(key.APP_KEY, key.APP_SECRET, auth.get('oauth_token'), auth.get('oauth_token_secret'))
tokens = twitter.get_authorized_tokens(pin)

print 'OAUTH_TOKEN: %s' % tokens.get('oauth_token')
print 'OAUTH_TOKEN_SECRET: %s' % tokens.get('oauth_token_secret')
