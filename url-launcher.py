#!/usr/bin/env python
# Author: jon bradley
# Date: Nov 14, 2014
# Desc: url-launcher and ytube downloader gui with tkinter.
# deps: (requests, pafy) easy to add them with pip.

# Todo:
# - check to see if the file has alreayd been downloaded.
# - play the video with mplayer etc.
# - fix the wavfile sound, probably in a try/accept block
# - stop using external commands 'qiv' and 'play'.

import pafy
import sys
import locale
import sh
import re
import requests
from PIL import ImageTk, Image
from StringIO import StringIO
import os
import Tkinter as tk
import tkMessageBox

soundfile = "/home/kreator/.i3/pop.wav"
downloadpath = "/home/kreator/Desktop/Youtube/Youtube-url-grabber"

if len(sys.argv) < 2:
    print("Usage: {0} <URL>".format(sys.argv[0]))
    sys.exit(1)

# this is for setting up the thousands
locale.setlocale(locale.LC_ALL, "")
# grab the url, put it in variable called url
url = sys.argv[1]
# play the sound to know we pressed a link
try:
    sh.play("-q", soundfile)
except:
    print("Playing {0} failed.".format(soundfile))


def runImageViewer():
    print("Image Viewer...")
    r = requests.get(url)
    i = Image.open(StringIO(r.content))
    i.save('/tmp/myNewPic.png')
    sh.qiv('--scale_down','/tmp/myNewPic.png', _bg=True)


def runAddToMpd():
    print("Add To MPD...")


def runBrowser():
    print("Opening in browser...")
    sh.chromium(url)

# the callback function for creating new video obj.
def videoInfoStats(stuff):
    print(stuff)
    # this is commented beause the Label is not created yet.
    #progressvar.set("{0}".format(stuff))
    #root.update_idletasks()


# the callback function for downloading stats progress.
def dlStats(total, recvd, ratio, rate, eta):
    #print(recvd, ratio, rate, eta)
    progressvar.set("{0:,} bytes RX\n{1:.2f}k/sec\neta: {2:.2f}s".format(recvd, rate, eta))
    root.update_idletasks()


def downloadVideo(v):
    if(os.path.exists(downloadpath) == False):
        sh.mkdir('-p',downloadpath)
        progressvar.set("creating direcotr {0}".format(downloadpath))
        root.update_idletasks()

    dlfilename = "{0}/{1}.{2}".format(downloadpath, v.title.replace('/','_'), v.extension)
    if(os.path.exists(dlfilename)):
        statinfo = os.stat(dlfilename)
        progressvar.set("File already exists:\nyt: {0:,} bytes\nlo: {1:,} bytes".format(v.get_filesize(),statinfo.st_size))
        root.update_idletasks()
    else:
        try:
            v.download(filepath=dlfilename, quiet=True, callback=dlStats)
        except IOError, e:
            tkMessageBox.showwarning("url-launcher","IOError: {0}".format(e))


def hiresDownload():
    v = hires
    downloadVideo(v)

def loresDownload():
    v = lores
    downloadVideo(v)

def playVideo():
    if(os.path.exists(downloadpath) == False):
        sh.mkdir('-p',downloadpath)
        progressvar.set("Creating Directory:\n{0}".format(downloadpath))
        root.update_idletasks()

    hidlpath = "{0}/{1}.{2}".format(downloadpath, hires.title.replace('/','_'), hires.extension)
    lodlpath = "{0}/{1}.{2}".format(downloadpath, lores.title.replace('/','_'), lores.extension)

    if(os.path.exists(hidlpath)):
        # play the hires video with mplayer
        sh.mplayer('-really-quiet',hidlpath, _bg=True)
    elif(os.path.exists(lodlpath)):
        # play the lores video with mplayer
        sh.mplayer('-really-quiet',lodlpath, _bg=True)
    elif(os.path.exists("{0}.temp".format(hidlpath))):
        # play if there is a hi res 'temp' file
        sh.mplayer('-really-quiet',"{0}.temp".format(hidlpath), _bg=True)
    elif(os.path.exists("{0}.temp".format(lodlpath))):
        # play if there is a hi res 'temp' file
        sh.mplayer('-really-quiet',"{0}.temp".format(lodlpath), _bg=True)
    else:
        progressvar.set("Video does not exist!")
        root.update_idletasks()


def runYoutubeDownloader():
    # I need to figure out how I can
    # title this window in Tk for i3
    # to be able to pick it up and
    # make it a floating window.
    print("Youtube Downloader...")

    # make these global so the button callbacks work.
    # there should be a better way than these globals but it works now.
    global hires
    global lores
    global progressvar
    global root

    root = tk.Tk()
    root.wm_title("url-launcher")
    tf = tk.Frame(root)
    bf = tk.Frame(root)
    tf.pack(side=tk.TOP)
    bf.pack(side=tk.BOTTOM)

    textbox = tk.Text(tf, width=40, height=10, state='normal')
    textbox.grid(row=0, column=1, rowspan=2)
    print("ok.. text box should be there")

    video = pafy.new(url.split('&')[0], callback=videoInfoStats)

    textbox.insert('end',"{0}\n".format(video.title))
    textbox.insert('end'," ======================================\n")
    textbox.insert('end',"   Author: {0}\n".format(video.author))
    textbox.insert('end',"Published: {0}\n".format(video.published))
    textbox.insert('end'," Duration: {0}\n".format(video.duration))
    textbox.insert('end'," ======================================\n")
    
    for s in video.streams:
        if(s.extension == "webm"):
            hires = s
        elif(s.extension == "3gp"):
            lores = s
        else:
            print("skipping {0} format.".format(s.extension))
            #tkMessageBox.showwarning("url-launcher","Skipping {0} format.".format(s.extension))

    textbox.insert('end',"hires [{1}]: {0:,} bytes\n".format(hires.get_filesize(), hires.resolution))
    textbox.insert('end',"lores [{1}]: {0:,} bytes\n".format(lores.get_filesize(), lores.resolution))

    # grab the thumbnail jpg.
    req = requests.get(video.thumb)
    photo = ImageTk.PhotoImage(Image.open(StringIO(req.content)))

    # now this is in PhotoImage format can be displayed by Tk.
    plabel = tk.Label(tf,image=photo)
    plabel.image = photo
    plabel.grid(row=0, column=2)

    # a label to display downloading progress.
    progressvar = tk.StringVar(root)
    progressvar.set("download status")
    dlabel = tk.Label(tf, textvariable=progressvar)
    dlabel.grid(row=1, column=2)

    bthi = tk.Button(bf, text='HiRes', command=hiresDownload, fg='red')
    btlo = tk.Button(bf, text='LoRes', command=loresDownload, fg='red')
    btpl = tk.Button(bf, text='Play', command=playVideo, fg='red')
    btqu = tk.Button(bf, text='Quit!', command=root.destroy, fg='red')
    bthi.pack(side=tk.LEFT)
    btlo.pack(side=tk.LEFT)
    btpl.pack(side=tk.LEFT)
    btqu.pack(side=tk.LEFT)

    # start the main loop
    root.mainloop()
    root.destroy()


def main():
    vidregex = re.compile('https?://(www\.)?youtu', re.IGNORECASE)
    jpgregex = re.compile('https?://\S+\.jpg$', re.IGNORECASE)
    pngregex = re.compile('https?://\S+\.png$', re.IGNORECASE)
    m3uregex = re.compile('https?://\S+\.m3u$', re.IGNORECASE)
    plsregex = re.compile('https?://\S+\.pls$', re.IGNORECASE)
    
    if (vidregex.match(url)):
        runYoutubeDownloader()
    elif (jpgregex.match(url)):
        runImageViewer()
    elif (pngregex.match(url)):
        runImageViewer()
    elif (m3uregex.match(url)):
        runAddToMpd()
    elif (plsregex.match(url)):
        runAddToMpd()
    else:
        runBrowser()


if __name__ == '__main__':
    main()

