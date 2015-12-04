use strict;
use warnings;
use utf8;
#use open qw(:std :utf8);
use LWP::UserAgent;
use integer;

my $set = "";
my $setParam = "";
if (exists $ARGV[0]) { 
	$set = $ARGV[0];
#	$setParam = " AND (set:" . $set . ")"; 
#	$setParam = "set:" . $set; 
	$setParam = "(set:" . $set . " AND NOT unterkategorie:deleted)"; 
} else {
	die "kein Set angegeben!\n";
}

#my $date = "last_modified:[1970-01-01 TO 2012-06-19]";
#my $q = "?q=" . $date . $setParam . " AND (metadataformats:claros)";
my $q = "?q=" . $setParam;
my $json = "&wt=json&indent=on";
my $rows = 1000;
my $urlAnfang = 'http://arachne.uni-koeln.de/solrOai35/select/';

my $gesamt = 0;
my $numFound = 0;

my $i = 0; 

while (1) {

	my $url = $urlAnfang . $q . "&start=" . $i*$rows . "&rows=" . $rows . $json;

	my $iMitNullen = $i;
	while (length $iMitNullen < 7) { $iMitNullen = "0".$iMitNullen; }	
	
	my $original = $set . "/" . $set . "-" . $iMitNullen . ".txt";
	
	my $ua = LWP::UserAgent->new();
	my $response = $ua->get($url);
	
	my $content;
	if ($response->is_success) {
		$content = $response->decoded_content;
	}
	else {
		die "HTTP Error Message: ". $response->status_line . "\n". $url . "\n";
	}
	
	$content =~ s!\r\n!\n!g;

	print $original  . "\n";

	if ($content =~ m!"response":{"numFound":(\d+)!) { 
		if ($1 != $numFound) {
			$numFound = $1;
			print "numFound: " . $numFound . "\n";
		}
	}

	my $datasets = 0;

	while ($content =~ m!"id"!g) {
		$datasets++;
	}
	$gesamt += $datasets;

	print $datasets . " Datasets, gesamt " . $gesamt . "\n";
	print $url . "\n\n";

	last if $i*$rows >= $numFound;
	
	open (ORIGINAL, ">$original");
	print ORIGINAL $content;
	close(ORIGINAL);

 	$i++;
}
