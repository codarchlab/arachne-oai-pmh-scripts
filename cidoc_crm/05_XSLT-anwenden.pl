#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Unicode::Normalize;

# Anwendung:
# cd dir/des/xslt-Skripts
# perl path/to/05_XSLT-anwenden.pl [path/to/engine] [xslt] [path/to/dir]

# Beispiel:
# cd .../cidoc/mapping
# perl .../05_XSLT-anwenden.pl 
#   /Applications/oxygen/lib/saxon9ee.jar
#   xml2cidoc-rdf.xsl
#   /Users/wschmidle/Documents/solr/objekt-test

# wird zu
# java -jar /Applications/oxygen/lib/saxon9ee.jar 
#    -xsl:xml2cidoc-rdf.xsl 
#    -s:.../objekt-test/objekt-00000.xml 
# etc.

my $engine = shift @ARGV;

my $xslt = shift @ARGV;

my $dirname = shift @ARGV;
print "Verzeichnis ".$dirname." einlesen\n";
opendir(DIR, $dirname) or die "Could not open dir $dirname\n";
my @allfiles = readdir DIR;
closedir(DIR);

foreach my $filename (@allfiles) {

#	next if $filename =~ m!-rdf\.xml$!;
#	next unless $filename =~ m!^(.+?)\.xml$!;
	next unless $filename =~ m!^(.+?)-origin\.xml$!;
	
	my $newFilename = $1 . "-rdf.xml";
	print "erstelle ".$newFilename."\n";

	my $command = "java -jar " . $engine . " -xsl:" . $xslt . " -s:" .$dirname.'/"'.$filename.'"';
	my $result = `$command`;

	open (NEU, ">".$dirname."/".$newFilename);
	print NEU $result;
	close(NEU);
}
