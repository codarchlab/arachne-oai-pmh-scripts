#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

# input: 
# SELECT * FROM `SemanticConnection`
# Format csv

# output:
# eine verkürzte Version der Tabelle

# das Skript erwartet folgende Felder in der Tabelle:
# PS_SemanticConnectionID, 
# Source, TypeSource, ForeignKeySource, 
# Target, TypeTarget, ForeignKeyTarget, 
# CIDOCConnectionType, (sollte da sein, kann aber fehlen)
# AdditionalInfosJSON (optional)


# my $trenn = "₮"; # U+20AE
my $trenn = " "; 
my $trenn2 = " # ";

my $dir = "verknuepfungen";

my %kurz = (
	bauwerk => "bw",
	bauwerksteil => "bt",
	buch => "bu",
	buchseite => "bs",
	datierung => "dt",
	gruppen => "gr",
	gruppierung => "gi",
	literatur => "lt",
	marbilder => "mb",
#	modell3d => "m3",
	objekt => "ob",
	ort => "or",
	person => "pe",
	realien => "ra",
	relief => "rl",
	reproduktion => "rp",
	rezeption => "rz",
	sammlungen => "sa",
	topographie => "to",
	typus => "ty"
);

my %lang;
foreach my $key (keys %kurz) {
	$lang{ $kurz{$key} } = $key;
}

my $i = 0;
print "\nTabelle einlesen:\n";

my %liste;
while(<>) { 
	$i++;
	if ($i % 10000 == 0) { print $i."\n"; } 
	die "falsche Zeile: $_\n" unless m!^(\d+)\t(\d+)\t([a-z0-9_]+)\t(\d+)\t(\d+)\t([a-z0-9_]+)\t(\d+)\t((P\d+i?)_[a-z_]+)?\t(.+)?$!;
	# my $ps = $1; # wird nicht gebraucht
	my $source = $2;
	my $typesource = $3;
	my $foreignkeysource = $4;
	my $target = $5;
	my $typetarget = $6;
	my $foreignkeytarget = $7;
	# my $cidocLang = $8;  # wird nicht gebraucht
	my $cidocKurz = $9;
	my $additional = $10;

	next unless $cidocKurz;

	if ($source == 0) { $source = "fk".$foreignkeysource };
	if ($target == 0) { $target = "fk".$foreignkeytarget };

	if (exists($kurz{$typesource})) { $typesource = $kurz{$typesource}; }
	if (exists($kurz{$typetarget})) { $typetarget = $kurz{$typetarget}; }
	
	my $eintrag = $cidocKurz.$trenn.$target.$trenn.$typetarget;
	if ($additional) {
#		die "Trennzeichen $trenn kommt vor in $_\n" if index($additional , $trenn) != -1;
#		die "Trennzeichen $trenn2 kommt vor in $_\n" if index($additional , $trenn2) != -1;
		$eintrag .= $trenn.$additional;
	}

	if (exists $liste{$typesource}{$source}) {
		$liste{$typesource}{$source} .= $trenn2. $eintrag;	
	} else {
		$liste{$typesource}{$source} = $eintrag;
	}
}

sub nachZahl {
	if ($a =~ m!fk!) {
		if ($b =~ m!fk!) {
			my ($aZahl) = $a =~ m!fk(\d+)!;
			my ($bZahl) = $b =~ m!fk(\d+)!;
			return $aZahl <=> $bZahl;
		} else {
			return 1;
		}
	} else {
		if ($b =~ m!fk!) {
			return -1;
		} else {
			return $a <=> $b;
		}
	}
}

# foreach my $key (sort nachZahl keys %liste) {
# 	print $key." ".$liste{$key}."\n"; 
# }

# foreach my $ts (sort keys %liste) {
# 	print $ts."\n";
# }

print "\nDateien erstellen:\n";

foreach my $ts (sort keys %liste) {
	my $langTs = (exists($lang{$ts}) ? $lang{$ts} : $ts);
	my $file = $dir."/".$langTs.".txt";
	print $file ."\n";
	open (ORIGINAL, ">".$file) or die "Konnte nicht in ".$file." schreiben!\n";
	foreach my $s (sort nachZahl keys %{ $liste{$ts} })  {
		print ORIGINAL $s." ".$liste{$ts}{$s}."\n"; 
	}
	close(ORIGINAL);
}

