#!/usr/bin/perl -w
use File::Find;
use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use Unicode::Normalize;

# funktioniert auch mit set:objektplastik etc.: solr hat den Kategoriennamen da bereits auf objekt geändert

# Vorbereitung: lies die Verknüpfungstabelle "SemanticConnection-kurz.txt" ein, die
# von "connections-tabelle-verkuerzen.pl" erzeugt wurde

my $verknuepfDir = "connections/by_category";

my $dirname = $ARGV[0]; 
my $katname = $ARGV[1];

#

# my $trenn = "₮"; # U+20AE
my $trenn = " ";
my $trenn2 = " ### ";

my %katkurz = (
	bauwerk => "bw",
	bauwerksteil => "bt",
	buch => "bu",
	buchseite => "bs",
	datierung => "dt",
	gruppen => "gr",
	gruppierung => "gi",
	literatur => "lt",
	marbilder => "mb",
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

my %katlang;
foreach my $key (keys %katkurz) {
	$katlang{ $katkurz{$key} } = $key;
}

#

my $verknuepfDatei = $dirname."/".$verknuepfDir."/".$katname.".txt";
print "Verknüpfungstabelle ".$verknuepfDatei." einlesen\n";

my %verknuepf;
open (VERKNUEPF, $verknuepfDatei) or die "Could not open ".$verknuepfDatei."\n";
while (<VERKNUEPF>) {
	chomp;
	m!((fk)?\d+) (.+)!;
	$verknuepf{$1} = $3;
}
close(VERKNUEPF);

#

print "Liste der Cidoc-Properties einlesen\n";
my %langform;
open (VERBEN, "cidoc-properties.txt") or die "Could not open cidoc-properties.txt\n";
while (<VERBEN>) {
	chomp;
	# Beispiel-Eintrag: P4I.is_time-span_of
	m!((P\d+I?)\..+)$!;
	$langform{$2} = $1;
}
close(VERBEN);

#

my $weiteresDir = $dirname."/".$katname;
print "Verzeichnis ".$weiteresDir." einlesen\n";
# opendir(DIR, $weiteresDir) or die "Could not open dir $weiteresDir\n";
# my @allfiles = readdir DIR;
# closedir(DIR);

my @allfiles = ();
sub wanted {
  if ($_ =~ /txt/) {
    push(@allfiles, $File::Find::dir."/".$_);
  }
}

find(\&wanted, $weiteresDir);

foreach my $filename (@allfiles) {

	next unless $filename =~ m!^(.+-\d+)\.txt$!;
	my $newFilename = $1."-origin.xml";
	print $filename." --> ".$newFilename."\n";
	
	open (ALT, "$filename");
	my @lines = <ALT>;
	close(ALT);

	# ermittle Kategorie der Datensätze
	# und stelle sicher, dass es nur eine einzige Kategorie pro Datei gibt
	# (für die Objekterweiterungskategorien wird das durch
	#  "04_objektkategorien-aufteilen.pl" erledigt)
	# (für alle anderen Kategorien sollte das eigentlich dadurch erledigt sein,
	# dass Arachne kategorienweise jeweils in eigene Verzeichnisse 
	# geharvestet wird. Es werden auch nur dei Verknuepfungen einer
	# Kategorie eingelesen.)
	
	my $kategorie = "";
	foreach (@lines) {
		next unless m!"kategorie":"([^"]+)"!;
		if ($kategorie eq "") {
			$kategorie = $1;
		} else {
			if ($kategorie ne $1) { die "verschiedene Kategorien in $filename\n"; }
		}
	}
	if ($kategorie ne $katname) { die "Für $kategorie wurden die Verknüpfungen nicht eingelesen!\n"; }

	# erstelle das XML
	
	my $praeambelVorbei = 0;
	my $arachneEntityID = "";
	my $seriennummer = "";
	
 	my $neu = "<records>\n";
 	
	my $i = -1;
	foreach (@lines) {
	
		$i++;	
#		print $i."\n";

		# Finde den Beginn des erstes Datensatzes
		
		if (m!"response":{"numFound":\d+,"start":\d+,"docs"!) {
			$praeambelVorbei = 1;

			# Beginn des ersten Datensatzes		
			$neu .= "  <".$kategorie.">\n";

			# Schnittstelle: ergänze <oaiCategory>
			$neu .= ergaenzeDatenfeld("oaiCategory", $kategorie);
			
			$arachneEntityID = "";
			$seriennummer = "";

			next;
		}
		next unless $praeambelVorbei;
		
		# Ende eines Datensatzes
		if (($lines[$i-1] =~ m/},$/) or ($lines[$i-1] =~ m/}]$/)) {
			
			# ergänze Verknüpfungen zu anderen Kategorien:
			# verwende dafür "ArachneEntityID":["000"] oder "seriennummer":000
			# Beispiel: 33 P59i:1207994 P8i:fk39580 P89i:1816
			# --> in Datensatz mit ArachneEntityID 33 wird ergänzt:
			# <verknuepfung>P59I.is_located_on_or_within http://arachne.uni-koeln.de/entity/1207994</verknuepfung>
			# <verknuepfung>P8I.witnessed http://arachne.uni-koeln.de/item/datierung/39580</verknuepfung>
			# <verknuepfung>P89I.contains http://arachne.uni-koeln.de/entity/1816</verknuepfung>
			# (fk steht für foreign key, also einen Datensatz, der keine ArachneEntityID hat,
			# sondern nur eine Seriennummer)

# 1060367 P46i 5831 bw *** P53i 1203931 or {"ort.ArtOrtsangabe":"Aufbewahrung Automatisch erstellt"} *** P62i 164493 m *** P62i 164494 m *** P62i 164495 m *** P62i 164496 m *** P62i 164497 m

			my $verweis = ($arachneEntityID ? $arachneEntityID : "fk".$seriennummer); 
			if (exists $verknuepf{$verweis}) {
#				while ($verknuepf{$verweis} =~ m!(P\d+i?):((fk)?\d+)!g) {
				foreach my $entry (split($trenn2, $verknuepf{$verweis})) {
					$entry =~ m!(P\d+i?)$trenn((fk)?\d+)$trenn([a-z]+)($trenn(.+))?!;
					my $kurz = $1;
					my $nach = $2;
					my $kat = $4;
					my $additional = $6;
					
					$kurz =~ s/i/I/;
					unless (exists $langform{$kurz}) { die $kurz." existiert nicht\n"; }
					
					if (exists $katlang{$kat}) { $kat = $katlang{$kat}; }
					
					if ($nach =~ m!^fk(\d+)!) {
						$nach = "http://arachne.uni-koeln.de/item/". $kat."/". $1;
					} else {
						$nach = "http://arachne.uni-koeln.de/entity/" . $nach;
					}
					
					my $inhalt = $langform{$kurz}." ".$kat." ".$nach;
					if ($additional) { $inhalt .= " ".$additional };
					
					$neu .= ergaenzeDatenfeld("verknuepfung", $inhalt);
				}
			}

			$neu .= "  </".$kategorie.">\n";

			if ($lines[$i-1] =~ m/},$/) {	
				# es kommt noch ein weiterer Datensatz:
				# Beginn des nächsten Datensatzes
				$neu .= "  <".$kategorie.">\n";

				# Schnittstelle: ergänze <oaiCategory>
				$neu .= ergaenzeDatenfeld("oaiCategory", $kategorie);
			
				$arachneEntityID = "";
				$seriennummer = "";
			}
			next;
		}

		# ignoriere leere Datenfelder
		# (beachte: Fälle wie "Material":["\n"] in objekt-10202 werden *nicht* übersprungen)
		next if m/\[""\]/;
		
		# Typ "FS_Objekt_Siegel_Key":0
		if (m!"(.+?)":(\d+)!) {
			$neu .= ergaenzeDatenfeld($1, $2);

			# werte "seriennummer":000 aus
			if ($1 eq "seriennummer") { $seriennummer = $2; }

			next;
		}

		# Typ "last_modified":"2011-08-04 09:03:48.0"
		if (m!"(.+?)":"(.+)"!) {
			$neu .= ergaenzeDatenfeld($1, $2);
			next;
		}
		
		# Typ "unterkategorie":["objektgemaelde","objektkeramik","objektplastik"]
		# (kommt nur bei "unterkategorie" vor)
		if (m!"unterkategorie":\["(.+)"\]!) {
			my $inhalt = $1;
			$inhalt =~ s!","!, !g;
			$neu .= ergaenzeDatenfeld("unterkategorie", $inhalt);
			next;
		}
		
		# Typ "KurzbeschreibungObjekt":["Weibliche Gewandstatue"]
		if (m!"(.+?)":\["(.+)"\]!) {
			$neu .= ergaenzeDatenfeld($1, $2);

			# werte "ArachneEntityID":["000"] aus
			if ($1 eq "ArachneEntityID") { $arachneEntityID = $2; }

			next;
		}
		
		# Typ "set":[ \n "objekt"]
		# Typ "set":[ \n "objekt", \n "objektplastik"]  (wird zu <set>objekt, objektplastik</set>)
		if (m!"set":!) {
			$neu .= "    <set>";
			my $j = $i+1;
			$lines[$j] =~ m!"(.+)"!; 
			$neu .= $1;
			while ($lines[$j] !~ m!\]! ) {
				$j++;
				$lines[$j] =~ m!"(.+)"!; 
				$neu .= ", ".$1;
			}
			$neu .= "</set>\n";
			next;
		}
	}
		
	$neu .= "</records>\n";
	
	open (NEU, ">$newFilename");
	print NEU $neu;
	close(NEU);
}

sub ergaenzeDatenfeld {
	my $element = shift;
	my $inhalt = shift;
	
	# Schnittstelle: lastModified --> last_modified
	if ($element eq "lastModified") { $element = "last_modified"; }

	#  \n  \r\n  \t  (von solr eingefügt)
	$inhalt =~ s!\\r\\n!\n!g; # Windows-Zeilenumbruch
	$inhalt =~ s!\\n!\n!g; # Unix-Zeilenumbruch
	$inhalt =~ s!\\t!\t!g; # tab

	# das Problem der backslashes
	# beachte: mit diesen Ersetzungen werden teilweise Dinge korrigiert, die
	# eigentlich in Arachne selbst korrigiert werden müssten.
	# Ich liefere also nicht genau das aus, was in Arachne steht.

	# einzelne verbotene Zeichen in Arachne (die Liste ist vielleicht nicht vollständig)
	$inhalt =~ s!\\u000b! !g;
	$inhalt =~ s!\\u2028! !g;

	#  "  '  backslash
	$inhalt =~ s!\\+"!"!g;
	$inhalt =~ s!\\+'!'!g;
	$inhalt =~ s!\\\\!\\!g;
	
	# XML escape sequences für < > &
	# (für ' scheint das nicht nötig zu sein, rdflib lässt es unverändert)
	# (für " scheint es nichts zu bringen, rdflib wandelt auch &quot; in \" um)
	$inhalt =~ s!<!&lt;!g;
	$inhalt =~ s!>!&gt;!g;
	$inhalt =~ s!&!&amp;!g;
	
	# bringe den Inhalt in Unicode-NFC-Normalform
	# (Pflicht für RDF)
	#	unless (checkNFC($inhalt)) { $inhalt = NFC($inhalt); } # warum geht das nicht??
	$inhalt = NFC($inhalt);
	
	return "    <".$element.">" . $inhalt . "</".$element.">\n";
}
