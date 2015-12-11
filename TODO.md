## TODO

### 1. Skripte 

#### allgemein
* auf englisch: Name, Variablen, ausgegebene Texte
* wenn ein Verzeichnis noch nicht existiert, soll das Skript es anlegen
* Skripte sollen von einem beliebigen Verzeichnis aus gestartet werden können. (Zurzeit: "Beachte, dass die Skripte immer vom richtigen Verzeichnis aus gestartet werden müssen.")
* Lizenz?
* sich ändernde Dinge in config-Dateien auslagern
* Workflow automatisieren

#### raw
01_connections-tabelle-verkuerzen.pl
* klären: kann man solr dazu bringen, die Verknüpfungen selbst zu harvesten? Oder die Tabelle harvesten und per solr-Abfrage richtig einsortieren? Oder aus dem A4-Backend?

02_harvesting-von-solr.pl
* verschiedene Schrittweiten für verschiedene Kategorien? Fest eingestellt oder als option?
* Wrapper, um alle Kategorien zu harvesten
* klären: ist `use open qw(:std :utf8);` absichtlich auskommentiert? (in 04_objektkategorien-aufteilen.pl ist es absichtlich auskommentiert "wegen File::Slurp")

##### solr
* eigene data-config.xml für den neuen Workflow? Muss nicht mehr mit der alten Schnittstelle zusammen funktionieren. Für die Zwischenzeit, bis die alte Schnittstelle abgeschaltet ist, eine eigene solr-Instanz?


#### origin
* Liste der Cidoc-Properties auf aktuelle CRM-Version aktualisieren 
  * dafür das aktuelle Cidoc-RDFS nehmen, Liste neu erzeugen
  * und Tabelle "Semantische Verknüpfungen" durchgehen?

03_solr2xml.pl
* Hack mit den Skript- und Daten-Verzeichnissen entfernen, und Daten an die richtige Stelle schreiben
* Auf einen Datensatz pro Datei umstellen: siehe [#1](../../issues/1)

#### Cidoc CRM
* Skript aufteilen in 1. Kategorien-Blaupausen erstellen, 2. Blaupause anwenden für einzelne Datensätze. Das war ja ein Hack, der für das Ad-hoc-Erstellen von Datensätzen in der alten Schnittstelle gedacht war.
* umstellen auf das 3M-Mapping-Format
* Klären: wie ist das mit der "industrial strength"-Version, die viele Datensätze auf einmal verarbeiten kann und `<records>` statt `<record>` verwendet? Ist das bei Umstellung auf einen Datensatz pro Datei ebenfalls überflüssig? (siehe [#1](../../issues/1))

altes todo:
* Datierung kommt in das Produktions-Event. Man muss irgendwann klären, wo die korrekte Angabe steht (in der sem_connections-Tabelle??), und wie sie in das XML kommt


#### EAGLE
* Francesco: weitere Skripte, die er verwendet, und eagle.md ergänzen


#### Pelagios
* Harvesting-Skript (https://github.com/codarchlab/gazetteer/blob/master/src/main/scripts/harvest-gazetteer-json.pl) hierhin verschieben?


### 2. Daten
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


### 3. Dokumentation
* Workflow zusätzlich zu deutsch auch auf englisch
* Übersicht Gesamtstruktur von arachne-oai-pmh-data in einem kleinen Diagramm
* Diagramm: Abhängigkeitne der Datenformate


### 4. OAI-PMH-Interface
* jOAI auf GitHub clonen? Lizenz-Problem oder nicht?
* So bearbeiten, dass das unnötige und zeitaufwändige Indexieren mit Lucene wegfällt? Also einfach ein Wrapper zum Ausliefern der Dateien mit dem OAI-PMH-Protokoll, inkl. diff.
* So bearbeiten, dass nicht der Zeitstempel ausschlaggebend ist, sondern ob sich die Datei tatsächlich geändert hat.
* Ist es einfacher, das Interface komplett neu zu schreiben?


