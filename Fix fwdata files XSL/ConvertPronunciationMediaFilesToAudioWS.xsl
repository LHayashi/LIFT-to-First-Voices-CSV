<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" standalone="yes"/>
    <xsl:key name="CmFileKey" match="rt[@class='CmFile']" use="@guid"/>
    <xsl:key name="CmMediaKey" match="rt[@class='CmMedia']" use="@guid"/>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!--This replaces CmFiles as AudioWritingSystems in the pronunciation object. 
        SOURCE:
        This goes three layers: MediaFiles\CmMedia
        Layer 1:
        <rt class="LexPronunciation" guid="00967c8c-e0bd-4be4-b3d9-0bb54fc11605" ownerguid="d1e63f58-2b31-406c-a069-e2e4fdaeee62">
            <Form>
                <AUni ws="tsi-fonipa">ha/*dziikw/sa̱</AUni>
            </Form>
            <MediaFiles>
                <objsur guid="9685e076-7f7c-4f88-85d2-0fea7a86ca61" t="o" />
            </MediaFiles>
        </rt>
        
        Layer 2: CmMedia
        <rt class="CmMedia" guid="938b6c43-11a6-4b67-aa68-d3a740a2fe9b" ownerguid="4e9170c4-5b37-4840-8af0-bad807f8bcf1">
            <MediaFile>
                <objsur guid="cb4393a5-3b0f-4281-a861-1e38ca829bb1" t="r" />
            </MediaFile>
        </rt>
        
        Layer 3: CmFile
        <rt class="CmFile" guid="9685e076-7f7c-4f88-85d2-0fea7a86ca61" ownerguid="eaafbd76-ba5b-424d-8590-061195963021">
            <InternalPath>
                <Uni>AudioVisual\sd52\Yr1\1-3begphrase\ama ganlaak-ac-ps-06.wav</Uni>
            </InternalPath>
        </rt>
        
        DESTINATION:
        <rt class="LexPronunciation" guid="e842aac2-1bdc-4566-952c-e759a63c7de7" ownerguid="e61eabe5-54cc-4019-ab38-8bb43cd2098c">
            <Form>
                <AUni ws="tsi-Zxxx-x-audio">AudioVisual\sd52\Yr1\1-3begphrase\ama ganlaak-ac-ps-06.wav</AUni>
            </Form>
        </rt>
    -->
    
    <xsl:template match="Example[AStr/Run[@namedStyle='Hyperlink']][not(AStr/Run[@ws='tsi-Zxxx-x-audio'])]">
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
    
    
    <xsl:template match="rt[@class='LexPronunciation']">
        <rt class="LexPronunciation">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:for-each select="MediaFiles/objsur">
                <Form>
                    <AUni ws="tsi-Zxxx-x-audio">
                        <xsl:value-of select="@guid"/>test1
                        <xsl:for-each select="key('CmMediaKey',@guid)/MediaFile/objsur">
                            <xsl:value-of select="@guid"/>test2
                            <xsl:value-of select="key('CmFileKey',@guid)/InternalPath/Uni"/>
                        </xsl:for-each>
                    </AUni>
                </Form>
            </xsl:for-each>
        </rt>
    </xsl:template>
    <xsl:template match="Run[text()='']">
        <Run>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </Run>
    </xsl:template>
</xsl:stylesheet>
