<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://purl.org/NET/crm-owl#" xmlns:claros="http://purl.org/NET/Claros/vocab#" version="2.0">

  <xsl:output encoding="UTF-8" indent="yes"/>

  <xsl:function name="crm:ersterBuchstabeGross">
    <xsl:param name="wort"/>
    <xsl:value-of select="concat(upper-case(substring($wort,1,1)), substring($wort,2))"/>
  </xsl:function>

  <xsl:variable name="kategoriename" select="crm:ersterBuchstabeGross(record/*/name())"/>
  <xsl:variable name="datenfelder" select="record/*/*[count(*)=0]"/>
  <xsl:variable name="unterkategorien" select="record/*/*[count(*)>0]"/>

  <xsl:variable name="art">
    <xsl:choose>
      <xsl:when test="$kategoriename='Topographie'">E53_Place</xsl:when>
      <xsl:otherwise>E22_Man-Made_Object</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Funktionen zum Erstellen von URIs -->

  <xsl:function name="crm:fixURI">
    <xsl:param name="uri"/>
    <xsl:variable name="newUri" select="lower-case($uri)"/>
    <xsl:variable name="newUri" select="replace($newUri, 'ä', 'ae')"/>
    <xsl:variable name="newUri" select="replace($newUri, 'ö', 'oe')"/>
    <xsl:variable name="newUri" select="replace($newUri, 'ü', 'ue')"/>
    <xsl:variable name="newUri" select="replace($newUri, 'ß', 'ss')"/>
    <xsl:variable name="newUri" select="replace($newUri, 'é', 'ee')"/>
    <xsl:variable name="newUri" select="replace($newUri, '[^a-z0-9]+', '-')"/>
    <xsl:variable name="newUri" select="replace($newUri, '-$', '')"/>
    <xsl:variable name="newUri" select="encode-for-uri($newUri)"/>
    <xsl:value-of select="$newUri"/>
  </xsl:function>

  <xsl:function name="crm:createArachneURL">
    <!-- URLs für DB-Einträge, die tatsächlich ein Arachne-Ergebnis liefern, 
      wenn man sie anklickt -->
    <xsl:param name="ArachneEntityID"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/entity/</xsl:text>
      <xsl:value-of select="$ArachneEntityID"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createArachneSubURI">
    <!-- URIs für Eigenschaften einzelner Datenbank-Einträge, 
      die (noch) kein Ergebnis liefern, wenn man sie anklickt -->
    <!-- (wird zurzeit nur von objektkeramik verwendet) -->
    <xsl:param name="ArachneEntityID"/>
    <xsl:param name="sub"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createArachneURL($ArachneEntityID)"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$sub"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createArachneRdfURI">
    <!-- Zurzeit ist das dieselbe URI wie bei createArachneURL. 
         Das muss aber nicht immer so bleiben. -->
    <xsl:param name="ArachneEntityID"/>
    <!-- <xsl:value-of select="crm:createArachneSubURI($ArachneEntityID, 'rdf')"/> -->
    <xsl:value-of select="crm:createArachneURL($ArachneEntityID)"/>
  </xsl:function>

  <xsl:function name="crm:createURLwithOldID">
    <!-- wenn es keine ArachneEntityID gibt -->
    <xsl:param name="kategorie"/>
    <xsl:param name="id"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/</xsl:text>
      <xsl:value-of select="$kategorie"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$id"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createSubURLwithOldID">
    <xsl:param name="kategorie"/>
    <xsl:param name="id"/>
    <xsl:param name="sub"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createURLwithOldID($kategorie, $id)"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$sub"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createVocabularyURL">
    <!-- Pseudo-URLs für Vocabulary-Dateien -->
    <xsl:param name="type"/>
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/vocabulary/</xsl:text>
      <xsl:value-of select="$type"/>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="crm:fixURI($context)"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createVocabularySubURL">
    <!-- Pseudo-URLs für Eigenschaften-Werte wie "vollständig", die 
      idealerweise ein begrenztes Vokabular verwenden -->
    <xsl:param name="type"/>
    <xsl:param name="context"/>
    <xsl:param name="sub"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createVocabularyURL($type, $context)"/>
      <xsl:value-of select="$sub"/>
    </xsl:value-of>
  </xsl:function>

  <!-- root -->

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="record/*" mode="kategorie"/>
    </rdf:RDF>
  </xsl:template>

  <!-- Kategorien -->
  <!-- jede Kategorie hat mindestens die Datenfelder ArachneEntityID und Kurzbeschreibung* -->

  <xsl:template match="objekt" mode="kategorie">
    <xsl:comment> Kategorie: objekt </xsl:comment>
    <crm:E22_Man-Made_Object>
      <!-- Datenfelder: mindestens Erhaltung, Fundort/Fundstaat, Funktion, GattungAllgemein, Material -->
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungObjekt"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug, literaturzitat, relief, objektkeramik -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>

  <xsl:template match="bauwerk" mode="kategorie">
    <xsl:comment> Kategorie: bauwerk </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungBauwerk"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>

  <xsl:template match="bauwerksteil" mode="kategorie">
    <xsl:comment> Kategorie: bauwerksteil </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungBauwerksteil"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>

  <xsl:template match="realien" mode="kategorie">
    <xsl:comment> Kategorie: realien </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungRealien"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens marbilder -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>

  <xsl:template match="reproduktion" mode="kategorie">
    <xsl:comment> Kategorie: reproduktion </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungReproduktion"/>
      <xsl:for-each select="objekt|bauwerk|realien">
        <xsl:comment select="concat(' Datenfeld: ', name(), '/ArachneEntityID ')"/>
        <crm:P130_shows_features_of>
          <xsl:attribute name="rdf:resource" select="crm:createArachneURL(ArachneEntityID)"/>
        </crm:P130_shows_features_of>
      </xsl:for-each>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>

  <xsl:template match="sammlungen" mode="kategorie">
    <xsl:comment> Kategorie: sammlungen </xsl:comment>
    <crm:E78_Collection>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungSammlungen"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E78_Collection>
  </xsl:template>

  <xsl:template match="topographie" mode="kategorie">
    <xsl:comment> Kategorie: topographie </xsl:comment>
    <crm:E53_Place>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungTopographie"/>
      <xsl:apply-templates select="$datenfelder" mode="datenfeld"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E53_Place>
  </xsl:template>

  <!-- ignoriere alle Kategorien, die nicht oben explizit aufgezählt sind -->
  <xsl:template match="*" mode="kategorie"/>

  <!-- Datenfelder -->

  <xsl:template match="ArachneEntityID">
    <!-- <xsl:attribute name="rdf:about" select="crm:createArachneURL(.)"/> -->
    <xsl:attribute name="rdf:about" select="crm:createArachneRdfURI(.)"/>
    <crm:P70i_is_documented_in>
      <xsl:attribute name="rdf:resource" select="crm:createArachneURL(.)"/>
    </crm:P70i_is_documented_in>
  </xsl:template>

  <!-- KurzbeschreibungObjekt, KurzbeschreibungBauwerk, etc. -->
  <xsl:template match="*[starts-with(name(), 'Kurzbeschreibung')]">
    <xsl:comment select="concat(' Datenfeld: ', name(), ' ')"/>
    <xsl:choose>
      <xsl:when test="$art='E53_Place'">
        <crm:P87_is_identified_by>
          <crm:E48_Place_Name>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E48_Place_Name>
        </crm:P87_is_identified_by>
      </xsl:when>
      <xsl:otherwise>
        <crm:P102_has_title>
          <crm:E35_Title>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E35_Title>
        </crm:P102_has_title>
      </xsl:otherwise>
    </xsl:choose>
    <rdfs:label>
      <xsl:value-of select="."/>
    </rdfs:label>
  </xsl:template>

  <xsl:template match="Erhaltung" mode="datenfeld">
    <xsl:comment> Datenfeld: Erhaltung </xsl:comment>
    <crm:P44_has_condition>
      <crm:E3_Condition_State>
        <crm:P2_has_type>
          <crm:E55_Type>
            <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('condition', .)"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E55_Type>
        </crm:P2_has_type>
      </crm:E3_Condition_State>
    </crm:P44_has_condition>
  </xsl:template>

  <xsl:template match="Fundort" mode="datenfeld">
    <!-- ruft Fundstaat auf -->
    <xsl:comment> Datenfeld: Fundort </xsl:comment>
    <crm:P16i_was_used_for>
      <crm:E7_Activity>
        <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
        <crm:P7_took_place_at>
          <crm:E53_Place>
            <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', .)"/>
            <crm:P87_is_identified_by>
              <crm:E48_Place_Name>
                <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('place', ., '.German')"/>
                <rdf:value>
                  <xsl:value-of select="."/>
                </rdf:value>
              </crm:E48_Place_Name>
            </crm:P87_is_identified_by>
            <xsl:apply-templates select="../Fundstaat" mode="unterdatenfeld"/>
          </crm:E53_Place>
        </crm:P7_took_place_at>
      </crm:E7_Activity>
    </crm:P16i_was_used_for>
  </xsl:template>

  <xsl:template match="Fundstaat" mode="unterdatenfeld">
    <!-- aufgerufen von Fundort -->
    <xsl:comment> Datenfeld: Fundstaat </xsl:comment>
    <crm:P89_falls_within>
      <crm:E53_Place>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', .)"/>
        <crm:P87_is_identified_by>
          <crm:E48_Place_Name>
            <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('place', ., '.German')"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E48_Place_Name>
        </crm:P87_is_identified_by>
      </crm:E53_Place>
    </crm:P89_falls_within>
  </xsl:template>

  <xsl:template match="Funktion" mode="datenfeld">
    <xsl:comment> Datenfeld: Funktion </xsl:comment>
    <crm:P103_was_intended_for>
      <crm:E55_Type>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('function', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
      </crm:E55_Type>
    </crm:P103_was_intended_for>
  </xsl:template>

  <xsl:template match="GattungAllgemein" mode="datenfeld">
    <xsl:comment> Datenfeld: GattungAllgemein </xsl:comment>
    <xsl:for-each select="tokenize(normalize-space(.), ' ')">
      <crm:P2_has_type>
        <crm:E55_Type>
          <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('objectType', .)"/>
          <rdf:value>
            <xsl:value-of select="."/>
          </rdf:value>
          <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#ObjectType"/>
        </crm:E55_Type>
      </crm:P2_has_type>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="Material" mode="datenfeld">
    <xsl:comment> Datenfeld: Material </xsl:comment>
    <crm:P45_consists_of>
      <crm:E57_Material>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('material', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P1_is_identified_by>
          <crm:E41_Appellation>
            <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('material', ., '.German')"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E41_Appellation>
        </crm:P1_is_identified_by>
      </crm:E57_Material>
    </crm:P45_consists_of>
  </xsl:template>

  <!-- ignoriere alle Datenfelder, die nicht oben explizit aufgezählt sind -->
  <xsl:template match="*" mode="datenfeld"/>

  <!-- zusätzliche Datenfelder aus objektkeramik -->

  <xsl:template match="PS_ObjektkeramikID" mode="datenfeld">
    <!-- verwendet GefaessformenKeramik, WareKeramik, MalerKeramik, MaltechnikKeramik -->
    <xsl:comment> weitere Datenfelder (objektkeramik) </xsl:comment>
    <crm:P41i_was_classified_by>
      <crm:E17_Type_Assignment>
        <xsl:attribute name="rdf:about" select="crm:createArachneSubURI(../ArachneEntityID, 'type_assignment')"/>
        <crm:P14_carried_out_by>
          <crm:E39_Actor>
            <rdfs:label>Arachne</rdfs:label>
          </crm:E39_Actor>
        </crm:P14_carried_out_by>
        <xsl:apply-templates select="../GefaessformenKeramik" mode="objektkeramik"/>
        <xsl:apply-templates select="../WareKeramik" mode="objektkeramik"/>
        <xsl:apply-templates select="../MalerKeramik" mode="objektkeramik"/>
        <xsl:apply-templates select="../MaltechnikKeramik" mode="objektkeramik"/>
      </crm:E17_Type_Assignment>
    </crm:P41i_was_classified_by>
  </xsl:template>

  <xsl:template match="GefaessformenKeramik" mode="objektkeramik">
    <xsl:comment> Datenfeld: GefaessformenKeramik </xsl:comment>
    <crm:P42_assigned>
      <crm:E55_Type>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('shape', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Shape"/>
      </crm:E55_Type>
    </crm:P42_assigned>
  </xsl:template>

  <xsl:template match="WareKeramik" mode="objektkeramik">
    <xsl:comment> Datenfeld: WareKeramik </xsl:comment>
    <crm:P42_assigned>
      <crm:E55_Type>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('fabric', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Fabric"/>
      </crm:E55_Type>
    </crm:P42_assigned>
  </xsl:template>

  <xsl:template match="MalerKeramik" mode="objektkeramik">
    <xsl:comment> Datenfeld: MalerKeramik </xsl:comment>
    <crm:P42_assigned>
      <crm:E55_Type>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('artist', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Artist"/>
      </crm:E55_Type>
    </crm:P42_assigned>
  </xsl:template>

  <xsl:template match="MaltechnikKeramik" mode="objektkeramik">
    <xsl:comment> Datenfeld: MaltechnikKeramik </xsl:comment>
    <crm:P42_assigned>
      <crm:E55_Type>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('technique', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Technique"/>
      </crm:E55_Type>
    </crm:P42_assigned>
  </xsl:template>

  <!-- Unterkategorien -->

  <xsl:template match="datierung" mode="unterkategorie">
    <!-- verwendet AnfEpoche, EndEpoche, seriennummer=PS_DatierungID -->
    <!-- Problem: kein ArachneEntityID ! -->
    <!-- Wenn es weder AnfEpoche noch EndEpoche gibt, wird diese Unterkategorie gar nicht umgesetzt -->
    <xsl:comment> Unterkategorie: datierung </xsl:comment>
    <xsl:choose>
      <xsl:when test="AnfEpoche and EndEpoche">
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <!-- <xsl:attribute name="rdf:about" select="crm:createSubURLwithOldID('production', 'item/datierung', seriennummer)"/> -->
            <!-- <xsl:attribute name="rdf:about" select="crm:createSubURL('production', ..)"/> -->
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about">
                  <!-- Ausnahme -->
                  <xsl:value-of select="crm:createSubURLwithOldID('item/datierung', seriennummer, 'timespan#')"/>
                  <xsl:value-of select="crm:fixURI(AnfEpoche)"/>
                  <xsl:text>--</xsl:text>
                  <xsl:value-of select="crm:fixURI(EndEpoche)"/>
                </xsl:attribute>
                <claros:starts_within_span>
                  <xsl:attribute name="rdf:resource" select="crm:createVocabularyURL('timespan', AnfEpoche)"/>
                </claros:starts_within_span>
                <claros:ends_within_span>
                  <xsl:attribute name="rdf:resource" select="crm:createVocabularyURL('timespan', EndEpoche)"/>
                </claros:ends_within_span>
              </crm:E52_Time-Span>
            </crm:P4_has_time-span>
          </crm:E12_Production>
        </crm:P108i_was_produced_by>
      </xsl:when>
      <xsl:when test="AnfEpoche">
        <!-- wenn es zwar AnfEpoche, aber nicht EndEpoche gibt -->
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <!-- <xsl:attribute name="rdf:about" select="crm:createSubURLwithOldID('production', 'item/datierung', seriennummer)"/> -->
            <!-- <xsl:attribute name="rdf:about" select="crm:createSubURL('production', ..)"/> -->
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('timespan', AnfEpoche)"/>
              </crm:E52_Time-Span>
            </crm:P4_has_time-span>
          </crm:E12_Production>
        </crm:P108i_was_produced_by>
      </xsl:when>
      <!-- (den Fall "EndEpoche ohne AnfEpoche" gibt es nicht) -->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="literaturzitat" mode="unterkategorie">
    <!-- verwendet PS_LiteraturID, DAIRichtlinien -->
    <xsl:comment> Unterkategorie: literaturzitat/literatur </xsl:comment>
    <crm:P67i_is_referred_to_by>
      <crm:E31_Document>
        <!-- <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/literatur', PS_LiteraturID)"/> -->
        <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
        <xsl:if test="DAIRichtlinien">
          <rdfs:label>
            <xsl:value-of select="normalize-space(DAIRichtlinien)"/>
          </rdfs:label>
        </xsl:if>
      </crm:E31_Document>
    </crm:P67i_is_referred_to_by>
  </xsl:template>

  <xsl:function name="crm:sollteThumbnailhaben">
    <xsl:param name="marbilder"/>
    <xsl:choose>
      <xsl:when test="$marbilder/Scannummer and not(contains($marbilder/Scannummer, ','))">ja</xsl:when>
      <xsl:when test="$marbilder/preceding-sibling::marbilder[Scannummer and not(contains(Scannummer, ','))]">nein</xsl:when>
      <xsl:when test="$marbilder/following-sibling::marbilder[Scannummer and not(contains(Scannummer, ','))]">nein</xsl:when>
      <xsl:when test="$marbilder/Scannummer and not($marbilder/preceding-sibling::marbilder[Scannummer])">ja</xsl:when>
      <xsl:otherwise>nein</xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xsl:template match="marbilder" mode="unterkategorie">
    <!-- verwendet Scannummer, seriennummer -->
    <xsl:comment> Unterkategorie: marbilder </xsl:comment>
    <crm:P138i_has_representation>
      <crm:E38_Image>
        <xsl:if test="seriennummer">
          <xsl:choose>
            <!-- falls sinnvoll: Thumbnail-Link -->
            <xsl:when test="crm:sollteThumbnailhaben(.)='ja'">
              <xsl:attribute name="rdf:about">
                <xsl:text>http://arachne.uni-koeln.de/arachne/images/image.php?key=</xsl:text>
                <xsl:value-of select="seriennummer"/>
                <xsl:value-of select="'&amp;method=min&amp;width=141&amp;height=111'" disable-output-escaping="yes"/>
              </xsl:attribute>
              <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Thumbnail"/>
            </xsl:when>
            <!-- sonst: Bild in voller Größe, wird von Claros ignoriert -->
            <xsl:otherwise>
              <xsl:attribute name="rdf:about">
                <xsl:text>http://arachne.uni-koeln.de/arachne/images/image.php?key=</xsl:text>
                <xsl:value-of select="seriennummer"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <crm:P70i_is_documented_in>
          <xsl:attribute name="rdf:resource" select="crm:createArachneURL(ArachneEntityID)"/>
        </crm:P70i_is_documented_in>
      </crm:E38_Image>
    </crm:P138i_has_representation>
  </xsl:template>

  <xsl:template match="ortsbezug" mode="unterkategorie">
    <!-- verwendet ArtOrtsangabe, Aufbewahrungsort, Stadt -->
    <!-- Mit dem Gazetteer wird <crm:E53_Place> entweder zu 
         <crm:E53_Place rdf:resource="Gazetteer-Link"/>, oder das Skript fragt
         den Gazetteer ab und trägt das Ergebnis ein.  -->
    <xsl:comment> Unterkategorie: ortsbezug/ort </xsl:comment>
    <xsl:choose>
      <xsl:when test="parent::topographie">
        <crm:P88i_forms_part_of>
          <crm:E53_Place>
            <!-- <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/ort', PS_OrtID)"/> -->
            <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
            <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
          </crm:E53_Place>
        </crm:P88i_forms_part_of>
      </xsl:when>
      <xsl:when test="ArtOrtsangabe='Fundort'">
        <crm:P16i_was_used_for>
          <crm:E7_Activity>
            <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
            <crm:P7_took_place_at>
              <crm:E53_Place>
                <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
                <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
              </crm:E53_Place>
            </crm:P7_took_place_at>
          </crm:E7_Activity>
        </crm:P16i_was_used_for>
      </xsl:when>
      <xsl:otherwise>
        <crm:P53_has_former_or_current_location>
          <crm:E53_Place>
            <!-- <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/ort', PS_OrtID)"/> -->
            <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
            <xsl:if test="Aufbewahrungsort">
              <xsl:comment> Datenfeld: Aufbewahrungsort </xsl:comment>
              <crm:P87_is_identified_by>
                <crm:E48_Place_Name>
                  <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('depository', Aufbewahrungsort)"/>
                  <rdf:value>
                    <xsl:value-of select="Aufbewahrungsort"/>
                  </rdf:value>
                </crm:E48_Place_Name>
              </crm:P87_is_identified_by>
            </xsl:if>
            <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
          </crm:E53_Place>
        </crm:P53_has_former_or_current_location>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Stadt" mode="ortsbezug">
    <xsl:comment> Datenfeld: Stadt </xsl:comment>
    <crm:P89_falls_within>
      <xsl:if test="../Geonamesid">
        <xsl:comment> (Datenfeld für "rdf:about": Geonamesid) </xsl:comment>
      </xsl:if>
      <crm:E53_Place>
        <xsl:if test="../Geonamesid">
          <xsl:attribute name="rdf:about">
            <xsl:text>http://www.geonames.org/</xsl:text>
            <xsl:value-of select="../Geonamesid"/>
          </xsl:attribute>
        </xsl:if>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P87_is_identified_by>
          <crm:E48_Place_Name>
            <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', .)"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E48_Place_Name>
        </crm:P87_is_identified_by>
      </crm:E53_Place>
    </crm:P89_falls_within>
  </xsl:template>

  <xsl:template match="relief" mode="unterkategorie">
    <!-- verwendet KurzbeschreibungRelief -->
    <xsl:comment> Unterkategorie: relief </xsl:comment>
    <xsl:choose>
      <xsl:when test="parent::objekt">
        <crm:P46_is_composed_of>
          <crm:E22_Man-Made_Object>
            <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
            <xsl:apply-templates select="KurzbeschreibungRelief"/>
          </crm:E22_Man-Made_Object>
        </crm:P46_is_composed_of>
      </xsl:when>
      <xsl:when test="parent::realien">
        <crm:P46i_forms_part_of>
          <crm:E22_Man-Made_Object>
            <xsl:attribute name="rdf:about" select="crm:createArachneURL(ArachneEntityID)"/>
            <xsl:apply-templates select="KurzbeschreibungRelief"/>
          </crm:E22_Man-Made_Object>
        </crm:P46i_forms_part_of>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- ignoriere alle Unterkategorien, die nicht oben explizit aufgezählt sind -->
  <xsl:template match="*" mode="unterkategorie"/>

</xsl:stylesheet>
