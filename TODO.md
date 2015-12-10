## TODO

### Skripte 

#### allgemein
* auf englisch: Name, Variablen, ausgegebene Texte
* wenn ein Verzeichnis noch nicht existiert, soll das Skript es anlegen
* Skripte sollen von einem beliebigen Verzeichnis aus gestartet werden können
* Lizenz?
* sich ändernde Dinge in config-Dateien auslagern
* Workflow automatisieren

#### raw
01_connections-tabelle-verkuerzen.pl
* klären: kann man solr dazu bringen, die Verknüpfungen selbst zu harvesten? Oder die Tabelle harvesten und per solr-Abfrage richtig einsortieren? Oder aus dem A4-Backend?

02_harvesting-von-solr.pl
* verschiedene Schrittweiten für verschiedene Kategorien? Fest eingestellt oder als option?
* Wrapper, um alle Kategorien zu harvesten

#### origin
* Liste der Cidoc-Properties auf aktuelle CRM-Version aktualisieren 
  * dafür das aktuelle Cidoc-RDFS nehmen, Liste neu erzeugen
  * und Tabelle "Semantische Verknüpfungen" durchgehen?

03_solr2xml.pl
* Hack mit den Skript- und Daten-Verzeichnissen entfernen, und Daten an die richtige Stelle schreiben
* Auf einen Datensatz pro Datei umstellen 
  * die Version mit 1000 Datensätzen pro Datei behalten oder nicht?


#### Cidoc CRM

* Skript aufteilen in 1. Kategorien-Blaupausen erstellen, 2. Blaupause anwenden für einzelne Datensätze. Das war ja ein Hack, der für das Ad-hoc-Erstellen von Datensätzen in der alten Schnittstelle gedacht war.
* umstellen auf das 3M-Mapping-Format

altes todo:
* Datierung kommt in das Produktions-Event. Man muss irgendwann klären, wo die korrekte Angabe steht (in der sem_connections-Tabelle??), und wie sie in das XML kommt


#### EAGLE

* Francesco: weitere Skripte, die er verwendet, und eagle.md ergänzen


#### Pelagios

* Harvesting-Skript (https://github.com/codarchlab/gazetteer/blob/master/src/main/scripts/harvest-gazetteer-json.pl) hierhin verschieben?


### Daten
* Verzeichnis mit sample data
* Kategorien durchgehen: alte Übersicht:

```
 X=XML
 R=RDF
 ?=Problem
 O=Ongoing

 bauwerk XR
 bauwerksteil XR
 datierung XR?, viele leere Datierungen
 gruppen XR
 literatur ?, solr liefert keine Daten
 literaturzitat ?, solr liefert keine Daten
 marbilder XR
 objekt XR
 ort XR
 ortsbezug O?,Could not open ../Daten/verknuepfungen/ortsbezug.txt
 realien XR
 relief XR?, erzeugt kein RDF für letzte Datei
 reproduktion, XR
 rezeption, XR
 sammler, O?, Could not open ../Daten/verknuepfungen/sammler.txt
 sammlungen, XR
 sarkophag, ?, liefert keine Daten
 topographie, XR
 typus, XR
```


### Beschreibung
* Workflow zusätzlich zu deutsch auch auf englisch
