A collection of scripts for exporting Arachne datasets in a variety of data formats. The datasets can then be exported via an OAI PMH interface, the general data formats also via the Arachne frontend. 

## Workflow

First one needs to harvest the raw Arachne data and create the "origin" XML format. From this format all other formats can be derived. 

```
                cidoc_crm ⟶ eagle
              ↗︎
raw ⟶ origin
              ↘︎
                (everything else)
```

More information can be found in the respective folders.


### Start

* [raw](raw)

* [origin](origin)

### Derived formats

#### General data formats

* [Cidoc CRM](cidoc_crm)

* [Dublin Core](dc)

* LIDO

* [METS](mets) (only books)

Projects that harvest a general data format may not be interested in all items. For example, Propylaeum is only interested in books from the set "semantique". 

#### Data formats for specific projects

* [ARIADNE](ariadne)

* [CARARE](carare)

* [Claros](claros)

* [EAGLE](eagle)

* [Enrich](enrich)

* [Pelagios](pelagios)

* [Prometheus](prometheus)

* Geo?


## Data structure

The data structure tentatively looks like this:

```
data/
	raw/
		CATEGORY/
			CATEGORY-0000000.txt
			CATEGORY-0000001.txt
			...
		connections/
			(SemanticConnection.zip)
			SemanticConnection.csv
			by_category/
				CATEGORY.txt
	FORMAT/
		vocab/
			?
		CATEGORY/
			00/
				CATEGORY-1000100-FORMAT.xml
				CATEGORY-1000200-FORMAT.xml
				...
			01/
				CATEGORY-1000101-FORMAT.xml
				CATEGORY-1000201-FORMAT.xml
				...
			...
			99/
				CATEGORY-1000199-FORMAT.xml
				CATEGORY-1000299-FORMAT.xml
				...
	mets/
		SET/
			buch-1-mets.xml
			buch-2-mets.xml
			...
```

FORMAT = origin, cidoc_crm, etc. (except mets)

CATEGORY = bauwerk, objekt, etc.

SET = buch, buch-semantique, buch-archive, etc.

The numbers 1000199 etc. in the diagram stand for ArachneEntityIDs that end with 00, 01, ..., 99.


## Licence

[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0) for all Perl and XSLT scripts. [CC-BY 4.0](http://creativecommons.org/licenses/by/4.0/) for text. However, it seems unlikely that any of this can be reused anywhere else  :-)
