#!/usr/bin/perl -w
use Irssi 20010120.0250 ();
$VERSION = "0.2";
%IRSSI = (
    authors     => 'Jon Bradley, David Leadbeater',
    contact     => 'weatchu@gmail.com, dgl@dgl.cx',
    name        => 'youtube-grabber2',
    description => 'Captures youtube urls said in channel and private messages and saves them to a file, also downloads the video to a directory of your choice with youtube-dl.',
    license     => 'GNU GPLv2 or later',
);
 
# ktr (aka rabbitear)
#    - I ''stole'' most of the code grom urlgrab.pl in the irssi.org
# scripts directory.  You will need the newest version of youtube-dl
# located at: http://rg3.github.com/youtube-dl/

use strict;
my $lasturl;

# where to store the urls
my $yturllist = "/home/juice/YouTube-urltoget";
# Change the file path below if needed.
my $file = "$ENV{HOME}/YouTube-urlgrab.log";
sub url_public {
   my($server,$text,$nick,$hostmask,$channel)=@_;
   my $url = find_url($text);
   url_log($nick, $channel, $url) if defined $url;
}

sub url_private {
   my($server,$text,$nick,$hostmask)=@_;
   my $url = find_url($text);
   url_log($nick, $server->{nick}, $url) if defined $url;
}

sub find_url {
   my $text = shift;
   if($text =~ /((https|http):\/\/www\.youtube\.com\/watch\?v=[a-zA-Z0-9\/\\\:\?\%\.\&\;=#\-\_\!\+\~]*)/i) {
	   Irssi::print("Youtube URL match!");
	  return $1;
   } elsif($text =~ /((https|http):\/\/www\.metacafe\.com\/watch\/[a-zA-Z0-9\/\\\:\?\%\.\&\;=#\-\_\!\+\~]*)/i) {
	   Irssi::print("Metacafe URL match!");
	   return $1;
   }
   return undef;
}


sub url_log {
   my($where,$channel,$url) = @_;
   return if lc $url eq lc $lasturl; # a tiny bit of protection from spam/flood
   #ktr: next take off the http parmeters everything after '&'
   $url =~ s/&.*$//;
   $lasturl = $url;

   Irssi::print("Recording youtube url.\n");
   open(URLTXT, ">>$yturllist") or return;
   print URLTXT "$lasturl\n";
   close(URLTXT);
   open(URLLOG, ">>$file") or return;
   print URLLOG time." $where $channel $lasturl\n";
   close(URLLOG);
   return;
}

Irssi::signal_add_last("message public", "url_public");
Irssi::signal_add_last("message private", "url_private");

