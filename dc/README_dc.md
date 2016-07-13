### Dublin Core

#### SyrHer

Bilder in den unstrukturierten Beständen (USBA). Die Daten sind zurzeit nicht öffentlich, das Beispiel-XML ist daher nicht aus SyrHer. 

Aufruf für das Beispiel mit 
```
java -jar xslt-engine/saxon9he.jar -xsl:dc/usba2dc_syrher.xsl -s:dc/marbilderbestand-2500721.xml -o:dc/marbilderbestand-2500721-dc.xml
```

TODO: Aufteilen der Bild-Kategorien in T= `dc:type` (Form) und S = `dc:subject` (Inhalt): 

```
Dokumente T 
	Grabung S
		Fundliste TS
		Tagebuch TS
	Original T
	Reisetagebuch TS
Fotografien T 
	Architektur S
	Kleinfund S
	Landschaft-Urban S
	Luftbild TS
	Skulptur S
	Stimmung S
Karten T 
	Allgemein T
	Kataster TS
	Ortsplan TS
	Thematisch T
	Topografisch T S?
Publikationen T 
	Publikationen T 
Zeichnungen T 
	Architektur S
		Ansicht T? S
		Details T? S
		Perspektive TS
		Plan TS
		Schnitt TS
	Kleinfund S
	Lageplan TS
	Skizze T
	Skulptur S
```

#### Reste

Zwei Versionen?

oai_dc
* Schema: http://www.openarchives.org/OAI/2.0/oai_dc.xsd --> ?
* Namespace: http://www.openarchives.org/OAI/2.0/oai_dc/ --> ?

rdf_dc
* Schema: http://www.w3.org/2000/07/rdf.xsd --> ??
* Namespace: http://purl.org/NET/crm-owl --> sicher falsch
