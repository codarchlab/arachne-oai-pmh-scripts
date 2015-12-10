### origin-Format erstellen

Voraussetzung: raw-Format bereits erstellt


#### Version mit vielen Datensätzen pro Datei
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


#### "objekt" aufteilen nach Unterkategorien
nur für die Kategorie "Objekt":
```
cd .../arachne-oai-pmh-scripts/origin/
perl 04_objektkategorien-aufteilen.pl ../arachne-oai-pmh-data/raw/categories/objekt
```

