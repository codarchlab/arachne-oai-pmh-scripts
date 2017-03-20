#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
# use open qw(:std :utf8); # wegen File::Slurp
use Unicode::Normalize;
use File::Slurp;

my $dirname = $ARGV[0];
print "Verzeichnis ".$dirname." einlesen\n";
opendir(DIR, $dirname) or die "Could not open dir $dirname\n";
my @allfiles = readdir DIR;
closedir(DIR);

foreach my $filename (@allfiles) {

	next unless $filename =~ m!^(.+-\d+)-origin\.xml$!;
	my $filename1 = $1;
	
	my $text = read_file($dirname."/".$filename);

	# ermittle <unterkategorie> der Datensätze
	# und verteile sie entsprechend in %unterkategorie
	my %unterkategorie;
	while ($text =~ m!(  <objekt>((.|\n)+?)</objekt>\n)!g) {
		my $objekt = $1;
		if  ($objekt =~ m!<unterkategorie>(.+?)</unterkategorie>!) {
			my $unter = $1;
			$unter =~ s!, !-!g;
			$unterkategorie{$unter} .= $objekt;	
		} else {
			$unterkategorie{"objekt"} .= $objekt;
		}
	}

	# wird mehr als ein Kategorienmapping benötigt?
	# trotzdem Datei umbenennen!
#	next unless scalar(keys(%unterkategorie)) > 1;

	print "\n".$filename."\n";
	foreach my $key (keys %unterkategorie) {
		print $key."\n";
	 	open (NEU, ">".$dirname."/".$filename1."-".$key."-origin.xml");
 		print NEU "<records>\n";
 		print NEU $unterkategorie{$key};
 		print NEU "</records>\n";
 		close(NEU);
	}
#	rename $dirname."/".$filename, $dirname."/alt-".$filename;
	unlink $dirname."/".$filename;
}
