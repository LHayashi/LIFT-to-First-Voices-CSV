<?xml version="1.0" encoding="UTF-8"?>
<!-- Generates just the example sentences in an XML file -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="*">
        <CmFilesOnly>
            <xsl:copy-of select="//rt[@class='CmFile'][InternalPath/Uni[ends-with((.),'.wav')]]"/>
        </CmFilesOnly>
    </xsl:template>
</xsl:stylesheet>