## TODO

### 1. Skripte 

#### allgemein
* auf englisch: Name, Variablen, ausgegebene Texte
* wenn ein Verzeichnis noch nicht existiert, soll das Skript es anlegen
* Skripte sollen von einem beliebigen Verzeichnis aus gestartet werden können. (Zurzeit: "Beachte, dass die Skripte immer vom richtigen Verzeichnis aus gestartet werden müssen.")
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
* `origin` umbenennen! Kandidaten: original, orig, raw (dann würde raw z.B. in harvested umbenannt werden)
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
* RDF: controlled vocabularies ergänzen
* 06_xml2turtle.py einchecken. Von Matteo, evtl. von mir angepasst?

altes todo:
* Datierung kommt in das Produktions-Event. Man muss irgendwann klären, wo die korrekte Angabe steht (in der sem_connections-Tabelle??), und wie sie in das XML kommt


#### EAGLE
* Francesco: weitere Skripte, die er verwendet, und eagle.md ergänzen


#### METS
* Workflow aus der alten Schnittstelle und dem zusätzlichen Skript extrahieren. Verändert das zusätzliche Skript überhaupt die Datensätze, oder ist es nur ein Tool zum Harvesten der alten Schnittstelle und zur  Fehlerkontrolle? Die Funktion muss es auch weiterhin geben, nachdem die alte Schnittstelle abgeschaltet wird.


#### Pelagios
* Harvesting-Skript (https://github.com/codarchlab/gazetteer/blob/master/src/main/scripts/harvest-gazetteer-json.pl) hierhin verschieben?
* und was Simon gemacht hat

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


### 4. OAI-PMH-Interface
* jOAI auf GitHub clonen? Lizenz-Problem oder nicht?
* So bearbeiten, dass das unnötige und zeitaufwändige Indexieren mit Lucene wegfällt? Also einfach ein Wrapper zum Ausliefern der Dateien mit dem OAI-PMH-Protokoll, inkl. diff (neu, geändert, gelöscht).
* So bearbeiten, dass nicht der Zeitstempel ausschlaggebend ist, sondern ob sich die Datei tatsächlich geändert hat.
* Ist es einfacher, das Interface komplett neu zu schreiben?
* Ziel: Man kann mit den aktuellen Daten einfach die vorhandenen Daten überschreiben, und das OAI-PMH-Interface macht den Rest. Und Arachne sollte die Daten dann ebenfalls automatisch finden und in die Einzelansicht einbinden.

Fragen gestellt im jOAI user forum: https://sourceforge.net/p/dlsciences/discussion/1138932/

#### Problems with Lucene
There seems to be a problem with Lucene: If I try to define a set using some search term, I get a Lucen error message. Lucene says about "org.apache.lucene.analysis.Token": "Deprecated. This class is outdated and no longer used since Lucene 2.9. Nuke it finally!" 

#### Reduce indexing time
jOAI takes a long time indexing 2000 big documents. I guess the culprit is the Lucene indexing. Is there a way to switch Lucene indexing off?

#### checking if a dataset has changed
It seems that jOAI does not inspect a file to see whether it has change, but simply uses the file's timestamp. Is there a way to let jOAI mark only those files as changed that have actually changed?

#### maigrate to modern versioning system
Are there any plans to migrate from CVS to a more modern versioning system?

#### Missing whitespace after preamble leads to invalid XML
It seems that this bug hasn't been fixed in version 3.1.1.4:

I ran into a problem with jOAI which may or may not be similar to the problem described above. We have datasets that start with
<?xml version="1.0" encoding="UTF-8"?>\<mets:mets xmlns:mets="..." ...>
(The \ is only there because the XML snippet get mangled without it.)

When jOAI adds the OAI PMH wrapper, it removes the <?xml version="1.0" encoding="UTF-8"?> line, and with it the \<mets:mets>. The result is an invalid XML. This problem doesn’t occur if we insert a line break, i.e.
<?xml version="1.0" encoding="UTF-8"?>
\<mets:mets xmlns:mets="..." ...>

But the behaviour shouldn’t depend on the presence or absence of whitespace in the XML.

***
You replied:

Thanks for providing the specifics for the error you are seeing. I believe jOAI looks for the presence of the XML declaration <?xml version="1.0" encoding="UTF-8"?> and if found, removes the entire first line before inserting the metadata into the OAI-PMH container, as you describe. You are correct that it should only remove the XML declaration portion and not the rest of the line, if additional content appears there. We'll work to fix this for the next jOAI release.

In the meantime a work-around is to ensure that the XML declaration in the metadata records appear alone by itself without other content on the same line.
***

#### less restrictive licence
It seems that the sourcecode is licenced under the GPL v2 (excluding any libraries). Is there any chance that one could have an additional less restrictive license, such as Apache 2.0?

