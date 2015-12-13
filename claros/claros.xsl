<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:crm="http://purl.org/NET/crm-owl#" 
  xmlns:claros="http://purl.org/NET/Claros/vocab#"
  version="2.0">
 
  <xsl:output encoding="UTF-8" indent="yes"/>
  
  <xsl:variable name="unterkategorien" select="record/*/*[count(*)>0]"/>
 
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
  
  <xsl:function name="crm:createArachneEntityURL">
    <!-- URLs für DB-Einträge, die tatsächlich ein Arachne-Ergebnis liefern, 
      wenn man sie anklickt -->
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/entity/</xsl:text>
      <xsl:value-of select="$context"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createURL">
    <!-- URLs für DB-Einträge, die tatsächlich ein Arachne-Ergebnis liefern, 
      wenn man sie anklickt -->
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/entity/</xsl:text>
      <xsl:value-of select="$context/ArachneEntityID"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createSubURL">
    <!-- Pseudo-URLs für Eigenschaften einzelner Einträge wie "condition", 
      die (noch) kein Ergebnis liefern, wenn man sie anklickt -->
    <xsl:param name="sub"/>
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createURL($context)"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$sub"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createURLwithOldID">
    <!-- wenn es keine ArachneEntityID gibt; ansonsten wie createURL -->
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
    <xsl:param name="sub"/>
    <xsl:param name="kategorie"/>
    <xsl:param name="id"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createURLwithOldID($kategorie, $id)"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$sub"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:function name="crm:createVocabularyURL">
    <!-- Pseudo-URLs für Vocabulary-Dateien -->
    <xsl:param name="sub"/>
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/vocabulary/</xsl:text>
      <xsl:value-of select="$sub"/>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="crm:fixURI($context)"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createVocabularySubURL">
    <!-- Pseudo-URLs für Eigenschaften-Werte wie "vollständig", die 
      idealerweise ein begrenztes Vokabular verwenden -->
    <xsl:param name="sub"/>
    <xsl:param name="context"/>
    <xsl:param name="addition"/>
    <xsl:value-of>
      <xsl:value-of select="crm:createVocabularyURL($sub, $context)"/>
      <xsl:value-of select="$addition"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createContentURL">
    <!-- Pseudo-URLs, die mit Text aus einem Datenfeld eines Objekts 
      erzeugt werden, aber kein begrenztes Vokabular verwenden -->
    <!-- wird evtl. gar nicht verwendet -->
    <xsl:param name="sub"/>
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/</xsl:text>
      <xsl:value-of select="$sub"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="crm:fixURI($context)"/>
    </xsl:value-of>
  </xsl:function>
  
  <!-- root -->
  
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="record/*"/>
    </rdf:RDF>
  </xsl:template>

  <!-- Kategorien -->
  
  <xsl:template match="objekt">
    <xsl:comment> Kategorie: objekt </xsl:comment>
    <crm:E22_Man-Made_Object>
      <!-- Datenfelder -->
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungObjekt"/>
      <xsl:apply-templates select="Erhaltung"/>
      <xsl:apply-templates select="Funktion"/>
      <xsl:apply-templates select="Fundort"/>
      <xsl:apply-templates select="Material"/>
      <xsl:apply-templates select="GattungAllgemein"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug, literaturzitat, relief, objektkeramik -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="bauwerk">
    <xsl:comment> Kategorie: bauwerk </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungBauwerk"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="bauwerksteil">
    <xsl:comment> Kategorie: bauwerksteil </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungBauwerksteil"/>
      <!-- Unterkategorien: mindestens ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="realien">
    <xsl:comment> Kategorie: realien </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungRealien"/>
      <!-- Unterkategorien: mindestens marbilder -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="reproduktion">
    <xsl:comment> Kategorie: reproduktion </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungReproduktion"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="sammlungen">
    <xsl:comment> Kategorie: sammlungen </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungSammlungen"/>
      <!-- Unterkategorien: mindestens ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <xsl:template match="topographie">
    <xsl:comment> Kategorie: topographie </xsl:comment>
    <crm:E22_Man-Made_Object>
      <xsl:apply-templates select="ArachneEntityID"/>
      <xsl:apply-templates select="KurzbeschreibungTopographie"/>
      <!-- Unterkategorien: mindestens datierung, marbilder, ortsbezug -->
      <xsl:apply-templates select="$unterkategorien" mode="unterkategorie"/>
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <!-- Datenfelder -->
  
  <xsl:template match="ArachneEntityID">
    <xsl:attribute name="rdf:about" select="crm:createArachneEntityURL(.)"/>
    <crm:P70i_is_documented_in>
      <xsl:attribute name="rdf:resource" select="crm:createArachneEntityURL(.)"/>
    </crm:P70i_is_documented_in>
  </xsl:template>
  
  <!-- KurzbeschreibungObjekt, KurzbeschreibungBauwerk, etc. -->
  <xsl:template match="*[starts-with(name(), 'Kurzbeschreibung')]">
    <xsl:comment> Datenfeld: Kurzbeschreibung* </xsl:comment>
    <crm:P102_has_title>
      <crm:E35_Title>
        <rdf:value>
          <xsl:value-of select="."/>
        </rdf:value>
      </crm:E35_Title>
    </crm:P102_has_title>
    <rdfs:label>
      <xsl:value-of select="."/>
    </rdfs:label>
  </xsl:template>
  
  <xsl:template match="Erhaltung">
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
  
  <xsl:template match="Fundort">
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
                <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('place', ., 'German')"/>
                <rdf:value>
                  <xsl:value-of select="."/>
                </rdf:value>
              </crm:E48_Place_Name>
            </crm:P87_is_identified_by>
            <xsl:apply-templates select="../Fundstaat"/>
          </crm:E53_Place>
        </crm:P7_took_place_at>
      </crm:E7_Activity>
    </crm:P16i_was_used_for>
  </xsl:template>
  
  <xsl:template match="Fundstaat">
    <!-- aufgerufen von Fundort -->
    <xsl:comment> Datenfeld: Fundstaat </xsl:comment>
    <crm:P89_falls_within>
      <crm:E53_Place>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('state', .)"/>
        <crm:P87_is_identified_by>
          <crm:E48_Place_Name>
            <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('state', ., 'German')"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E48_Place_Name>
        </crm:P87_is_identified_by>
      </crm:E53_Place>
    </crm:P89_falls_within>    
  </xsl:template>
  
  <xsl:template match="Funktion">
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
  
  <xsl:template match="GattungAllgemein">
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
  
  <xsl:template match="Material">
    <xsl:comment> Datenfeld: Material </xsl:comment>
    <crm:P45_consists_of>
      <crm:E57_Material>
        <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('material', .)"/>
        <rdfs:label>
          <xsl:value-of select="."/>
        </rdfs:label>
        <crm:P1_is_identified_by>
          <crm:E41_Appellation>
            <xsl:attribute name="rdf:about" select="crm:createVocabularySubURL('material', ., 'German')"/>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E41_Appellation>
        </crm:P1_is_identified_by>
      </crm:E57_Material>
    </crm:P45_consists_of>
  </xsl:template>
 
  <!-- Unterkategorien -->
  
  <xsl:template match="datierung" mode="unterkategorie">
    <!-- verwendet AnfEpoche, EndEpoche, seriennummer -->
    <!-- Problem: kein ArachneEntityID ! -->
    <!-- Wenn es weder AnfEpoche noch EndEpoche gibt, wird diese Unterkategorie gar nicht umgesetzt -->
    <xsl:comment> Unterkategorie: datierung </xsl:comment>
    <xsl:choose>
      <xsl:when test="EndEpoche">
        <!-- Annahme: dann gibt es auch AnfEpoche -->
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <!-- <xsl:attribute name="rdf:about" select="crm:createSubURLwithOldID('production', 'item/datierung', seriennummer)"/> -->
            <xsl:attribute name="rdf:about" select="crm:createSubURL('production', ..)"/>
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about">
                  <!-- Ausnahme -->
                  <xsl:value-of select="crm:createSubURLwithOldID('timespan', 'item/datierung', seriennummer)"/>
                  <xsl:value-of select="crm:fixURI(AnfEpoche)"/>
                  <xsl:text>-</xsl:text>
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
            <xsl:attribute name="rdf:about" select="crm:createSubURL('production', ..)"/>
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('timespan', AnfEpoche)"/>
              </crm:E52_Time-Span>
            </crm:P4_has_time-span>
          </crm:E12_Production>
        </crm:P108i_was_produced_by>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="literaturzitat" mode="unterkategorie">
    <!-- verwendet PS_LiteraturID, DAIRichtlinien -->
    <xsl:comment> Unterkategorie: literaturzitat </xsl:comment>
    <crm:P67i_is_referred_to_by>
      <crm:E31_Document>
        <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/literaturzitat', PS_LiteraturID)"/>
        <rdfs:label>
          <xsl:value-of select="normalize-space(DAIRichtlinien)"/>
        </rdfs:label>
      </crm:E31_Document>
    </crm:P67i_is_referred_to_by>
  </xsl:template>
  
  <xsl:template match="marbilder" mode="unterkategorie">
    <xsl:comment> Unterkategorie: marbilder </xsl:comment>
    <crm:P138i_has_representation>
      <!-- immer: Arachne-Link -->
      <crm:E38_Image>
        <xsl:attribute name="rdf:about" select="crm:createURL(.)"/>
      </crm:E38_Image>
      <!-- falls sinnvoll: zusätzlicher Thumbnail-Link -->
      <xsl:if test="not(contains(., ','))">
        <crm:E38_Image>
          <xsl:attribute name="rdf:about">
            <!-- Todo... This is a workaround that needs to be fixed in Arachne -->
            <xsl:text>http://arachne.uni-koeln.de/arachne/images/image.php?key=</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:variable name="imageURL"
              select="'&amp;method=min&amp;width=141&amp;height=111'" />
            <xsl:value-of select="$imageURL" disable-output-escaping="yes"/>
          </xsl:attribute>
          <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Thumbnail"/>
        </crm:E38_Image>
      </xsl:if>
    </crm:P138i_has_representation>
  </xsl:template>
  
  <xsl:template match="objektkeramik" mode="unterkategorie">
    <!-- verwendet PS_ObjektkeramikID, GefaessformenKeramik, WareKeramik, MalerKeramik, MaltechnikKeramik -->
    <!-- keine ArachneEntityID ? -->
    <xsl:comment> Unterkategorie: objektkeramik </xsl:comment>
    <xsl:if test="PS_ObjektkeramikID">
      <crm:P41i_was_classified_by>
        <crm:E17_Type_Assignment>
          <xsl:attribute name="rdf:about" select="crm:createSubURL('type_assignment', .)"/>
          <crm:P14_carried_out_by>
            <crm:E39_Actor>
              <rdfs:label>Arachne</rdfs:label>
            </crm:E39_Actor>
          </crm:P14_carried_out_by>
          <xsl:apply-templates select="GefaessformenKeramik" mode="objektkeramik"/>
          <xsl:apply-templates select="WareKeramik" mode="objektkeramik"/>
          <xsl:apply-templates select="MalerKeramik" mode="objektkeramik"/>
          <xsl:apply-templates select="MaltechnikKeramik" mode="objektkeramik"/>
        </crm:E17_Type_Assignment>
      </crm:P41i_was_classified_by>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="GefaessformenKeramik" mode="objektkeramik">
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
  
  <xsl:template match="ortsbezug" mode="unterkategorie">
    <!-- verwendet ArtOrtsangabe, Aufbewahrungsort, Stadt -->
    <xsl:comment> Unterkategorie: ortsbezug </xsl:comment>
    <xsl:choose>
      <xsl:when test="ArtOrtsangabe='Fundort'">
        <crm:P16i_was_used_for>
          <crm:E7_Activity>
            <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
            <crm:P7_took_place_at>
              <crm:E53_Place>
                <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/ortsbezug', PS_OrtID)"/>
                <crm:P87_is_identified_by>
                  <crm:E48_Place_Name>
                    <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', Aufbewahrungsort)"/>
                    <rdf:value>
                      <xsl:value-of select="Aufbewahrungsort"/>
                    </rdf:value>
                  </crm:E48_Place_Name>
                </crm:P87_is_identified_by>
                <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
              </crm:E53_Place>
            </crm:P7_took_place_at>
          </crm:E7_Activity>
        </crm:P16i_was_used_for>
      </xsl:when>
      <xsl:otherwise>
        <crm:P53_has_former_or_current_location>
          <crm:E53_Place>
            <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/ortsbezug', PS_OrtID)"/>
            <crm:P87_is_identified_by>
              <crm:E48_Place_Name>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('depository', Aufbewahrungsort)"/>
                <rdf:value>
                  <xsl:value-of select="Aufbewahrungsort"/>
                </rdf:value>
              </crm:E48_Place_Name>
            </crm:P87_is_identified_by>
            <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
          </crm:E53_Place>
        </crm:P53_has_former_or_current_location>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
<!--  
  <xsl:template match="Aufbewahrungsort" mode="ortsbezug">
    <crm:E53_Place>
      <xsl:attribute name="rdf:about" select="crm:createArachneEntityURL(..)"/>
      <crm:P87_is_identified_by>
        <crm:E48_Place_Name>
          <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', .)"/>
          <rdf:value>
            <xsl:value-of select="."/>
          </rdf:value>
        </crm:E48_Place_Name>
      </crm:P87_is_identified_by>
      <xsl:apply-templates select="Stadt" mode="ortsbezug"/>
    </crm:E53_Place>
  </xsl:template>
-->

  <xsl:template match="Stadt" mode="ortsbezug">
    <crm:P89_falls_within>
      <crm:E53_Place>
        <xsl:attribute name="rdf:about" select="crm:createSubURL('place', ..)"/>
        <rdfs:label>
          <xsl:value-of select="Stadt"/>
        </rdfs:label>
        <crm:P87_is_identified_by>
          <crm:E48_Place_Name>
            <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', .)"/>
            <rdf:value>
              <xsl:value-of select="Stadt"/>
            </rdf:value>
          </crm:E48_Place_Name>
        </crm:P87_is_identified_by>
      </crm:E53_Place>
    </crm:P89_falls_within>   
  </xsl:template>
  
  <xsl:template match="relief" mode="unterkategorie">
    <!-- verwendet KurzbeschreibungRelief -->
    <xsl:comment> Unterkategorie: relief </xsl:comment>
    <crm:P56_bears_feature>
      <crm:E25_Man-Made_Feature>
        <xsl:attribute name="rdf:about" select="crm:createURL(.)"/>
        <rdfs:label>
          <xsl:value-of select="KurzbeschreibungRelief"/>
        </rdfs:label>
        <crm:P102_has_title>
          <crm:E35_Title>
            <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('feature', KurzbeschreibungRelief)"/>
            <rdf:value>
              <xsl:value-of select="KurzbeschreibungRelief"/>
            </rdf:value>
          </crm:E35_Title>
        </crm:P102_has_title>
        <xsl:apply-templates select="images"/> <!-- !!! -->
      </crm:E25_Man-Made_Feature>
    </crm:P56_bears_feature>
  </xsl:template>
  
  <!-- ignoriere alle Unterkategorien, die nicht oben explizit aufgezählt sind -->
  <xsl:template match="*" mode="unterkategorie"/>
  
</xsl:stylesheet>