<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"

    xmlns:ara="http://www.arachne.uni-koeln.de/formats/arachne/"

    exclude-result-prefixes="ara xs rdf rdfs">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    
    <!-- beachte: die Unterkategorie-Felder sind projektspezifisch -->
    <!-- SyrHer: 
         1: z.B. dai-orientabteilung-damaskus
         2: z.B. dai-orientabteilung-damaskus-fotothek
         5: z.B. DAI
         6: Gazetteer-ID, z.B. 2042661
         7: Jahr, z.B. 2004
         9, 10, 11: z.B. Zeichnungen;Architektur;Ansicht 
    -->
    <!-- TODO Zeichnungen zu Zeichnung, etc. -->
    
    <xsl:variable name="unterkategorieListe" select="tokenize(dataset/Unterkategorie,';')"/>
 
 
    <xsl:variable name="ergebnisMitLeerenFeldern">
        <xsl:for-each select="dataset">           
            <rdf:Description>

                <!-- dc:identifier -->
                <!-- TODO stelle falls möglich auf Entity-ID um -->
                <dc:identifier>
                    <xsl:text>http://arachne.uni-koeln.de/item/marbilderbestand/</xsl:text>
                    <xsl:value-of select="PS_MarbilderbestandID"/>
                </dc:identifier>

                <!-- dc:format -->
                <!-- TODO Datei-Details aus dem JSON vom Backend? Lohnt sich das? -->
                <dcterms:extent>[Dateigröße]</dcterms:extent>
                <dcterms:medium>Image</dcterms:medium>
                <dcterms:medium>[Dateiformat]</dcterms:medium>
 
                <!-- dc:type -->
                <!-- TODO sinnvoll auf type und subject aufteilen -->
                <dc:type>Image</dc:type>
                <dc:type>
                    <xsl:value-of select="$unterkategorieListe[9]"/>
                </dc:type>
                <dc:type>
                    <xsl:value-of select="$unterkategorieListe[10]"/>
                </dc:type>
                <dc:type>
                    <xsl:value-of select="$unterkategorieListe[11]"/>
                </dc:type>
                
                <!-- dc:language -->
                <!-- TODO genauer angeben -->
                <dc:language>deu</dc:language>
                
                <!-- dc:title -->
                <xsl:choose>
                    <xsl:when test="TitelMarbilderbestand or TitelMarbilderbestandEN">
                        <dc:title>
                            <xsl:value-of select="TitelMarbilderbestand"/>
                        </dc:title>
                        <dc:title>
                            <xsl:value-of select="TitelMarbilderbestandEN"/>
                        </dc:title>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <dc:title>
                            <xsl:value-of select="DateinameMarbilderbestand"/>
                        </dc:title>                        
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- dc:subject -->
                <!-- unterkategorieListe siehe dc:type -->
                <dc:subject>
                    <xsl:value-of select="$unterkategorieListe[9]"/>
                </dc:subject>
                <dc:subject>
                    <xsl:value-of select="$unterkategorieListe[10]"/>
                </dc:subject>
                <dc:subject>
                    <xsl:value-of select="$unterkategorieListe[11]"/>
                </dc:subject>
                
                <!-- dc:coverage -->
                <dcterms:spatial>
                    <xsl:value-of select="$unterkategorieListe[1]"/>
                </dcterms:spatial>
                <dcterms:spatial>
                    <xsl:value-of select="$unterkategorieListe[6]"/>
                </dcterms:spatial>
                <dcterms:temporal>
                    <xsl:value-of select="$unterkategorieListe[7]"/>
                </dcterms:temporal>
                
                <!-- dc:description -->
                <!-- TODO -->
                
                <!-- dc:creator -->
                <dc:creator>
                    <xsl:value-of select="Bildautor"/>
                </dc:creator>
                
                <!-- dc:contributor -->
                <dc:contributor>
                    <xsl:value-of select="$unterkategorieListe[1]"/>
                </dc:contributor>
                <dc:contributor>
                    <xsl:value-of select="$unterkategorieListe[2]"/>
                </dc:contributor>
                <dc:contributor>
                    <xsl:value-of select="$unterkategorieListe[5]"/>
                </dc:contributor>                
                <dc:contributor>
                    <xsl:value-of select="Bestandsname"/>
                </dc:contributor>
                
                <!-- dc:publisher -->
                <dc:publisher>iDAI.objects arachne</dc:publisher>
                
                <!-- dc:rights -->
                <dcterms:license>(not public)</dcterms:license>
                <dcterms:accessRights>(not public)</dcterms:accessRights>
                
                <!-- dc:source -->
                <!-- TODO -->
                
                <!-- dc:relation -->
                <!-- TODO -->
                
                <!-- dc:date -->
                <dcterms:created>
                    <xsl:value-of select="$unterkategorieListe[7]"/>
                </dcterms:created>
                <dcterms:modified>
                    <xsl:value-of select="lastModified"/>
                </dcterms:modified>
                
            </rdf:Description>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="$ergebnisMitLeerenFeldern" mode="entferneLeereFelder"/>
    </xsl:template>
    
    <xsl:template match="*" mode="entferneLeereFelder">
        <xsl:if test="descendant-or-self::*[count(text())=1 or @*[. != '']]">
            <xsl:copy>
                <xsl:copy-of select="@*[. != '']"/>
                <xsl:if test="count(text())=1">
                    <xsl:value-of select="text()"/>
                </xsl:if>
                <xsl:apply-templates select="*" mode="entferneLeereFelder"/>
            </xsl:copy>            
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
