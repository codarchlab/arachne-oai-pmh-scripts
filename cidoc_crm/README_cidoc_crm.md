### CIDOC CRM

Vorbereitung: Eine XSLT-2.0-Engine. Getestet mit Saxon 9.6 HE. Die Anleitung geht davon aus, dass Saxon9he.jar (http://sourceforge.net/projects/saxon/files/Saxon-HE/) sich in `xslt-engine/` befindet.


#### Version mit vielen Datensätzen pro Datei

Beachte: diese Version wird vermutlich bald nicht mehr gebraucht. Insbesondere Schritt 2 wird dann überflüssig. (Die Idee von Schritt 2 war offenbar mal, die Daten als großen Datendump per http zugänglich zu machen.)

Einmal pro Kategorie:

##### 1. Dateien erzeugen

```shell
perl cidoc_crm/05_XSLT-anwenden.pl xslt-engine/Saxon9he.jar cidoc_crm/<xslt-Script> data/origin/CATEGORY
```


##### 2. RDF zusammenlegen

```shell
perl cidoc_crm/06_rdf_zusammen.pl data/cidoc_crm/marbilder

```

#### Version mit einem Datensatz pro Datei

Siehe Issue #1.
