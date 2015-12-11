A collection of scripts for exporting Arachne datasets in a variety of data formats. The datasets can then be exported via an OAI PMH interface and via the Arachne frontend. 

## Workflow

First one needs to harvest the raw Arachne data and create the "origin" XML format. From this format all other formats can be derived. 

```
               ⟶ cidoc_crm ⟶ eagle
raw ⟶ origin
               ⟶ everything else
```

### 1. Arachne-DB harvesten

Siehe [raw](docs/raw.md)

### 2. origin-Format erstellen

Siehe [origin](docs/origin.md)


### 3. weitere Formate erstellen

* [Ariadne](docs/ariadne.md)

* [Carare](docs/carare.md)

* [Cidoc CRM](docs/cidoc_crm.md)

* [DC](docs/dc.md)

* [EAGLE](docs/eagle.md)

* [METS](docs/mets.md)

* [Pelagios](docs/pelagios.md)
