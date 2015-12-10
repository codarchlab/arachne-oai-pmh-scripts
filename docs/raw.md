
### Arachne-DB harvesten

#### 1. Verknüpfungen

Dieser Schritt muss nur einmal gemacht werden.

##### 1.1 semantic connections einlesen

in der Arachne-DB:

```
SELECT * INTO OUTFILE '/usr/local/arachne-oai-pmh-data/raw/connections/SemanticConnection.csv'
FROM `SemanticConnection`
```

Beispiel-Zeilen:
```
1	16705	gruppen	400000	1076425	objekt	16628	P46_is_composed_of	
2	1076425	objekt	16628	16705	gruppen	400000	P46i_forms_part_of	
```

lokal speichern als
```
.../arachne-oai-pmh-data/raw/connections/SemanticConnection.csv
```

##### 1.2 nach Datensätzen sortieren

```
cd .../arachne-oai-pmh-data/raw
perl .../arachne-oai-pmh-scripts/raw/01_connections-tabelle-verkuerzen.pl connections/SemanticConnection.csv
```

erzeugt für jede Kategorie eine Liste aller Datensätze mit ihren Verknüpfungen.
* seriennummer nur wenn es keine ArachneEntityID gibt (also nur bei Datierung?); Markierung mit "fk" vor der Zahl (in Schritt 3 wird daraus eine URI)
* Die Cidoc-Verben, die die Semantik der Verknüpfung beschreiben, werden auf ihre Nummer verkürzt (der volle Name wird später wieder ergänzt)

Beispiel-Zeile aus bauwerk.txt:
```
5384 P53 1213534 or # P62i 41319 mb # P62i 41320 mb # P62i 41321 mb
```


#### 2. Datensätze

Beachte: das Skript produziert schwer zu deutende Fehlermeldungen "cannot write to closed filehandle", wenn es das Verzeichnis nicht gibt. Siehe TODO-Liste: Wenn ein Verzeichnis noch nicht existiert, soll das Skript es anlegen.

Voraussetzung: Vorher solr-Index aktualisieren!

Einmal pro Kategorie. Mit SET z.B. = "objekt":
```
cd .../arachne-oai-pmh-data/raw/categories
mkdir SET
perl .../arachne-oai-pmh-scripts/raw/02_harvesting-von-solr.pl SET
```
