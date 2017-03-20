#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Unicode::Normalize;


# TODO: umschreiben als schlichtes shell script

my $engine = shift @ARGV;

my $xslt = shift @ARGV;

my $dirname = shift @ARGV;
print "Verzeichnis ".$dirname." einlesen\n";
opendir(DIR, $dirname) or die "Could not open dir $dirname\n";
my @allfiles = readdir DIR;
closedir(DIR);

foreach my $filename (@allfiles) {

	next unless $filename =~ m!^(.+?)-origin\.xml$!;
	
	my $newFilename = $1 . "-rdf.xml";
	print "erstelle ".$newFilename."\n";

	my $command = "java -jar ".$engine . " -xsl:".$xslt . " -s:".$dirname.'/"'.$filename.'"';
	my $result = `$command`;

	open (NEU, ">".$dirname."/".$newFilename);
	print NEU $result;
	close(NEU);
}
