## Workflow

### 1. Arachne-DB harvesten

#### 1.1 Verknüpfungen

##### 1.1.1 semantic connections einlesen

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
`arachne-oai-pmh-data/raw/connections/SemanticConnection.csv`

##### 1.1.2 nach Datensätzen sortieren

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


#### 1.2 Datensätze

Vorher solr-Index aktualisieren!

mit SET z.B. = "objekt":
```
cd .../arachne-oai-pmh-data/raw/categories
mkdir SET
perl .../arachne-oai-pmh-scripts/raw/02_harvesting-von-solr.pl SET
```

### 2. origin-Format erstellen

Voraussetzung: Schritt 1

```
cd .../arachne-oai-pmh-scripts/origin/
perl 03_solr2xml.pl .../arachne-oai-pmh-data/raw/categories SET
```


braucht:
* "cidoc-properties.txt", Einträge der Form "P1I.identifies"; aus dem Cidoc-RDFS erzeugt
* SET.txt (z.B. bauwerk.txt) in `arachne-oai-pmh-data/raw/connections/by_category`

Dinge, die das Skript implizit voraussetzt:
* es gibt nur den "Namespace" fk (wenn es mal mehrere gibt, zum Beispiel datProd, datFund, etc., muss man das anpassen)
* fk steht für Datierungen, insbesondere: alle anderen Kategorien haben ArachneEntityIDs

* das ist diesem Skript egal, aber weitere These, die zurzeit noch gilt: Datierung kommt in das Produktions-Event. Man muss irgendwann klären, wo die korrekte Angabe steht (in der sem_connections-Tabelle??), und wie sie in das XML kommt

