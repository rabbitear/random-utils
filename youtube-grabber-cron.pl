#!/usr/bin/perl
# this is the cron script to pick up videos
# from a list of youtube links and use youtube-dl
# to download them.

use File::Temp;
use File::Copy;

# where to store the urls
my $yturllist = "/home/juice/YouTube-urltoget";
# check if yturllist exists.
if(! -e $yturllist) {
	die "nothing to do, no list exists.";
}
# check if youtube-dl process is already running.
if(`pgrep -f youtube-dl`) {
	die "youtube-dl is running, do nothing.";
}

# Limit the bandwidth to say 10k or 5m for example.
my $rate = "20k";
# The path to youtube-dl
my $ytldpath = "/usr/local/bin/youtube-dl";
if(! -e $ytldpath) {
	die "couldn't find youtube-dl command.";
}
# Where do you want he voides to end up?
#  - a little code to use the Mon and Day as a directory.
#  - this should all be in the cron part. ***
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
     localtime(time);
my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
#print "$abbr[$mon]$mday\n";
$year += 1900;
my $destdir = "/mnt/nas/Media/Videos/IRC-Vids-$addr[$mon]-$year";
# create the destdir if not existing.
if(! -e $destdir) {
	mkdir $destdir,0755;
}
# here we cp yttmpfile to a tmpfile.
my $tmpfh = File::Temp->new();
my $tmpfname = $tmpfh->filename;
move($yturllist,$tmpfname);

    
# use youtube-dl to get the video
# add '--format 5' if you want low-res videos for a slow connection.
# --format 43 is the best one, mostly! *.webm, but boxee doesn't play
# it, bad boxee! bad boxee! temparary changing it back to 5..
# until can man up for boxee or have them man up.
system("$ytldpath --continue --no-progress --format 5 --rate-limit $rate --quiet --write-info-json --output \"$destdir/%(stitle)s-%(upload_date)s.%(ext)s\" --batch-file \"$tmpfname\" >&/dev/null");

# delete the tmpfile, because we're done.
unlink($tmpfname);

# eof #



