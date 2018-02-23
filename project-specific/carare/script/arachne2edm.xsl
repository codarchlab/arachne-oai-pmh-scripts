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
          <!-- dc:identifier, id: 21 -->
          <xsl:for-each select=".">
            <dc:identifier>
              <xsl:value-of select="."/>
            </dc:identifier>
          </xsl:for-each>
          <!-- dc:subject, id: 458 -->
          <xsl:for-each select="../GattungAllgemein">
            <dc:subject>
              <xsl:value-of select="."/>
            </dc:subject>
          </xsl:for-each>
          <!-- dc:subject, id: 461 -->
          <xsl:for-each select="../Thema">
            <dc:subject>
              <xsl:value-of select="."/>
            </dc:subject>
          </xsl:for-each>
          <!-- dc:subject, id: 37 -->
          <xsl:for-each select="../ThemaTiere">
            <dc:subject>
              <xsl:value-of select="."/>
            </dc:subject>
          </xsl:for-each>
          <!-- dc:title, id: 40 -->
          <xsl:for-each select="../KurzbeschreibungObjekt">
            <dc:title>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </dc:title>
          </xsl:for-each>
          <!-- dc:type, id: 42 -->
          <xsl:for-each select="../kategorie">
            <dc:type>
              <xsl:value-of select="."/>
            </dc:type>
          </xsl:for-each>
          <!-- edm:type, id: 134 -->
          <edm:type>
            <xsl:text>IMAGE</xsl:text>
          </edm:type>
        </edm:ProvidedCHO>
      </xsl:if>
      <!-- ore:Aggregation, id: 295 -->
      <ore:Aggregation>
        <!-- edm:aggregatedCHO, id: 297 -->
        <edm:aggregatedCHO>
          <xsl:text/>
        </edm:aggregatedCHO>
      </ore:Aggregation>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
