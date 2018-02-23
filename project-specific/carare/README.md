### Carare

Testdaten erzeugen:

```
cd [path to]/arachne-oai-pmh-scripts
cd project-specific/carare
java -jar ../../xslt-engine/saxon9he.jar -xsl:script/arachne2edm.xsl -s:original/ -o:edm/
```

veraltet: 
* Schema: http://www.arachne.uni-koeln.de/formats/carare.xsd
* Namespace: http://www.arachne.uni-koeln.de/formats/carare/
