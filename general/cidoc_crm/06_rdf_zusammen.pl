#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my $dirname = $ARGV[0]; 

print "Verzeichnis ".$dirname." einlesen\n";
opendir(DIR, $dirname) or die "Could not open dir $dirname\n";
my @allfiles = readdir DIR;
closedir(DIR);

my $anfang = '<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xml:lang="de">
';

my $ende = '</rdf:RDF>
';

my $i = 0;
my $j = 0;
my $zusammen = $anfang;

foreach my $filename (@allfiles) {

	next unless $filename =~ m!-rdf.xml$!;

	$i++;
	print "einlesen: ".$filename."\n";
	
	open (ALT, "$dirname/$filename");
	while (<ALT>) {
		next if m!^<\?xml !;
		next if m!^<rdf:RDF !;
		next if m!^ +xmlns:!;
		next if m!^ +xml:lang=!;
		next if m!</rdf:RDF>!;
		$zusammen .= $_;
	}
	close(ALT);

	if ($i % 100 == 0) {
		$j++;
		$zusammen .= $ende;
		print "--> ergebnis/".$dirname."-".$j.".rdf\n";
		open (NEU, ">ergebnis/".$dirname."-".$j.".rdf");
		print NEU $zusammen;
		close(NEU);
		$zusammen = $anfang;
	}
}

if ($zusammen ne $anfang) {
	$j++;
	$zusammen .= $ende;
	print "--> ergebnis/".$dirname."-".$j.".rdf\n";
	open (NEU, ">ergebnis/".$dirname."-".$j.".rdf");
	print NEU $zusammen;
	close(NEU);
}
