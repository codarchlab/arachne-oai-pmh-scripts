#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Unicode::Normalize;


# perl verteile_buch_datensaetze.pl buchtabelle datensatzDir 

# Beispielzeile aus buchtabelle:
# 1306 buch;semantique


my $buchtabelleName = $ARGV[0];
my $datensatzDir = $ARGV[1];

my %buchtabelle;
my @sets = (
"buch",
"buch-archive-architektenarchiv",
"buch-archive-handzeichnung",
"buch-christern",
"buch-CIL",
"buch-codexSpain",
"buch-eagle",
"buch-semantique",
"buch-Leisner",
"buch-oppenheim",
"buch-Steindorff"
);

foreach my $set (@sets) {
	my $subfolder = $datensatzDir."/".$set;
	mkdir $subfolder unless -d $subfolder;
}

my %buch2dir;

open (FILE, $buchtabelleName) or die "Buchtabelle nicht gefunden\n";
while (<FILE>) {
	if (m!^(\d+) ([a-zA-Z;]+)$!) { 
		my $number = $1;
		my $oaipmhset = $2;
		$oaipmhset =~ s/;/-/g;
		unless ( grep(/^$oaipmhset$/, @sets )) { die "falsches Set ".$oaipmhset."\n"; } 
		$buch2dir{$number} = $oaipmhset;
	}
}
close (FILE);

opendir(DIR, $datensatzDir) or die "Could not open dir $datensatzDir\n";
my @allfiles = readdir DIR;
closedir(DIR);

foreach my $filename (@allfiles) {
	next unless $filename =~ m!oai_arachne\.uni-koeln\.de_buch-(\d+)\.xml$!;
	my $number = $1;
	unless (exists $buch2dir{$number}) { 
		warn "unbekannte Datei: ".$filename."\n"; 
		next;
	}

	my $von = $datensatzDir."/".$filename;
	my $nach = $datensatzDir."/".$buch2dir{$number}."/".$filename;
	rename $von, $nach or die "konnte nicht verschieben: ".$von." --> ".$nach."\n";
#	print $datensatzDir."/".$filename." --> ".$datensatzDir."/".$buch2dir{$number}."/".$filename."\n";
}
