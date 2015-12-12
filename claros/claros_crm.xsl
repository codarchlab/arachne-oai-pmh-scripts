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
  
  <xsl:function name="crm:createURL">
    <!-- URLs für DB-Einträge, die tatsächlich ein Arachne-Ergebnis liefern, 
      wenn man sie anklickt -->
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/entity/</xsl:text>
      <xsl:value-of select="$context/ArachneEntityID"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="crm:createURLwithOldID">
    <!-- wenn es keine ArachneEntityID gibt; ansonsten wie createURL -->
    <xsl:param name="sub"/>
    <xsl:param name="id"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/</xsl:text>
      <xsl:value-of select="$sub"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$id"/>
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
    <xsl:param name="sub"/>
    <xsl:param name="context"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/</xsl:text>
      <xsl:value-of select="$sub"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="crm:fixURI($context)"/>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="record/*"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="objekt">
    <crm:E22_Man-Made_Object>
      <xsl:attribute name="rdf:about" select="crm:createURL(.)"/>
      <crm:P70i_is_documented_in>
        <xsl:attribute name="rdf:resource" select="crm:createURL(.)"/>
      </crm:P70i_is_documented_in>
      <!-- Teil 1 -->
      <xsl:apply-templates select="KurzbeschreibungObjekt"/>
      <xsl:apply-templates select="Erhaltung"/>
      <xsl:apply-templates select="Funktion"/>
      <xsl:apply-templates select="Fundort"/>
      <xsl:apply-templates select="Material"/>
      <xsl:apply-templates select="GattungAllgemein"/>
      <!-- Teil 2 -->
      <xsl:apply-templates select="literaturzitat" mode="teil2"/>
      <xsl:apply-templates select="relief" mode="teil2"/>
      <xsl:apply-templates select="marbilder" mode="teil2"/>
      <xsl:apply-templates select="ortsbezug" mode="teil2"/>
      <xsl:apply-templates select="datierung" mode="teil2"/>      
      <xsl:apply-templates select="objektkeramik" mode="teil2"/> <!-- stimmt das? -->
    </crm:E22_Man-Made_Object>
  </xsl:template>
  
  <!-- Teil 1 -->
  
  <xsl:template match="Erhaltung">
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
  
  <xsl:template match="KurzbeschreibungObjekt">
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
  
  <xsl:template match="Material">
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
  
  <!-- Teil 2 -->
  
  <xsl:template match="datierung" mode="teil2">
    <!-- verwendet AnfEpoche, EndEpoche -->
    <!-- Problem: kein ArachneEntityID ! -->
    <xsl:choose>
      <xsl:when test="EndEpoche">
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <xsl:attribute name="rdf:about" select="crm:createSubURL('production', .)"/>
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about">
                  <!-- Ausnahme -->
                  <xsl:value-of select="crm:createSubURL('timespan', .)"/>
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
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <xsl:attribute name="rdf:about" select="crm:createSubURL('production', .)"/>
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
  
  <xsl:template match="literaturzitat" mode="teil2">
    <!-- verwendet DAIRichtlinien -->
    <crm:P67i_is_referred_to_by>
      <crm:E31_Document>
        <xsl:attribute name="rdf:about" select="crm:createURLwithOldID('item/literatur', PS_LiteraturID)"/>
        <rdfs:label>
          <xsl:value-of select="normalize-space(DAIRichtlinien)"/>
        </rdfs:label>
      </crm:E31_Document>
    </crm:P67i_is_referred_to_by>
  </xsl:template>
  
  <xsl:template match="marbilder" mode="teil2">
    <crm:P138i_has_representation>
      <crm:E38_Image>
        <xsl:attribute name="rdf:about" select="crm:createURL(.)"/>
      </crm:E38_Image>
    </crm:P138i_has_representation>
    <xsl:if test="not(contains(., ','))">
      <crm:P138i_has_representation>
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
      </crm:P138i_has_representation>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="objektkeramik" mode="teil2">
    <!-- verwendet PS_ObjektkeramikID, GefaessformenKeramik, WareKeramik, MalerKeramik, MaltechnikKeramik -->
    <!-- Problem: kein ArachneEntityID ?? -->
    <xsl:if test="PS_ObjektkeramikID">
      <crm:P41i_was_classified_by>
        <crm:E17_Type_Assignment>
          <xsl:attribute name="rdf:about" select="crm:createSubURL('type_assignment', .)"/>
          <crm:P14_carried_out_by>
            <crm:E39_Actor>
              <rdfs:label>Arachne</rdfs:label>
            </crm:E39_Actor>
          </crm:P14_carried_out_by>
          <xsl:if test="GefaessformenKeramik">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('shape', GefaessformenKeramik)"/>
                <rdfs:label>
                  <xsl:value-of select="GefaessformenKeramik"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Shape"/>
              </crm:E55_Type>
            </crm:P42_assigned>            
          </xsl:if>
          <xsl:if test="WareKeramik">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('fabric', WareKeramik)"/>
                <rdfs:label>
                  <xsl:value-of select="WareKeramik"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Fabric"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
          <xsl:if test="MalerKeramik">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('artist', MalerKeramik)"/>
                <rdfs:label>
                  <xsl:value-of select="MalerKeramik"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Artist"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
          <xsl:if test="MaltechnikKeramik">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('technique', MaltechnikKeramik)"/>
                <rdfs:label>
                  <xsl:value-of select="technique"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Technique"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
        </crm:E17_Type_Assignment>
      </crm:P41i_was_classified_by>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="ortsbezug" mode="teil2">
    <!-- verwendet ArtOrtsangabe, Aufbewahrungsort, Stadt -->
    <xsl:choose>
      <xsl:when test="ArtOrtsangabe='Fundort'">
        <crm:P16i_was_used_for>
          <crm:E7_Activity>
            <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
            <crm:P7_took_place_at>
              <crm:E53_Place>
                <xsl:attribute name="rdf:about" select="crm:createURL(.)"/>
                <crm:P87_is_identified_by>
                  <crm:E48_Place_Name>
                    <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', Aufbewahrungsort)"/>
                    <rdf:value>
                      <xsl:value-of select="Aufbewahrungsort"/>
                    </rdf:value>
                  </crm:E48_Place_Name>
                </crm:P87_is_identified_by>
                <xsl:if test="Stadt">
                  <crm:P89_falls_within>
                    <crm:E53_Place>
                      <xsl:attribute name="rdf:about" select="crm:createSubURL('state', .)"/>
                      <crm:P87_is_identified_by>
                        <crm:E48_Place_Name>
                          <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('state', Stadt)"/>
                          <rdf:value>
                            <xsl:value-of select="Stadt"/>
                          </rdf:value>
                        </crm:E48_Place_Name>
                      </crm:P87_is_identified_by>
                    </crm:E53_Place>
                  </crm:P89_falls_within>
                </xsl:if>
              </crm:E53_Place>
            </crm:P7_took_place_at>
          </crm:E7_Activity>
        </crm:P16i_was_used_for>
      </xsl:when>
      <xsl:otherwise>
        <crm:P53_has_former_or_current_location>
          <crm:E53_Place>
            <xsl:attribute name="rdf:about" select="crm:createSubURL('depository', .)"/>
            <crm:P87_is_identified_by>
              <crm:E48_Place_Name>
                <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('depository', Aufbewahrungsort)"/>
                <rdf:value>
                  <xsl:value-of select="Aufbewahrungsort"/>
                </rdf:value>
              </crm:E48_Place_Name>
            </crm:P87_is_identified_by>
            <xsl:if test="Stadt">
              <crm:P89_falls_within>
                <crm:E53_Place>
                  <xsl:attribute name="rdf:about" select="crm:createSubURL('place', .)"/>
                  <rdfs:label>
                    <xsl:value-of select="Stadt"/>
                  </rdfs:label>
                  <crm:P87_is_identified_by>
                    <crm:E48_Place_Name>
                      <xsl:attribute name="rdf:about" select="crm:createVocabularyURL('place', Stadt)"/>
                      <rdf:value>
                        <xsl:value-of select="Stadt"/>
                      </rdf:value>
                    </crm:E48_Place_Name>
                  </crm:P87_is_identified_by>
                </crm:E53_Place>
              </crm:P89_falls_within>
            </xsl:if>
          </crm:E53_Place>
        </crm:P53_has_former_or_current_location>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="relief" mode="teil2">
    <!-- verwendet KurzbeschreibungRelief -->
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
  
</xsl:stylesheet>
