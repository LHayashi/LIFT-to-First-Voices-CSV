<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <!--This template removes elements such as the following from fwdata files
        used after fixing audio and image links in Margaret's data
        <OriginalPath>
           <Uni>c:\ll\clr\snds\b\bu'nsk-br-kk-01.wav</Uni>
        </OriginalPath>
    -->
    <xsl:template match="OriginalPath"/>
</xsl:stylesheet>