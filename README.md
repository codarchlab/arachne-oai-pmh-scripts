A collection of scripts for exporting Arachne datasets in a variety of data formats. The datasets can then be exported via an OAI PMH interface and via the Arachne frontend. 

## Workflow

First one needs to harvest the raw Arachne data and create the "origin" XML format. From this format all other formats can be derived. 

```
                cidoc_crm ⟶ eagle
              ↗︎
raw ⟶ origin
              ↘︎
                (everything else)
```

### Start

1. [raw](docs/raw.md)

2. [origin](docs/origin.md)

### Derived formats

in alphabetical order:

* [Ariadne](docs/ariadne.md)

* [Carare](docs/carare.md)

* [Cidoc CRM](docs/cidoc_crm.md)

* [DC](docs/dc.md)

* [EAGLE](docs/eagle.md)

* [METS](docs/mets.md)

* [Pelagios](docs/pelagios.md)

## Data structure

```
arachne-oai-pmh-data/
	raw/
		categories/
			SET/
				SET-0000000.txt
				SET-0000001.txt
				...
		connections/
			SemanticConnection.zip
			SemanticConnection.csv
			by_category/
				SET.txt
	FORMAT/
		vocab/
			?
		SET/
			00/
				SET-1000100-FORMAT.xml
				SET-1000200-FORMAT.xml
				...
			01/
				SET-1000101-FORMAT.xml
				SET-1000201-FORMAT.xml
				...
			...
			99/
				SET-1000199-FORMAT.xml
				SET-1000299-FORMAT.xml
				...
```

FORMAT = origin, cidoc_crm, etc.

SET = bauwerk, objekt, etc.

Not all combinations of FORMAT and SET are possible. For example, METS applies only to books.

The numbers 1000199 etc. in the diagram stand for ArachneEntityIDs that end with 00, 01, ..., 99.


## Licence

[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0) for all Perl and XSLT scripts. [CC-BY 4.0](http://creativecommons.org/licenses/by/4.0/) for text. However, it seems unlikely that any of this can be reused anywhere else  :-)
