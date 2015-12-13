### CIDOC CRM

#### Version mit vielen Datensätzen pro Datei

Beachte: diese Version wird vermutlich bald nicht mehr gebraucht. Insbesondere Schritt 2 wird dann überflüssig. (Die Idee von Schritt 2 war offenbar mal, die Daten als großen Datendump per http zugänglich zu machen.)

Einmal pro Kategorie:

##### 1. Dateien erzeugen

```shell
cd .../arachne-oai-pmh-scripts/cidoc_crm
perl 05_XSLT-anwenden.pl path/to/XSLT-engine xslt-Script .../arachne-oai-pmh-data/origin/SET
```

Es muss eine XSLT-2.0-Engine sein. Getestet mit Saxon 9.6 HE. Saxon9he.jar siehe http://sourceforge.net/projects/saxon/files/Saxon-HE/ 


##### 2. RDF zusammenlegen

```shell
cd .../arachne-oai-pmh-data/cidoc_crm
perl .../arachne-oai-pmh-scripts/cidoc_crm/06_rdf_zusammen.pl marbilder

```

#### Version mit einem Datensatz pro Datei

Siehe Issue #1.
