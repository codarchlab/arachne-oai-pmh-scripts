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

  <!-- ergänzt -->
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  
  <xsl:template name="datierungGesamt">
    <xsl:if test="TypDatierung">
      <xsl:value-of select="TypDatierung"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:value-of select="nachantik"/>
    <xsl:if test="FestDat">
      <xsl:text>(fest datiert: </xsl:text>
      <xsl:value-of select="FestDat"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="AnfEpoche">
      <xsl:value-of select="AnfEpoche"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="AnfKultur">
      <xsl:value-of select="AnfKultur"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="AnfDatZeitraum">
      <xsl:value-of select="AnfDatZeitraum"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="AnfDatJt">
      <xsl:value-of select="AnfDatJt"/>
      <xsl:text>. Jt.</xsl:text>
    </xsl:if>
    <xsl:if test="AnfDatJh">
      <xsl:value-of select="AnfDatJh"/>
      <xsl:text>. Jh.</xsl:text>
    </xsl:if>
    <xsl:value-of select="AnfDatvn"/>
    <xsl:if test="AnfPraezise">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="AnfPraezise"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="AnfTerminus">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="AnfTerminus"/>
      <xsl:text>. </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="explicitTimespan">
    <xsl:if test="AnfPraezise">
      <xsl:variable name="exactDate">
        <xsl:choose>
          <xsl:when test="AnfDatvn = 'v. Chr.'">
            <xsl:value-of select="- AnfPraezise"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="AnfPraezise"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <edm:begin>
        <xsl:value-of select="$exactDate"/>
      </edm:begin>
      <edm:end>
        <xsl:value-of select="$exactDate"/>
      </edm:end>
    </xsl:if>
    <xsl:if test="AnfDatJh">
      <xsl:variable name="beginUnsignedUnqualified" select="100 * (AnfDatJh - 1)"/> 
      <xsl:variable name="endUnsignedUnqualified" select="100 * AnfDatJh"/>
      <xsl:variable name="beginUnqualified">
        <xsl:choose>
          <xsl:when test="AnfDatvn = 'v. Chr.'">
            <xsl:value-of select="-$endUnsignedUnqualified"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$beginUnsignedUnqualified"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="endUnqualified">
        <xsl:choose>
          <xsl:when test="AnfDatvn = 'v. Chr.'">
            <xsl:value-of select="-$beginUnsignedUnqualified"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$endUnsignedUnqualified"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="begin">
        <xsl:choose>
          <xsl:when test="AnfDatZeitraum = '2. Hälfte'">
            <xsl:value-of select="$beginUnqualified + 50"/>
          </xsl:when>
          <xsl:when test="AnfDatZeitraum = 'Ende'">
            <xsl:value-of select="$beginUnqualified + 75"/>
          </xsl:when>
          <xsl:when test="AnfDatZeitraum = 'letztes Drittel'">
            <xsl:value-of select="$beginUnqualified + 66"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$beginUnqualified"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="end">
        <xsl:choose>
          <xsl:when test="AnfDatZeitraum = '1. Hälfte'">
            <xsl:value-of select="$endUnqualified - 50"/>
          </xsl:when>
          <xsl:when test="AnfDatZeitraum = '1. Drittel'">
            <xsl:value-of select="$endUnqualified - 66"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$endUnqualified"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <edm:begin>
        <xsl:value-of select="$begin"/>
      </edm:begin>
      <edm:end>
        <xsl:value-of select="$end"/>
      </edm:end>
    </xsl:if>
  </xsl:template>
  
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
              <xsl:text>https://arachne.dainst.org/entity/</xsl:text>
              <xsl:for-each select=".">
                <xsl:if test="position() = 1">
                  <xsl:value-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <!-- dc:description, id: 386 -->
          <xsl:if test="(../BearbeitungenModern)">
            <dc:description>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:text>BearbeitungenModern: </xsl:text>
              <xsl:for-each select="../BearbeitungenModern[(.)]">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </dc:description>
          </xsl:if>
          <!-- dc:description, id: 15 -->
          <xsl:if test="(../Erhaltungszustand)">
            <dc:description>
              <xsl:attribute name="xml:lang">
                <xsl:text>de</xsl:text>
              </xsl:attribute>
              <xsl:text>Erhaltungszustand: </xsl:text>
              <xsl:for-each select="../Erhaltungszustand[(.)]">
                <xsl:value-of select="."/>
              </xsl:for-each>
            </dc:description>
          </xsl:if>
          <!-- dc:language, id: 23 -->
          <dc:language>
            <xsl:text>de</xsl:text>
          </dc:language>
          <!-- dc:publisher, id: 25 -->
          <dc:publisher>
            <xsl:text>Arachne</xsl:text>
          </dc:publisher>
          <!-- dc:subject, id: 380 -->
          <dc:subject>
            <xsl:attribute name="rdf:resource">
              <xsl:text>http://vocab.getty.edu/aat/300234110</xsl:text>
            </xsl:attribute>
          </dc:subject>
          <!-- dc:subject, id: 389 -->
          <xsl:if test="(../GattungAllgemein)">
            <xsl:for-each select="../GattungAllgemein[(.)]">
              <dc:subject>
                <xsl:attribute name="xml:lang">
                  <xsl:text>de</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </dc:subject>
            </xsl:for-each>
          </xsl:if>
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
          <xsl:if test="(../Herkunft) and (../Herkunft != '?')">
            <xsl:for-each select="../Herkunft[(.) and (. != '?')]">
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
          <xsl:if test="(../Fundort) and (../Fundort[not(contains(., '?'))]) and (../Fundort[not(contains(., 'unbekannt'))])">
            <xsl:for-each select="../Fundort[(.) and (.[not(contains(., '?'))]) and (.[not(contains(., 'unbekannt'))])]">
              <dcterms:spatial>
                <xsl:value-of select="."/>
              </dcterms:spatial>
            </xsl:for-each>
          </xsl:if>
          <!-- dcterms:spatial, id: 101 -->
          <xsl:if test="(../ortsbezug/Gazetteerid)">
            <dcterms:spatial>
              <xsl:if test="(../ortsbezug/Gazetteerid)">
                <xsl:attribute name="rdf:resource">
                  <xsl:text>http://gazetteer.dainst.org/place/</xsl:text>
                  <xsl:for-each select="../ortsbezug/Gazetteerid">
                    <xsl:if test="position() = 1">
                      <xsl:value-of select="."/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
              <xsl:text/>
            </dcterms:spatial>
          </xsl:if>
          <!-- dcterms:temporal, id: 107 -->
          <xsl:if test="(../datierung)">
            <xsl:for-each select="../datierung">
              <dcterms:temporal>
                <xsl:attribute name="rdf:resource">
                  <xsl:text>http://arachne.dainst.org/datierung/</xsl:text>
                  <xsl:value-of select="seriennummer"/>
                </xsl:attribute>
              </dcterms:temporal>
            </xsl:for-each>
          </xsl:if>

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
<!--          
          <xsl:if test="../ortsbezug/Geonamesid">
            <! owl:sameAs, id: 288 > 
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
-->
        </edm:Place>
      </xsl:if>

      <xsl:if test="(../datierung)">
        <xsl:for-each select="../datierung">
          <edm:TimeSpan>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.dainst.org/datierung/</xsl:text>
              <xsl:value-of select="seriennummer"/>
            </xsl:attribute>
            <skos:prefLabel>
              <xsl:call-template name="datierungGesamt"/>
            </skos:prefLabel>
            <xsl:if test="AnfEpoche">
              <dcterms:isPartOf>
                <xsl:value-of select="AnfEpoche"/>
              </dcterms:isPartOf>
            </xsl:if>
            <xsl:call-template name="explicitTimespan"/>
          </edm:TimeSpan>
        </xsl:for-each>
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
                  <xsl:text>https://arachne.dainst.org/entity/</xsl:text>
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
              <xsl:text>http://rightsstatements.org/vocab/InC/1.0/</xsl:text>
            </xsl:attribute>
            <xsl:text/>
          </edm:rights>
        </ore:Aggregation>
      </xsl:if>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
