## TODO

### Skripte 

#### allgemein
* auf englisch: Name, Variablen, ausgegebene Texte
* wenn ein Verzeichnis noch nicht existiert, soll das Skript es anlegen
* Skripte sollen von einem beliebigen Verzeichnis aus gestartet werden können
* Lizenz?
* sich ändernde Dinge in config-Dateien auslagern

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

* Datierung kommt in das Produktions-Event. Man muss irgendwann klären, wo die korrekte Angabe steht (in der sem_connections-Tabelle??), und wie sie in das XML kommt


### Beschreibung
* Workflow zusätzlich zu deutsch auch auf englisch
