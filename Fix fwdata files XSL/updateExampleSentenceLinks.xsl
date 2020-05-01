<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="languageproject">
        <languageproject>
            <xsl:apply-templates mode="copy" select="@*"/>
            <xsl:apply-templates select="rt"/>
        </languageproject>
    </xsl:template>
    <xsl:template match="rt">
        <rt>
            <xsl:apply-templates mode="copy" select="@*"/>
            <xsl:apply-templates mode="copy"/>
            <xsl:apply-templates select="Example"/>
        </rt>
    </xsl:template>
    <xsl:template match="Example[AStr/Run[@namedStyle='Hyperlink']]">
        <Example>
            <AStr ws="ttt">
                <Run ws="tsi">
                    <xsl:value-of select="AStr/Run/text()"/>
                </Run>
            </AStr>
            <AStr ws="tsi-Zxxx-x-audio">
                <Run ws="tsi-Zxxx-x-audio">
                    <xsl:value-of select="AStr/Run/@externalLink"/>
                </Run>
            </AStr>
        </Example>
    </xsl:template>
    <!-- Deep copy template -->
    <xsl:template match="*|text()|@*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates mode="copy" select="@*"/>
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>
    <!-- Handle default matching -->
    <xsl:template match="*"/>
</xsl:stylesheet>