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
    <xsl:variable name="newUri" select="replace($newUri, 'ß', 'sz')"/>
    <xsl:variable name="newUri" select="replace($newUri, 'é', 'ee')"/>
    <xsl:variable name="newUri" select="replace($newUri, '[^a-z0-9]+', '-')"/>
    <xsl:variable name="newUri" select="replace($newUri, '-$', '')"/>
    <xsl:variable name="newUri" select="encode-for-uri($newUri)"/>
    <xsl:value-of select="$newUri"/>
  </xsl:function>
  
  <xsl:variable name="id" select="record/*/ArachneEntityID"/>
  
  <xsl:function name="crm:createURI">
    <xsl:param name="type"/>
    <xsl:value-of>
      <xsl:text>http://arachne.uni-koeln.de/</xsl:text>
      <xsl:value-of select="$type"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$id"/>
    </xsl:value-of>
  </xsl:function>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="object">
    <crm:E22_Man-Made_Object>
      <xsl:attribute name="rdf:about" select="crm:createURI('artifact')"/>
      <crm:P70i_is_documented_in>
        <xsl:attribute name="rdf:resource" select="crm:createURI('entity')"/>
      </crm:P70i_is_documented_in>
      <xsl:apply-templates select="KurzbeschreibungObjekt"/>
      <xsl:apply-templates select="Erhaltung"/>
      <xsl:apply-templates select="bibliography"/>
      <xsl:apply-templates select="scenes"/>
      <xsl:apply-templates select="function"/>
      <xsl:apply-templates select="ceramic"/>
      <xsl:apply-templates select="images"/>
      <xsl:apply-templates select="findspot"/>
      <xsl:apply-templates select="locations"/>
      <xsl:apply-templates select="dating"/>
      <xsl:apply-templates select="material"/>
      <xsl:apply-templates select="generalCategory"/>
    </crm:E22_Man-Made_Object>
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
  
  <xsl:template match="Erhaltung">
    <crm:P44_has_condition>
      <crm:E3_Condition_State>
        <xsl:attribute name="rdf:about">
          <xsl:text>http://arachne.uni-koeln.de/condition/</xsl:text>
          <xsl:value-of select="concat(parent::node()/@id, '-', crm:fixURI(parent::node()/title))"
          />
        </xsl:attribute>
        <crm:P2_has_type>
          <crm:E55_Type>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.uni-koeln.de/type/condition/</xsl:text>
              <xsl:value-of select="crm:fixURI(.)"/>
            </xsl:attribute>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
          </crm:E55_Type>
        </crm:P2_has_type>
      </crm:E3_Condition_State>
    </crm:P44_has_condition>
  </xsl:template>
  
  <xsl:template match="material">
    <xsl:if test="string-length(.)">
      <crm:P45_consists_of>
        <crm:E57_Material>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://arachne.uni-koeln.de/material/</xsl:text>
            <xsl:value-of select="crm:fixURI(.)"/>
          </xsl:attribute>
          <rdfs:label>
            <xsl:value-of select="."/>
          </rdfs:label>
          <crm:P1_is_identified_by>
            <crm:E41_Appellation>
              <xsl:attribute name="rdf:about">
                <xsl:text>http://arachne.uni-koeln.de/identifier/material/</xsl:text>
                <xsl:value-of select="crm:fixURI(.)"/>
              </xsl:attribute>
              <rdf:value>
                <xsl:value-of select="."/>
              </rdf:value>
            </crm:E41_Appellation>
          </crm:P1_is_identified_by>
        </crm:E57_Material>
      </crm:P45_consists_of>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="generalCategory">
    <xsl:if test="string-length(.)">
      <xsl:for-each select="tokenize(., ' ')">
        <crm:P2_has_type>
          <crm:E55_Type>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.uni-koeln.de/type/objectType/</xsl:text>
              <xsl:value-of select="crm:fixURI(.)"/>
            </xsl:attribute>
            <rdf:value>
              <xsl:value-of select="."/>
            </rdf:value>
            <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#ObjectType"/>
          </crm:E55_Type>
        </crm:P2_has_type>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="bibliography">
    <xsl:apply-templates select="bibItem"/>
  </xsl:template>
  
  <xsl:template match="bibItem">
    <xsl:if test="string-length(.)">
      <crm:P67i_is_referred_to_by>
        <crm:E31_Document>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://arachne.uni-koeln.de/bibitem/</xsl:text>
            <xsl:value-of select="crm:fixURI(citation)"/>
          </xsl:attribute>
          <rdfs:label>
            <xsl:value-of select="normalize-space(.)"/>
          </rdfs:label>
        </crm:E31_Document>
      </crm:P67i_is_referred_to_by>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="scenes">
    <xsl:apply-templates select="scene"/>
  </xsl:template>
  
  <xsl:template match="scene">
    <crm:P56_bears_feature>
      <crm:E25_Man-Made_Feature>
        <xsl:attribute name="rdf:about">
          <xsl:text>http://arachne.uni-koeln.de/feature/</xsl:text>
          <xsl:value-of select="concat(@id, '-', crm:fixURI(title))"/>
        </xsl:attribute>
        <rdfs:label>
          <xsl:value-of select="title"/>
        </rdfs:label>
        <crm:P102_has_title>
          <crm:E35_Title>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.uni-koeln.de/identifier/feature/</xsl:text>
              <xsl:value-of select="crm:fixURI(title)"/>
            </xsl:attribute>
            <rdf:value>
              <xsl:value-of select="title"/>
            </rdf:value>
          </crm:E35_Title>
        </crm:P102_has_title>
        <xsl:apply-templates select="images"/>
      </crm:E25_Man-Made_Feature>
    </crm:P56_bears_feature>
  </xsl:template>
  
  <xsl:template match="images">
    <xsl:apply-templates select="image"/>
  </xsl:template>
  
  <xsl:template match="image">
    <crm:P138i_has_representation>
      <crm:E38_Image>
        <xsl:attribute name="rdf:about">
          <!-- Todo... This is a workaround that needs to be fixed in Arachne -->
          <xsl:text>http://arachne.uni-koeln.de/arachne/images/image.php?key=</xsl:text>
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </crm:E38_Image>
    </crm:P138i_has_representation>
    <xsl:if test="not(matches(., '.*,.*'))">
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
  
  <xsl:template match="findspot">
    <xsl:if test="string-length(.)">
      <crm:P16i_was_used_for>
        <crm:E7_Activity>
          <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
          <crm:P7_took_place_at>
            <crm:E53_Place>
              <xsl:attribute name="rdf:about">
                <xsl:text>http://arachne.uni-koeln.de/place/</xsl:text>
                <xsl:value-of select="crm:fixURI(.)"/>
              </xsl:attribute>
              <crm:P87_is_identified_by>
                <crm:E48_Place_Name>
                  <xsl:attribute name="rdf:about">
                    <xsl:text>http://arachne.uni-koeln.de/identifier/place/</xsl:text>
                    <xsl:value-of select="crm:fixURI(.)"/>
                  </xsl:attribute>
                  <rdf:value>
                    <xsl:value-of select="."/>
                  </rdf:value>
                </crm:E48_Place_Name>
              </crm:P87_is_identified_by>
              <xsl:if test="string-length(parent::node()/findstate)">
                <crm:P89_falls_within>
                  <crm:E53_Place>
                    <xsl:attribute name="rdf:about">
                      <xsl:text>http://arachne.uni-koeln.de/state/</xsl:text>
                      <xsl:value-of select="crm:fixURI(parent::node()/findstate)"/>
                    </xsl:attribute>
                    <crm:P87_is_identified_by>
                      <crm:E48_Place_Name>
                        <xsl:attribute name="rdf:about">
                          <xsl:text>http://arachne.uni-koeln.de/identifier/state/</xsl:text>
                          <xsl:value-of select="crm:fixURI(parent::node()/findstate)"/>
                        </xsl:attribute>
                        <rdf:value>
                          <xsl:value-of select="parent::node()/findstate"/>
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
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="locations">
    <xsl:apply-templates select="location"/>
  </xsl:template>
  
  <xsl:template match="location">
    <xsl:if test="string-length(depository)">
      <xsl:choose>
        <xsl:when test="depositoryType='Fundort'">
          <crm:P16i_was_used_for>
            <crm:E7_Activity>
              <crm:P2_has_type rdf:resource="http://purl.org/NET/Claros/vocab#Event_FindObject"/>
              <crm:P7_took_place_at>
                <crm:E53_Place>
                  <xsl:attribute name="rdf:about">
                    <xsl:text>http://arachne.uni-koeln.de/place/</xsl:text>
                    <xsl:value-of select="crm:fixURI(depository)"/>
                  </xsl:attribute>
                  <crm:P87_is_identified_by>
                    <crm:E48_Place_Name>
                      <xsl:attribute name="rdf:about">
                        <xsl:text>http://arachne.uni-koeln.de/identifier/place/</xsl:text>
                        <xsl:value-of select="crm:fixURI(depository)"/>
                      </xsl:attribute>
                      <rdf:value>
                        <xsl:value-of select="depository"/>
                      </rdf:value>
                    </crm:E48_Place_Name>
                  </crm:P87_is_identified_by>
                  <xsl:if test="string-length(modernPlace)">
                    <crm:P89_falls_within>
                      <crm:E53_Place>
                        <xsl:attribute name="rdf:about">
                          <xsl:text>http://arachne.uni-koeln.de/state/</xsl:text>
                          <xsl:value-of select="crm:fixURI(modernPlace)"/>
                        </xsl:attribute>
                        <crm:P87_is_identified_by>
                          <crm:E48_Place_Name>
                            <xsl:attribute name="rdf:about">
                              <xsl:text>http://arachne.uni-koeln.de/state/identifier/</xsl:text>
                              <xsl:value-of select="crm:fixURI(modernPlace)"/>
                            </xsl:attribute>
                            <rdf:value>
                              <xsl:value-of select="modernPlace"/>
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
              <xsl:attribute name="rdf:about">
                <xsl:text>http://arachne.uni-koeln.de/depository/</xsl:text>
                <xsl:value-of select="concat(OrtID, '-', crm:fixURI(depository))"/>
              </xsl:attribute>
              <crm:P87_is_identified_by>
                <crm:E48_Place_Name>
                  <xsl:attribute name="rdf:about">
                    <xsl:text>http://arachne.uni-koeln.de/identifier/depository/</xsl:text>
                    <xsl:value-of select="concat(OrtID, '-', crm:fixURI(depository))"/>
                  </xsl:attribute>
                  <rdf:value>
                    <xsl:value-of select="depository"/>
                  </rdf:value>
                </crm:E48_Place_Name>
              </crm:P87_is_identified_by>
              <xsl:if test="string-length(modernPlace)">
                <crm:P89_falls_within>
                  <crm:E53_Place>
                    <xsl:attribute name="rdf:about">
                      <xsl:text>http://arachne.uni-koeln.de/place/</xsl:text>
                      <xsl:value-of select="crm:fixURI(modernPlace)"/>
                    </xsl:attribute>
                    <rdfs:label>
                      <xsl:value-of select="modernPlace"/>
                    </rdfs:label>
                    <crm:P87_is_identified_by>
                      <crm:E48_Place_Name>
                        <xsl:attribute name="rdf:about">
                          <xsl:text>http://arachne.uni-koeln.de/identifier/place/</xsl:text>
                          <xsl:value-of select="crm:fixURI(modernPlace)"/>
                        </xsl:attribute>
                        <rdf:value>
                          <xsl:value-of select="modernPlace"/>
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
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="dating">
    <xsl:param name="id"/>
    <xsl:apply-templates select="date">
      <xsl:with-param name="id" select="$id"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="date">
    <xsl:param name="id"/>
    <xsl:choose>
      <xsl:when test="string-length(epochEnd)">
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.uni-koeln.de/event/production/</xsl:text>
              <xsl:value-of select="$id"/>
            </xsl:attribute>
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/timespan/</xsl:text>
                  <xsl:value-of select="crm:fixURI(epochBegin)"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="crm:fixURI(epochEnd)"/>
                </xsl:attribute>
                <claros:starts_within_span>
                  <xsl:attribute name="rdf:resource">
                    <xsl:text>http://arachne.uni-koeln.de/timespan/</xsl:text>
                    <xsl:value-of select="crm:fixURI(epochBegin)"/>
                  </xsl:attribute>
                </claros:starts_within_span>
                <claros:ends_within_span>
                  <xsl:attribute name="rdf:resource">
                    <xsl:text>http://arachne.uni-koeln.de/timespan/</xsl:text>
                    <xsl:value-of select="crm:fixURI(epochEnd)"/>
                  </xsl:attribute>
                </claros:ends_within_span>
              </crm:E52_Time-Span>
            </crm:P4_has_time-span>
          </crm:E12_Production>
        </crm:P108i_was_produced_by>
      </xsl:when>
      <xsl:when test="string-length(epochBegin)">
        <crm:P108i_was_produced_by>
          <crm:E12_Production>
            <xsl:attribute name="rdf:about">
              <xsl:text>http://arachne.uni-koeln.de/event/production/</xsl:text>
              <xsl:value-of select="$id"/>
            </xsl:attribute>
            <crm:P4_has_time-span>
              <crm:E52_Time-Span>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/timespan/</xsl:text>
                  <xsl:value-of select="crm:fixURI(epochBegin)"/>
                </xsl:attribute>
              </crm:E52_Time-Span>
            </crm:P4_has_time-span>
          </crm:E12_Production>
        </crm:P108i_was_produced_by>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="function">
    <xsl:if test="string-length(.)">
      <crm:P103_was_intended_for>
        <crm:E55_Type>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://arachne.uni-koeln.de/type/function/</xsl:text>
            <xsl:value-of select="crm:fixURI(.)"/>
          </xsl:attribute>
          <rdfs:label>
            <xsl:value-of select="."/>
          </rdfs:label>
        </crm:E55_Type>
      </crm:P103_was_intended_for>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="ceramic">
    <xsl:param name="id"/>
    <xsl:if test="string-length(shape)">
      <crm:P41i_was_classified_by>
        <crm:E17_Type_Assignment>
          <xsl:attribute name="rdf:about">
            <xsl:text>http://arachne.uni-koeln.de/type_assignment/</xsl:text>
            <xsl:value-of select="crm:fixURI($id)"/>
          </xsl:attribute>
          <crm:P14_carried_out_by>
            <crm:E39_Actor>
              <rdfs:label>Arachne</rdfs:label>
            </crm:E39_Actor>
          </crm:P14_carried_out_by>
          <xsl:if test="string-length(shape)">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/type/shape/</xsl:text>
                  <xsl:value-of select="crm:fixURI(shape)"/>
                </xsl:attribute>
                <rdfs:label>
                  <xsl:value-of select="shape"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Shape"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
          <xsl:if test="string-length(fabric)">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/type/fabric/</xsl:text>
                  <xsl:value-of select="crm:fixURI(fabric)"/>
                </xsl:attribute>
                <rdfs:label>
                  <xsl:value-of select="fabric"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Fabric"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
          <xsl:if test="string-length(artist)">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/type/artist/</xsl:text>
                  <xsl:value-of select="crm:fixURI(artist)"/>
                </xsl:attribute>
                <rdfs:label>
                  <xsl:value-of select="artist"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Artist"/>
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
          <xsl:if test="string-length(technique)">
            <crm:P42_assigned>
              <crm:E55_Type>
                <xsl:attribute name="rdf:about">
                  <xsl:text>http://arachne.uni-koeln.de/type/technique/</xsl:text>
                  <xsl:value-of select="crm:fixURI(technique)"/>
                </xsl:attribute>
                <rdfs:label>
                  <xsl:value-of select="technique"/>
                </rdfs:label>
                <crm:P127_has_broader_term rdf:resource="http://purl.org/NET/Claros/vocab#Technique"
                />
              </crm:E55_Type>
            </crm:P42_assigned>
          </xsl:if>
        </crm:E17_Type_Assignment>
      </crm:P41i_was_classified_by>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
