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
        <Example>
            <AStr ws="tsi">
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
    <xsl:template match="Run[text()='']"/>
</xsl:stylesheet>