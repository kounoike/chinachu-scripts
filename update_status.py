#!/bin/env python
# coding: utf-8
# written by KOUNOIKE Yuusuke

import requests
from twython import Twython
import sys
import key


twitter = Twython(key.APP_KEY, key.APP_SECRET, key.OAUTH_TOKEN, key.OAUTH_TOKEN_SECRET)

if len(sys.argv) > 2:
    programId = sys.argv[2]
    url = 'http://localhost:10772/api/recorded/%s/preview.png?pos=30' % programId
    # r = requests.get('http://localhost:10772/api/recorded/cs298-y0l/preview.png?pos=30' % programId, stream=True)
    # r = requests.get('http://localhost:10772/api/recorded/cs298-y0l/preview.png?pos=30', stream=True)
    r = requests.get(url, stream=True)
    if r.status_code == 200:
        img_res = twitter.upload_media(media=r.raw)
        twitter.update_status(status=sys.argv[1], media_ids=[img_res['media_id']])
    else:
        twitter.update_status(status=sys.argv[1])
else:
    twitter.update_status(status=sys.argv[1])
