<?xml version="1.0" encoding="UTF-8"?>
<!-- Generates just the example sentences in an XML file -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"/>
    <xsl:template match="*">
        <ExampleSentencesOnly>
            <xsl:copy-of select="//Example[AStr[@ws='tsi-Zxxx-x-audio']/not(Run)]"/>
        </ExampleSentencesOnly>
    </xsl:template>
</xsl:stylesheet>