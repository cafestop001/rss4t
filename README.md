rss4t
=====

This little tool enables transmission to download torrents published by RSS.

Prerequisites:
=============================================
1. Perl – Make sure you have Perl installed on your linux box. If not, please go to Perl’s official site for your system specific instructions.

2. Transmission-daemon – Of cause, you have to get Transmission installed and started. If not, Transmission web site tells how to.

Donwload r4t.tar.gz and install
=============================================
Download the compressed file from the dist folder. Uncompress to any place you have permission.

| gunzip r4t.tar.gz
| tar xvf r4t.tar

To get it installed, just execute the INSTALL file in the extracted folder.

| ./INSTALL

Add your RSS feeds
=============================================
Add your RSS feed links from your trusted torrent sources to r4t.conf file, one link at a line. e.g.

| http://btsource1.org/rss 
| http://btsource2.org/rss

All set, happy BTing!
