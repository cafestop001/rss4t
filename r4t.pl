#!/usr/bin/perl

use strict;

use XML::XPath;
use LWP::Simple qw(get);

sub logger{
	my $string = shift;
	my $timestr = localtime;
	print $timestr," : $string\n";
}
# read the configuration file where stores the rss feeds
my $configfile = "r4t.conf";
open(my $fh, "<", $configfile) or die "Cannot open configuration file - $configfile : $!";

SOURCE:while(<$fh>){
my $count = 0;
my @urls = ();
my $result = get($_);
#my $result = get("http://www.hdstar.org/torrentrss.php?myrss=1&linktype=dl&uid=103650&passkey=e3e93f8fa2e87e8488d45ae0367c0557");
my $xpath = XML::XPath->new(xml => $result);

my @titleNodes = $xpath->find("/rss/channel/title")->get_nodelist();
my $titleNode = $titleNodes[0];
my $title = $titleNode->getChildNode(1)->toString();
logger ("=============== Processing $title ===============");

my $items = $xpath->find("/rss/channel/item");

if (!$items->isa('XML::XPath::NodeSet') || $items->size <=0){
#	print "No entry found!","\n";
#	print $result;
#	next SOURCE;
}
else{
ITEM: foreach my $item ($items->get_nodelist()){
	my $url;
	my $path = XML::XPath->new(xml => $item->toString());
	# looking for enclosure tag
	my $enclosures = $path->find("/item/enclosure");
	my $links = $path->find("/item/link");
	if($enclosures->isa('XML::XPath::NodeSet') && $enclosures->size > 0){
		foreach my $enclosure ($enclosures->get_nodelist()){
			if ($enclosure->isa('XML::XPath::Node::Element')){
				my $type = $enclosure->getAttribute('type');
				if($type eq 'application/x-bittorrent'){
					$url = $enclosure->getAttribute('url');
				}
			}	
		}
		if(defined $url){
			$urls[++$#urls] = $url;
		}
	}
	# no enclosure tag, using link tag
	elsif($links->isa('XML::XPath::NodeSet') && $links->size > 0){
                foreach my $link($links->get_nodelist()){
                        if ($link->isa('XML::XPath::Node::Element')){
                                $url = $link->getChildNode(1)->toString;
                        }
                }
                if(defined $url){
                        $urls[++$#urls] = $url;
                }
        }

}


for(my $i=0;$i<@urls;$i++){
#	print "$urls[$i]\n";
	my @args = ("transmission-remote","-a",$urls[$i]);
	if(system(@args) == 0){
		$count++;	
	}
}
}
logger ("Added $count Torrents");
}
#print "Version is $XML::XPath::VERSION";
