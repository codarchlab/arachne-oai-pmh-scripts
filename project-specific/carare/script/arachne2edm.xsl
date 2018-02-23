<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:crm="http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:ore="http://www.openarchives.org/ore/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:svcs="http://rdfs.org/sioc/services#"
  xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="/record/objekt/ArachneEntityID"/>
  </xsl:template>
  <xsl:template match="/record/objekt/ArachneEntityID">
    <!-- rdf:RDF, id: 0 -->
    <rdf:RDF>
      <!-- Check for mandatory elements on edm:ProvidedCHO -->
      <xsl:if test=".">
        <!-- edm:ProvidedCHO, id: 1 -->
        <edm:ProvidedCHO>
          <xsl:if test=".">
            <xsl:attribute name="rdf:about">
              <xsl:for-each select=".">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- dc:description, id: 15 -->
          <xsl:if test="(../BearbeitungenModern)">
            <xsl:for-each select="../BearbeitungenModern[(.)]">
              <dc:description>
                <xsl:attribute name="xml:lang">
                  <xsl:text>de</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </dc:description>
            </xsl:for-each>
          </xsl:if>
          <!-- dc:language, id: 23 -->
          <dc:language>
            <xsl:text>de</xsl:text>
          </dc:language>
          <!-- dc:publisher, id: 25 -->
          <dc:publisher>
            <xsl:text>Arachne</xsl:text>
          </dc:publisher>
          <!-- dc:subject, id: 389 -->
          <xsl:for-each select="../GattungAllgemein">
            <dc:subject>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </dc:subject>
          </xsl:for-each>
          <!-- dc:subject, id: 37 -->
          <xsl:if test="(../rezeption/GattungAllgemeinRezeption)">
            <xsl:for-each select="../rezeption/GattungAllgemeinRezeption[(.)]">
              <dc:subject>
                <xsl:attribute name="xml:lang">
                  <xsl:text>de</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </dc:subject>
            </xsl:for-each>
          </xsl:if>
          <!-- dc:title, id: 425 -->
          <xsl:for-each select="../KurzbeschreibungObjekt">
            <dc:title>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </dc:title>
          </xsl:for-each>
          <!-- dc:title, id: 40 -->
          <xsl:if test="(not(../KurzbeschreibungObjekt))">
            <xsl:for-each select="../kategorie[(not(../KurzbeschreibungObjekt))]">
              <dc:title>
                <xsl:attribute name="xml:lang">
                  <xsl:text>de</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </dc:title>
            </xsl:for-each>
          </xsl:if>
          <!-- dc:type, id: 42 -->
          <xsl:for-each select="../kategorie">
            <dc:type>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </dc:type>
          </xsl:for-each>
          <!-- dcterms:medium, id: 86 -->
          <xsl:for-each select="../Material">
            <dcterms:medium>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </dcterms:medium>
          </xsl:for-each>
          <!-- dcterms:provenance, id: 89 -->
          <xsl:if test="(../Herkunft != '?')">
            <xsl:for-each select="../Herkunft[(. != '?')]">
              <dcterms:provenance>
                <xsl:value-of select="."/>
              </dcterms:provenance>
            </xsl:for-each>
          </xsl:if>
          <!-- dcterms:references, id: 92 -->
          <xsl:if test="(../literaturzitat/DAIRichtlinien)">
            <dcterms:references>
              <xsl:for-each select="../literaturzitat/DAIRichtlinien[(.)]">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:text> Kat nr. </xsl:text>
              <xsl:for-each select="../literaturzitat/Katnummer[(../DAIRichtlinien)]">
                <xsl:value-of select="."/>
              </xsl:for-each>
              <xsl:text> https://zenon.dainst.org/Record/</xsl:text>
              <xsl:for-each select="../literaturzitat/ZenonID[(../DAIRichtlinien)]">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </dcterms:references>
          </xsl:if>
          <!-- dcterms:spatial, id: 416 -->
          <xsl:if test="(../Fundort != 'nein') or (../Fundort[not(contains(., 'nbekannt'))]) or (../Fundort != '?')">
            <xsl:for-each select="../Fundort[(. != 'nein') or (.[not(contains(., 'nbekannt'))]) or (. != '?')]">
              <dcterms:spatial>
                <xsl:value-of select="substring-before(.,'P')"/>
              </dcterms:spatial>
            </xsl:for-each>
          </xsl:if>
          <!-- dcterms:spatial, id: 101 -->
          <dcterms:spatial>
            <xsl:text>http://gazetteer.dainst.org/place/</xsl:text>
            <xsl:for-each select="../ortsbezug/Gazetteerid">
              <xsl:value-of select="."/>
            </xsl:for-each>
          </dcterms:spatial>
          <!-- dcterms:temporal, id: 107 -->
          <xsl:for-each select="../datierung/AnfEpoche">
            <dcterms:temporal>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="substring-before(.,'P')"/>
            </dcterms:temporal>
          </xsl:for-each>
          <!-- edm:type, id: 134 -->
          <edm:type>
            <xsl:text>IMAGE</xsl:text>
          </edm:type>
        </edm:ProvidedCHO>
      </xsl:if>
      <!-- Check for mandatory elements on edm:Place -->
      <xsl:if test="../ortsbezug/Gazetteerid">
        <!-- edm:Place, id: 269 -->
        <edm:Place>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://gazetteer.dainst.org/place/</xsl:text>
            <xsl:for-each select="../ortsbezug/Gazetteerid">
              <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
          <!-- wgs84_pos:lat, id: 271 -->
          <xsl:for-each select="../ortsbezug/Latitude">
            <xsl:if test="position() = 1">
              <wgs84_pos:lat>
                <xsl:value-of select="."/>
              </wgs84_pos:lat>
            </xsl:if>
          </xsl:for-each>
          <!-- wgs84_pos:long, id: 272 -->
          <xsl:for-each select="../ortsbezug/Longitude">
            <xsl:if test="position() = 1">
              <wgs84_pos:long>
                <xsl:value-of select="."/>
              </wgs84_pos:long>
            </xsl:if>
          </xsl:for-each>
          <!-- skos:prefLabel, id: 274 -->
          <xsl:for-each select="../ortsbezug/Stadt">
            <skos:prefLabel>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </skos:prefLabel>
          </xsl:for-each>
          <!-- Check for mandatory elements on owl:sameAs -->
          <xsl:if test="../ortsbezug/Geonamesid">
            <!-- owl:sameAs, id: 288 -->
            <owl:sameAs>
              <xsl:attribute name="rdf:resource">
                <xsl:text>http://www.geonames.org/</xsl:text>
                <xsl:for-each select="../ortsbezug/Geonamesid">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </owl:sameAs>
          </xsl:if>
        </edm:Place>
      </xsl:if>
      <!-- Check for mandatory elements on ore:Aggregation -->
      <xsl:if test=".">
        <!-- ore:Aggregation, id: 340 -->
        <ore:Aggregation>
          <xsl:attribute name="rdf:about">
            <xsl:text>dai-aggregation: </xsl:text>
            <xsl:for-each select=".">
              <xsl:if test="position() = 1">
                <xsl:value-of select="."/>
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
          <!-- Check for mandatory elements on edm:aggregatedCHO -->
          <xsl:if test=".">
            <!-- edm:aggregatedCHO, id: 342 -->
            <edm:aggregatedCHO>
              <xsl:if test=".">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select=".">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
            </edm:aggregatedCHO>
          </xsl:if>
          <!-- edm:dataProvider, id: 344 -->
          <edm:dataProvider>
            <xsl:attribute name="xml:lang">
              <xsl:text>de</xsl:text>
            </xsl:attribute>
            <xsl:text>Deutsches Archäologisches Institut</xsl:text>
          </edm:dataProvider>
          <!-- Check for mandatory elements on edm:hasView -->
          <xsl:if test="../marbilder/ArachneEntityID">
            <!-- edm:hasView, id: 347 -->
            <edm:hasView>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/data/image/</xsl:text>
                <xsl:for-each select="../marbilder/ArachneEntityID">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </edm:hasView>
          </xsl:if>
          <!-- Check for mandatory elements on edm:isShownAt -->
          <xsl:if test=".">
            <!-- edm:isShownAt, id: 349 -->
            <edm:isShownAt>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/entity/</xsl:text>
                <xsl:for-each select=".">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </edm:isShownAt>
          </xsl:if>
          <!-- Check for mandatory elements on edm:isShownBy -->
          <xsl:if test="../marbilder/ArachneEntityID">
            <!-- edm:isShownBy, id: 351 -->
            <edm:isShownBy>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/data/image/</xsl:text>
                <xsl:for-each select="../marbilder/ArachneEntityID">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </edm:isShownBy>
          </xsl:if>
          <!-- edm:provider, id: 355 -->
          <edm:provider>
            <xsl:text>CARARE</xsl:text>
          </edm:provider>
          <!-- edm:rights, id: 361 -->
          <edm:rights>
            <xsl:attribute name="rdf:resource">
              <xsl:text>http://creativecommons.org/licenses/by/3.0/</xsl:text>
            </xsl:attribute>
          </edm:rights>
          <!-- edm:intermediateProvider, id: 364 -->
          <edm:intermediateProvider>
            <xsl:text>EAGLE</xsl:text>
          </edm:intermediateProvider>
        </ore:Aggregation>
      </xsl:if>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
