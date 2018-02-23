<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:crm="http://www.cidoc-crm.org/rdfs/cidoc_crm_v5.0.2_english_label.rdfs#" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:ore="http://www.openarchives.org/ore/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:xalan="http://xml.apache.org/xalan" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="/record/objekt/ArachneEntityID" />
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
                  <xsl:value-of select="." />
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- dc:description, id: 15 -->
          <xsl:for-each select="../ThemaFrei">
            <dc:description>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="." />
            </dc:description>
          </xsl:for-each>
          <!-- dc:identifier, id: 21 -->
          <xsl:for-each select=".">
            <dc:identifier>
              <xsl:value-of select="." />
            </dc:identifier>
          </xsl:for-each>
          <!-- dc:language, id: 23 -->
          <dc:language>
            <xsl:attribute name="xml:lang">
              <xsl:text>de</xsl:text>
            </xsl:attribute>
            <xsl:text />
          </dc:language>
          <!-- dc:publisher, id: 25 -->
          <dc:publisher>
            <xsl:text />
          </dc:publisher>
          <!-- dc:source, id: 34 -->
          <dc:source>
            <xsl:text>Arachne</xsl:text>
          </dc:source>
          <!-- dc:subject, id: 458 -->
          <xsl:for-each select="../GattungAllgemein">
            <dc:subject>
              <xsl:value-of select="." />
            </dc:subject>
          </xsl:for-each>
          <!-- dc:subject, id: 461 -->
          <xsl:for-each select="../Thema">
            <dc:subject>
              <xsl:value-of select="." />
            </dc:subject>
          </xsl:for-each>
          <!-- dc:subject, id: 37 -->
          <xsl:for-each select="../ThemaTiere">
            <dc:subject>
              <xsl:value-of select="." />
            </dc:subject>
          </xsl:for-each>
          <!-- dc:title, id: 40 -->
          <xsl:for-each select="../KurzbeschreibungObjekt">
            <dc:title>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="." />
            </dc:title>
          </xsl:for-each>
          <!-- dc:type, id: 42 -->
          <xsl:for-each select="../kategorie">
            <dc:type>
              <xsl:value-of select="." />
            </dc:type>
          </xsl:for-each>
          <!-- dcterms:isReferencedBy, id: 71 -->
          <dcterms:isReferencedBy>
            <xsl:text />
          </dcterms:isReferencedBy>
          <!-- dcterms:isReplacedBy, id: 74 -->
          <dcterms:isReplacedBy>
            <xsl:text />
          </dcterms:isReplacedBy>
          <!-- dcterms:issued, id: 80 -->
          <dcterms:issued>
            <xsl:text />
          </dcterms:issued>
          <!-- dcterms:medium, id: 86 -->
          <xsl:for-each select="../Material">
            <dcterms:medium>
              <xsl:value-of select="." />
            </dcterms:medium>
          </xsl:for-each>
          <!-- dcterms:provenance, id: 89 -->
          <xsl:for-each select="../Herkunft">
            <dcterms:provenance>
              <xsl:value-of select="." />
            </dcterms:provenance>
          </xsl:for-each>
          <!-- dcterms:references, id: 92 -->
          <dcterms:references>
            <xsl:text />
          </dcterms:references>
          <!-- dcterms:spatial, id: 101 -->
          <dcterms:spatial>
            <xsl:attribute name="rdf:resource">
              <xsl:text>http://gazetteer.dainst.org/place/</xsl:text>
              <xsl:for-each select="../ortsbezug/Gazetteerid">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="." />
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
            <xsl:text />
          </dcterms:spatial>
          <!-- dcterms:temporal, id: 107 -->
          <xsl:for-each select="../datierung/AnfEpoche">
            <dcterms:temporal>
              <xsl:value-of select="." />
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
        <!-- edm:Place, id: 224 -->
        <edm:Place>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://gazetteer.dainst.org/place/</xsl:text>
            <xsl:for-each select="../ortsbezug/Gazetteerid">
              <xsl:if test="position() = 1">
                <xsl:value-of select="." />
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
        </edm:Place>
      </xsl:if>
      <!-- Check for mandatory elements on ore:Aggregation -->
      <xsl:if test=".">
        <!-- ore:Aggregation, id: 295 -->
        <ore:Aggregation>
          <xsl:attribute name="rdf:about">
            <xsl:text>dai-aggregation:</xsl:text>
            <xsl:for-each select=".">
              <xsl:if test="position() = 1">
                <xsl:value-of select="." />
              </xsl:if>
            </xsl:for-each>
          </xsl:attribute>
          <!-- Check for mandatory elements on edm:aggregatedCHO -->
          <xsl:if test=".">
            <!-- edm:aggregatedCHO, id: 297 -->
            <edm:aggregatedCHO>
              <xsl:if test=".">
                <xsl:attribute name="rdf:resource">
                  <xsl:for-each select=".">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="." />
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
              <xsl:text />
            </edm:aggregatedCHO>
          </xsl:if>
          <!-- edm:dataProvider, id: 299 -->
          <edm:dataProvider>
            <xsl:text>Deutsches Archäologisches Institut</xsl:text>
          </edm:dataProvider>
          <!-- Check for mandatory elements on edm:hasView -->
          <xsl:if test="../marbilder/ArachneEntityID">
            <!-- edm:hasView, id: 302 -->
            <edm:hasView>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/data/image/</xsl:text>
                <xsl:for-each select="../marbilder/ArachneEntityID">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="." />
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
              <xsl:text />
            </edm:hasView>
          </xsl:if>
          <!-- Check for mandatory elements on edm:isShownAt -->
          <xsl:if test=".">
            <!-- edm:isShownAt, id: 304 -->
            <edm:isShownAt>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/entity/</xsl:text>
                <xsl:for-each select=".">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="." />
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
              <xsl:text />
            </edm:isShownAt>
          </xsl:if>
          <!-- Check for mandatory elements on edm:isShownBy -->
          <xsl:if test="../marbilder/ArachneEntityID">
            <!-- edm:isShownBy, id: 306 -->
            <edm:isShownBy>
              <xsl:attribute name="rdf:resource">
                <xsl:text>https://arachne.dainst.org/data/image/</xsl:text>
                <xsl:for-each select="../marbilder/ArachneEntityID">
                  <xsl:if test="position() = 1">
                    <xsl:value-of select="/record/objekt/marbilder[1]" />
                  </xsl:if>
                </xsl:for-each>
              </xsl:attribute>
            </edm:isShownBy>
          </xsl:if>
          <!-- edm:provider, id: 312 -->
          <edm:provider>
            <xsl:attribute name="xml:lang">
              <xsl:text>de</xsl:text>
            </xsl:attribute>
            <xsl:text>Deutsches Archäologisches Institut</xsl:text>
          </edm:provider>
          <!-- dc:rights, id: 315 -->
          <dc:rights>
            <xsl:text />
          </dc:rights>
          <!-- edm:rights, id: 318 -->
          <edm:rights>
            <xsl:attribute name="rdf:resource">
              <xsl:text>http://creativecommons.org/licenses/by/3.0/</xsl:text>
            </xsl:attribute>
            <xsl:text />
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
