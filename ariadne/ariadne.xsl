<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ara="http://www.arachne.uni-koeln.de/formats/arachne/"
    
    xmlns:acdm="http://registry.ariadne-infrastructure.eu/" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:dbpedia-owl="http://dbpedia.org/ontology/" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/" 
    xmlns:dcmitype="http://purl.org/dc/dcmitype/" 
    xmlns:vcard="http://www.w3.org/2006/vcard/ns#" 
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:dcat="http://www.w3.org/ns/dcat#" 
    xmlns:aat="http://vocab.getty.edu/aat/" 
    xmlns:owl="http://www.w3.org/2002/07/owl#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    
    exclude-result-prefixes="ara xs">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- empty parts in a concrete dataset:
         yes: remove empty parts
         no (and everything else): don't remove empty parts
    -->
    <xsl:variable name="removeEmptyFields">yes</xsl:variable>
       
  
    <xsl:param name="workingDirectory"/>
    
    
    <!-- Das Skript nimmt an, dass alle Datensätze in einer Datei 
         aus derselben Kategorie stammen
    -->
    <xsl:variable name="kategorie" select="records/*[1]/name()" as="xs:string"/>
    
    <xsl:variable name="buchtitel">
        <xsl:choose>
            <xsl:when test="$kategorie='buch'">
                <xsl:copy-of select="doc(concat($workingDirectory,'/mets/kurz/gesamt.xml'))"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="epochen">
        <xsl:copy-of select="doc(concat($workingDirectory,'/origin/ARIADNE-chronology-table-final-kurz.xml'))"/>
    </xsl:variable>
    
    <xsl:variable name="blueprintName">
        <xsl:text>arachne-</xsl:text>
        <xsl:value-of select="$kategorie"/>
        <xsl:text>-blueprint.xml</xsl:text>
    </xsl:variable>
    
    <xsl:variable name="blueprint" select="doc($blueprintName)"/>
    
    <xsl:variable name="ergebnisMitLeerenFeldern">
        <acdm:ariadne>
            <xsl:for-each select="records/*">
                <xsl:variable name="originalDataset" select="."/>
                <xsl:for-each select="$blueprint/acdm:ariadne/*">
                    <xsl:call-template name="traverseTheBlueprint">
                        <xsl:with-param name="currentDataset" select="$originalDataset"/>
                    </xsl:call-template>                    
                </xsl:for-each>
            </xsl:for-each>
        </acdm:ariadne>
    </xsl:variable>
    
    <!-- main: note that the script runs through the nodes of the mapping file, and only then through the actual dataset! -->

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$removeEmptyFields='yes'">
                <xsl:apply-templates select="$ergebnisMitLeerenFeldern" mode="entferneLeereFelder"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$ergebnisMitLeerenFeldern"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- step 1: create the complete result, including empty parts -->
    
    <xsl:function name="ara:fillInZeroes">
        <!-- was für eine schreckliche Funktion -->
        <!-- Achtung: $content muss die Form -?\d+ haben, sonst passiert Unsinn -->
        <xsl:param name="content"/>
   
        <xsl:variable name="vorzeichen">
            <xsl:choose>
                <xsl:when test="starts-with($content, '-')">
                    <xsl:text>-</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="zahl">
            <xsl:choose>
                <xsl:when test="starts-with($content, '-')">
                    <xsl:value-of select="substring-after($content, '-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$content"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$vorzeichen"/>
        <xsl:choose>
            <xsl:when test="string-length($zahl)=1">
                <xsl:text>000</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($zahl)=2">
                <xsl:text>00</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($zahl)=3">
                <xsl:text>0</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:value-of select="$zahl"/>
        
    </xsl:function>
    
    <xsl:function name="ara:standardizeDate">
        <xsl:param name="content"/>
        <xsl:param name="type"/>
        
        <xsl:if test="matches($content, '^-?\d+$')">
            <xsl:value-of select="ara:fillInZeroes($content)"/>
            <xsl:choose>
                <xsl:when test="$type='begin'">
                    <xsl:text>-01-01</xsl:text>
                </xsl:when>
                <xsl:when test="$type='end'">
                    <xsl:text>-12-31</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    
    <xsl:template name="traverseTheBlueprint">
        <xsl:param name="currentDataset"/>
        
 
        <xsl:choose>

            <xsl:when test="self::dcterms:title and $kategorie='inschrift'">
                <dcterms:title>
                    <xsl:choose>
                        <xsl:when test="$currentDataset/InschriftOhneKlammern">
                            <xsl:value-of select="$currentDataset/InschriftOhneKlammern"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Inschrift</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </dcterms:title>
            </xsl:when>
            
            <xsl:when test="self::dcterms:title and $kategorie='buch'">
                <dcterms:title>
                    <xsl:value-of select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/title"/>
                </dcterms:title>
            </xsl:when>
            
            <xsl:when test="self::dc:description and $kategorie='inschrift'">
                <dc:description>
                    <xsl:choose>
                        <xsl:when test="$currentDataset/Inschrift">
                            <xsl:value-of select="$currentDataset/Inschrift"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>[no text given]</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </dc:description>
            </xsl:when>
            
            <xsl:when test="self::dc:description and $kategorie='buch'">
                <dc:description>
                    <xsl:value-of select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/description"/>
                </dc:description>
            </xsl:when>
            
            <xsl:when test="self::dcterms:isPartOf and $kategorie='inschrift'">
                <dcterms:isPartOf>dat:509782</dcterms:isPartOf>
                <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P128.carries objekt ')]">
                    <dcterms:isPartOf>
                        <xsl:text>http://arachne.dainst.org/entity/</xsl:text>
                        <xsl:value-of select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                    </dcterms:isPartOf>
                </xsl:for-each>
                <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P128.carries bauwerk ')]">
                    <dcterms:isPartOf>
                        <xsl:text>http://arachne.dainst.org/entity/</xsl:text>
                        <xsl:value-of select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                    </dcterms:isPartOf>
                </xsl:for-each>
            </xsl:when>
            
            <xsl:when test="self::dc:language and $kategorie='buch'">
                <dc:language>
                    <xsl:value-of select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/language"/>
                </dc:language>
            </xsl:when>
            
            
            <xsl:when test="self::acdm:temporal">
                <xsl:variable name="temporal">
                    <xsl:choose>
           
                        <xsl:when test="$kategorie='buch'">
                            <acdm:temporal>
                                <acdm:from>
                                    <xsl:value-of select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/year"/>
                                </acdm:from>
                                <acdm:until>
                                    <xsl:value-of select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/year"/>
                                </acdm:until>
                            </acdm:temporal>
                        </xsl:when>
           
                        <xsl:when test="$kategorie='sammlungen'">
                            <acdm:temporal>
                                <acdm:from>
                                    <xsl:value-of select="$currentDataset/EntstehungDatum"/>
                                </acdm:from>
                                <acdm:until/>
                            </acdm:temporal>
                        </xsl:when>
             
                        <xsl:when test="$kategorie='inschrift'">
                            <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P128.carries objekt ')]">
                                <xsl:variable name="carrierEntity" select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                                <xsl:variable name="carrier" select="ara:getConnectedDataset('objekt', $carrierEntity)"/>
                                
                                <xsl:for-each select="$carrier/record/objekt/verknuepfung[starts-with(text(), 'P8I.witnessed datierung')]">
                                    <xsl:variable name="seriennummer" select="substring-after(text(), 'http://arachne.uni-koeln.de/item/datierung/')"/>
                                    <xsl:variable name="datierungDoc" select="ara:getConnectedDataset('datierung', $seriennummer)"/>
                                    <acdm:temporal>
                                        <acdm:periodName>
                                            <skos:Concept>
                                                <skos:prefLabel>
                                                    <xsl:value-of select="$datierungDoc/record/datierung/AnfEpoche"/>
                                                </skos:prefLabel>
                                            </skos:Concept>
                                        </acdm:periodName>
                                        <acdm:from>
                                            <xsl:value-of select="$datierungDoc/record/datierung/AnfPraezise"/>
                                        </acdm:from>
                                        <acdm:until>
                                            <xsl:value-of select="$datierungDoc/record/datierung/EndPraezise"/>
                                        </acdm:until>
                                    </acdm:temporal>
                                    <acdm:temporal>
                                        <acdm:periodName>
                                            <skos:Concept>
                                                <skos:prefLabel>
                                                    <xsl:value-of select="$datierungDoc/record/datierung/EndEpoche"/>
                                                </skos:prefLabel>
                                            </skos:Concept>
                                           <acdm:from/>
                                            <acdm:until/>
                                        </acdm:periodName>
                                    </acdm:temporal>
                                </xsl:for-each>
                            </xsl:for-each>                
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P8I.witnessed datierung')]">
                                <xsl:variable name="seriennummer" select="substring-after(text(), 'http://arachne.uni-koeln.de/item/datierung/')"/>
                                <xsl:variable name="datierungDoc" select="ara:getConnectedDataset('datierung', $seriennummer)"/>
                                <acdm:temporal>
                                    <acdm:periodName>
                                        <skos:Concept>
                                            <skos:prefLabel>
                                                <xsl:value-of select="$datierungDoc/record/datierung/AnfEpoche"/>
                                            </skos:prefLabel>
                                        </skos:Concept>
                                    </acdm:periodName>
                                    <acdm:from>
                                        <xsl:value-of select="$datierungDoc/record/datierung/AnfPraezise"/>
                                    </acdm:from>
                                    <acdm:until>
                                        <xsl:value-of select="$datierungDoc/record/datierung/EndPraezise"/>
                                    </acdm:until>
                                </acdm:temporal>
                                <acdm:temporal>
                                    <acdm:periodName>
                                        <skos:Concept>
                                            <skos:prefLabel>
                                                <xsl:value-of select="$datierungDoc/record/datierung/EndEpoche"/>
                                            </skos:prefLabel>
                                        </skos:Concept>
                                        <acdm:from/>
                                        <acdm:until/>
                                    </acdm:periodName>
                                </acdm:temporal>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
  
                <!-- postprocessing, um die Daten valide zu machen -->
                <xsl:for-each select="$temporal/acdm:temporal">
                    <xsl:choose>
                        <xsl:when test="acdm:periodName/skos:prefLabel/text()">
                            <xsl:choose>
                                <xsl:when test="ara:standardizeDate(acdm:from/text(), 'begin') or ara:standardizeDate(acdm:until/text(), 'end')">
                                    <!-- Fall 1 -->
                                    <acdm:temporal>
                                        <xsl:copy-of select="acdm:periodName"/>
                                        <acdm:from>
                                            <xsl:value-of select="ara:standardizeDate(acdm:from/text(), 'begin')"/>
                                        </acdm:from>
                                        <acdm:until>
                                            <xsl:value-of select="ara:standardizeDate(acdm:until/text(), 'end')"/>
                                        </acdm:until>
                                    </acdm:temporal>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Fall 2 -->
                                    <acdm:temporal>
                                        <xsl:copy-of select="acdm:periodName"/>
                                        <xsl:variable name="period" select="acdm:periodName/skos:prefLabel/text()"/>
                                        <xsl:for-each select="$epochen/periods/period[lower-case(name/text())=$period or lower-case(name2/text())=$period]">
                                            <acdm:from>
                                                <xsl:value-of select="ara:standardizeDate(von/text(), 'begin')"/>
                                            </acdm:from>
                                            <acdm:until>
                                                <xsl:value-of select="ara:standardizeDate(bis/text(), 'end')"/>
                                            </acdm:until>
                                        </xsl:for-each>
                                    </acdm:temporal>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="ara:standardizeDate(acdm:from/text(), 'begin') or ara:standardizeDate(acdm:until/text(), 'end')">
                            <!-- Fall 3 -->
                            <acdm:temporal>
                                <acdm:from>
                                    <xsl:value-of select="ara:standardizeDate(acdm:from/text(), 'begin')"/>
                                </acdm:from>
                                <acdm:until>
                                    <xsl:value-of select="ara:standardizeDate(acdm:until/text(), 'end')"/>
                                </acdm:until>
                            </acdm:temporal>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Fall 4 -->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>                 
                
            </xsl:when>
 
 
            <xsl:when test="self::acdm:spatial">
                <xsl:choose>
                    <xsl:when test="$kategorie='inschrift'">
                        <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P128.carries objekt ')]">
                            <xsl:variable name="carrierEntity" select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                            <xsl:variable name="carrier" select="ara:getConnectedDataset('objekt', $carrierEntity)"/>
                            
                            <xsl:for-each select="$carrier/record/objekt/verknuepfung[starts-with(text(), 'P53.has_former_or_current_location ort') or starts-with(text(), 'P59I.is_located_on_or_within ort')]">
                                <xsl:variable name="entity" select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                                <xsl:variable name="ortDoc" select="ara:getConnectedDataset('ort', $entity)"/>
                                <acdm:spatial>
                                    <acdm:placeName>
                                        <xsl:value-of select="$ortDoc/record/ort/Stadt"/>
                                    </acdm:placeName>
                                    <acdm:country>
                                        <xsl:value-of select="$ortDoc/record/ort/Land"/>
                                    </acdm:country>
                                </acdm:spatial>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:when test="$currentDataset/verknuepfung[starts-with(text(), 'P53.has_former_or_current_location ort') or starts-with(text(), 'P59I.is_located_on_or_within ort')]">
                        <xsl:for-each select="$currentDataset/verknuepfung[starts-with(text(), 'P53.has_former_or_current_location ort') or starts-with(text(), 'P59I.is_located_on_or_within ort')]">
                            <xsl:variable name="entity" select="substring-after(text(), 'http://arachne.uni-koeln.de/entity/')"/>
                            <xsl:variable name="ortDoc" select="ara:getConnectedDataset('ort', $entity)"/>
                            <acdm:spatial>
                                <acdm:placeName>
                                    <xsl:value-of select="$ortDoc/record/ort/Stadt"/>
                                </acdm:placeName>
                                <acdm:country>
                                    <xsl:value-of select="$ortDoc/record/ort/Land"/>
                                </acdm:country>
                            </acdm:spatial>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:otherwise/>
                    
                </xsl:choose>                
            </xsl:when>
 
             
            <xsl:when test="self::acdm:hasAttachedDocuments">
                <xsl:copy>
                    <xsl:text>http://arachne.dainst.org/entity/</xsl:text>
                    <xsl:value-of select="$currentDataset/ArachneEntityID"/>
                    <xsl:text>/images</xsl:text>
                </xsl:copy>
            </xsl:when>

            <xsl:when test="self::acdm:originalId or self::dcat:landingPage">
                <xsl:copy>
                    <xsl:text>http://arachne.dainst.org/entity/</xsl:text>
                    <xsl:value-of select="$currentDataset/ArachneEntityID"/>
                </xsl:copy>
            </xsl:when>
            
             <xsl:when test="self::dcterms:extent">
                <xsl:copy>
                    <xsl:value-of select="count($currentDataset/verknuepfung[starts-with(text(), 'P46.is_composed_of objekt') or starts-with(text(), 'P53I.is_former_or_current_location_of objekt')])"/>
                </xsl:copy>
            </xsl:when>
            
            <xsl:when test="self::acdm:xmlDoc">
                <xsl:copy>
                    <xsl:text>http://arachne.dainst.org/data/entity/</xsl:text>
                    <xsl:value-of select="$currentDataset/ArachneEntityID"/>
                </xsl:copy>
            </xsl:when>


            <xsl:when test="self::acdm:nativeSubject">
                <xsl:variable name="nativeSubjects">
                    <xsl:choose>
                        <xsl:when test="$kategorie='buch' and $buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/classification">
                            <xsl:for-each select="$buchtitel/buecher/buch[@entity=$currentDataset/ArachneEntityID]/classification">
                                <skos:Concept>
                                    <skos:prefLabel>
                                        <xsl:value-of select="text()"/>
                                    </skos:prefLabel>
                                </skos:Concept>
                            </xsl:for-each>                            
                        </xsl:when>
                        <xsl:when test="$kategorie='bauwerk' and $currentDataset/Gebaeudetyp">
                            <skos:Concept>
                                <skos:prefLabel>
                                    <xsl:value-of select="$currentDataset/Gebaeudetyp"/>
                                </skos:prefLabel>
                            </skos:Concept>
                        </xsl:when>
                        <xsl:when test="$kategorie='topographie' and $currentDataset/TopographieTypus">
                            <skos:Concept>
                                <skos:prefLabel>
                                    <xsl:value-of select="$currentDataset/TopographieTypus"/>
                                </skos:prefLabel>
                            </skos:Concept>
                        </xsl:when>
                        <xsl:when test="$kategorie='sammlungen' and $currentDataset/Sammlungskategorie">
                            <skos:Concept>
                                <skos:prefLabel>
                                    <xsl:value-of select="$currentDataset/Sammlungskategorie"/>
                                </skos:prefLabel>
                            </skos:Concept>
                        </xsl:when>
                        <xsl:when test="$kategorie='gruppen' and $currentDataset/ArtDerGruppe">
                            <skos:Concept>
                                <skos:prefLabel>
                                    <xsl:value-of select="$currentDataset/ArtDerGruppe"/>
                                </skos:prefLabel>
                            </skos:Concept>
                        </xsl:when>
                        <xsl:otherwise>
                            <skos:Concept>
                                <skos:prefLabel>
                                    <xsl:value-of select="$kategorie"/>
                                </skos:prefLabel>
                            </skos:Concept>                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:for-each select="$nativeSubjects/skos:Concept">
                    <xsl:choose>
                        <xsl:when test="matches(text(), ';')">
                            <xsl:for-each select="tokenize(text(), ';')">
                                <acdm:nativeSubject>
                                    <skos:Concept>
                                        <skos:prefLabel>
                                            <xsl:value-of select="."/>
                                        </skos:prefLabel>
                                    </skos:Concept>                            
<!--
                                    <skos:closeMatch rdf:resource=""/>
                                    <skos:exactMatch rdf:resource=""/>
                                    <skos:narrowMatch rdf:resource=""/>
                                    <skos:relatedMatch rdf:resource=""/>
-->
                                </acdm:nativeSubject>                                
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <acdm:nativeSubject>
                                <xsl:copy-of select="."/>
<!--    
                                <skos:closeMatch rdf:resource=""/>
                                <skos:exactMatch rdf:resource=""/>
                                <skos:narrowMatch rdf:resource=""/>
                                <skos:relatedMatch rdf:resource=""/>
-->   
                            </acdm:nativeSubject>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            
         
             <!-- 1. nodes with subnodes -->

            <xsl:when test="*">                
                <xsl:copy>
                    <xsl:call-template name="processAttributes">
                        <xsl:with-param name="currentDataset" select="$currentDataset"/>
                    </xsl:call-template>
                    <xsl:for-each select="*">
                        <xsl:call-template name="traverseTheBlueprint">
                            <xsl:with-param name="currentDataset" select="$currentDataset"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:when>

            <!-- 2. nodes without subnodes -->
            <!-- since nodes with subnodes have already been taken care of, we can assume count(text()) <= 1,
                 i.e. nodes that can have proper content -->

            <xsl:when test="text()=''">
                <xsl:copy>
                    <xsl:call-template name="processAttributes">
                        <xsl:with-param name="currentDataset" select="$currentDataset"/>
                    </xsl:call-template>
                </xsl:copy>
            </xsl:when>
            
            <!-- 2.1 text is fixed -->

            <xsl:when test="not(starts-with(text(), '='))">
                <xsl:copy>
                    <xsl:call-template name="processAttributes">
                        <xsl:with-param name="currentDataset" select="$currentDataset"/>
                    </xsl:call-template>
                    <xsl:variable name="datafield" select="text()"/>
                    <xsl:value-of select="$currentDataset/*[name()=$datafield]"/>
                </xsl:copy>
            </xsl:when>

            <!-- 2.2 text is a datafield -->

            <xsl:otherwise>
                <xsl:variable name="text" select="substring-after(text(), '=')"/>
                <xsl:copy>
                    <xsl:call-template name="processAttributes">
                        <xsl:with-param name="currentDataset" select="$currentDataset"/>
                    </xsl:call-template>
                    <xsl:value-of select="$text"/>
                 </xsl:copy>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <xsl:template name="processAttributes">
        <xsl:param name="currentDataset"/>

        <xsl:for-each select="@*">
            <xsl:choose>
                <xsl:when test="name()='rdf:about'">
                    <xsl:attribute name="rdf:about" select="'x'"/>
                </xsl:when>

            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <xsl:function name="ara:getConnectedDataset">
        <xsl:param name="category"/>
        <xsl:param name="id"/>

        <!-- mindestens bei datierung gibt es auch einstellige IDs -->
        <xsl:variable name="subfolder">
            <xsl:choose>
                <xsl:when test="string-length($id)>1">
                    <xsl:value-of select="substring($id, string-length($id)-1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0</xsl:text>
                    <xsl:value-of select="$id"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="pathname" select="concat('origin/',$category,'/',$subfolder)"/>
        <xsl:variable name="filename" select="concat($category,'-',$id,'.xml')"/>
        <xsl:variable name="filepath" select="concat($workingDirectory,$pathname,'/',$filename)"/>
                
        <xsl:choose>
            <xsl:when test="doc-available($filepath)">
                <xsl:copy-of select="doc($filepath)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>error: file </xsl:text>
                <xsl:value-of select="$filepath"/>
                <xsl:text> not found</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- step 2: remove empty parts from the result from step 1 -->
    
    <xsl:template match="*" mode="entferneLeereFelder">
        <xsl:choose>
            <xsl:when test="(self::acdm:creator or self::acdm:contributor) and not(foaf:name/text())"/>

            <xsl:when test="descendant-or-self::*[count(text())=1 or @*[. != '']]">
                <xsl:copy>
                    <xsl:copy-of select="@*[. != '']"/>
                    <xsl:if test="count(text())=1">
                        <xsl:value-of select="text()"/>
                    </xsl:if>
                    <xsl:apply-templates select="*|comment()" mode="entferneLeereFelder"/>
                </xsl:copy>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="comment()" mode="entferneLeereFelder">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
