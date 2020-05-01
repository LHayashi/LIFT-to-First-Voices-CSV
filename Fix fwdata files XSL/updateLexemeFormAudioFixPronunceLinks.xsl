<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <!-- Find Entries with LexemeForms that do not have Audio Writing System, then check if there is a pronunciation-->
    <xsl:template match="rt[@class='CmFile'][InternalPath/Uni[ends-with((.),'.wav')]]">
        <xsl:variable name="vFileNameFromUni" select="subsequence(reverse(tokenize(InternalPath/Uni/text(),'\\')), 1, 1)"/>
        <rt>
            <xsl:copy-of select="@*"/>
            <InternalPath>
                <Uni>
                    <xsl:text>AudioVisual\</xsl:text><xsl:value-of select="$vFileNameFromUni"/>
                </Uni>
            </InternalPath>
        </rt>
    </xsl:template>
</xsl:stylesheet>