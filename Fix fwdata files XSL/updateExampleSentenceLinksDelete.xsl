<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="Example[AStr/Run[@namedStyle='Hyperlink']]">
        <xsl:variable name="vFileNameFromHyperLink" select="subsequence(reverse(tokenize(AStr/Run[@namedStyle='Hyperlink']/@externalLink,'\\')), 1, 1)"/>
        <xsl:choose>
            <!--If the example sentence with a hyperlink already has an Audio Writing System link inside a Run element then... -->
            <xsl:when test="AStr[@ws='tsi-Zxxx-x-audio'][Run]">
                <Example>
                    <AStr ws="tsi">
                        <Run ws="tsi">
                            <xsl:value-of select="AStr/Run[@namedStyle='Hyperlink']/text()"/>
                        </Run>
                    </AStr>
                    <xsl:copy-of select="AStr[@ws='tsi-Zxxx-x-audio']"/>
                </Example>
            </xsl:when>
            <!--If the example sentence with a hyperlink already has an Audio Writing System link without a Run element then...Apparently there are not any of these. -->    
            <!--xsl:when test="AStr[@ws='tsi-Zxxx-x-audio']/text()">
                    <Example>
                        <AStr ws="tsi">
                            <Run ws="tsi">
                                <xsl:value-of select="AStr/Run[@namedStyle='Hyperlink']/text()"/>
                            </Run>
                        </AStr>
                        <xsl:copy-of select="AStr[@ws='tsi-Zxxx-x-audio']"/>
                    </Example>
            </xsl:when -->
            <!--If the example sentence with a hyperlink doesn't have an Audio Writing System link then copy the filename in the Hyperlink and create an audio-writing system link... -->
            <xsl:otherwise>
                <Example>
                    <AStr ws="tsi">
                        <Run ws="tsi">
                            <xsl:value-of select="AStr/Run/text()"/>
                        </Run>
                    </AStr>
                    <AStr ws="tsi-Zxxx-x-audio">
                        <Run ws="tsi-Zxxx-x-audio">
                            <xsl:value-of select="$vFileNameFromHyperLink"/>
                        </Run>
                    </AStr>
                </Example>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template match="Run[text()='']"/>-->
</xsl:stylesheet>