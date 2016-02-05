#!/usr/bin/python3

import feedparser
import urllib3

# retrieve the rss feeds meta data.
sans_dailypostcast_url = "https://isc.sans.edu/dailypodcast.xml"
feed = feedparser.parse( sans_dailypostcast_url )

# split the feed items into a list.
entries = []
for f in feed:
    entries.extend( feed['items'] )

# since we want the 'top' one, which is todays, we use 0
mp3_url = entries[0]['links'][0]['href']
title = entries[0]['title']
published = entries[0]['published']
filename = mp3_url.split('/')[-1]

print("Title: " + title)
print("Published: " + published)
print("Mp3 link: " + mp3_url)
print("Fetching file, please wait..")

# grab the mp3 file.
http = urllib3.PoolManager()
r = http.request('GET', mp3_url)
filesize = str(len(r.data))

# save it to disk.
print("filename: " + filename + ", size: " + filesize)
f = open(filename,'wb')
f.write(r.data)
f.close()
print("==enjoy==")

#eof#
