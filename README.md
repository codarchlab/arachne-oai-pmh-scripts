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

As can be seen, there are two different routes:
* Route via Cidoc CRM: [raw](original/raw) ⟶ [origin](original/origin) ⟶ [Cidoc CRM](general/cidoc_crm) ⟶ [EAGLE](project-specific/eagle)
* Direct route: [raw](original/raw) ⟶ [origin](original/origin) ⟶ [CARARE](project-specific/carare), etc.

More information can be found in the respective folders.


### Original data

* [raw](original/raw)

* [origin](original/origin)

### Derived formats

#### General data formats

* [Cidoc CRM](general/cidoc_crm)

* [Dublin Core](general/dc)

* LIDO

* [METS](general/mets) (only books)

Projects that harvest a general data format may not be interested in all items. For example, Propylaeum is only interested in books from the set "semantique". 

#### Data formats for specific projects

* [ARIADNE](project-specific/ariadne)

* [CARARE](project-specific/carare)

* [Claros](project-specific/claros)

* [EAGLE](project-specific/eagle)

* [Enrich](project-specific/enrich)

* [Pelagios](project-specific/pelagios)

* [Prometheus](project-specific/prometheus)

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
