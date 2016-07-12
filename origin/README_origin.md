### origin-Format erstellen

Voraussetzung: raw-Format bereits erstellt


#### Version mit vielen Datensätzen pro Datei
Einmal pro Kategorie:
```
perl origin/03_solr2xml.pl data/raw CATEGORY
```

braucht:
* "cidoc-properties.txt", Einträge der Form "P1I.identifies"; aus dem Cidoc-RDFS erzeugt
* CATEGORY.txt (z.B. bauwerk.txt) in `arachne-oai-pmh-data/raw/connections/by_category`

Dinge, die das Skript implizit voraussetzt:
* es gibt nur den "Namespace" fk (wenn es mal mehrere gibt, zum Beispiel datProd, datFund, etc., muss man das anpassen)
* fk steht für Datierungen, insbesondere: alle anderen Kategorien haben ArachneEntityIDs


#### "objekt" aufteilen nach Unterkategorien
nur für die Kategorie "Objekt":
```
perl origin/04_objektkategorien-aufteilen.pl data/raw/objekt
```

### veraltet

* Schema http://www.arachne.uni-koeln.de/formats/origin.xsd
* Namespace: http://www.arachne.uni-koeln.de/formats/origin/

