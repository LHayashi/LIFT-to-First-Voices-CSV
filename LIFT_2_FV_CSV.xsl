<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Export from FieldWorks based on LIFT export. Creates a CSV file for FirstVoices.com which expects the following: 
    \WORD River  /lift/entry/lexical-unit/form/text
    \PART_OF_SPEECH noun /lift/entry[1]/sense[1]/grammatical-info[1]/@value
    \PRONUNCIATION ɹɪvəɹ /lift/entry[1]/pronunciation[1]/form[1]/text[1]
    \DEFINITION A large and often winding stream which drains a land mass, carrying water down from higher areas to a lower point, ending at an ocean or in an inland sea. /lift/entry[1]/sense[1]/definition[1]/form[1]/text[1]
    \DEFINITION_2 Any large flow of a liquid in a single body. /lift/entry[1]/sense[2]/definition[1]/form[1]/text[1]
    \DEFINITION_3 (poker) The last card dealt in a hand. /lift/entry[1]/sense[3]/definition[1]/form[1]/text[1]
    \DEFINITION_4 (typography) A visually undesirable effect of white space running down a page, caused by spaces between words on consecutive lines happening to coincide. /lift/entry[1]/sense[4]/definition[1]/form[1]/text[1]
    \LITERAL_TRANSLATION 0 
    \RELATED_PHRASE I'd like to float down river today. /lift/entry[11]/sense[1]/example[1]/form[1]/text[1]/span[1]
    \RELATED_PHRASE_DEFINITION One of the many things I'd like to do on a sunny day. /lift/entry[11]/sense[1]/example[1]/translation[@type="Free translation"]/form[1]/text[1]
    \RELATED_PHRASE_LITERAL_TRANSLATION 0 /lift/entry[11]/sense[1]/example[1]/translation[@type="Literal translation"]/form[1]/text[1]
    \RELATED_PHRASE_AUDIO_TITLE Floating river recording - not in FLEx
    \RELATED_PHRASE_AUDIO_DESCRIPTION "I'd like to float down river today." recorded by Dvortygirl - not in FLEx
    \RELATED_PHRASE_AUDIO_FILENAME media/20181016/river_float_audio.mp3  /lift/entry[11]/sense[1]/example[1]/form[@lang='tsi-Zxxx-x-audio']/text[1]
    \RELATED_PHRASE_AUDIO_SHARED_WITH_OTHER_DIALECTS 0 - not in FLEx
    \RELATED_PHRASE_AUDIO_CHILD_FOCUSED 0 - not in FLEx
    \RELATED_PHRASE_AUDIO_SOURCE Dvortygirl - need to figure this out. In FLEx but complicated to get at. 
    \RELATED_PHRASE_AUDIO_RECORDER Dvortygirl - need to figure this out. In FLEx but complicated to get at. 
    \CATEGORIES Events, Activities, Body - String multiple of these together: <trait name ="semantic-domain-ddp4" value="Ts-W Handling and physical transfer"/> for the first sense. 
    \CULTURAL_NOTE There are about 165 major rivers in the world. <note type="anthropology">
<form lang="en"><text>D0</text></form>
</note>
    \CULTURAL_NOTE_2 The Amazon River in South America is the largest river by discharge volume of water in the world, and by some definitions it is the longest. - not in FLEx
    \REFERENCE Wikipedia/Wiktionary/Wikimedia Commons
    \INCLUDE_IN_GAMES 1 <trait name="do-not-publish-in" value="FV-Games"/> Do the opposite with an if then
    \CHILD_FRIENDLY 1 <trait name="do-not-publish-in" value="FV-Child_Friendly"/> Do the opposite with an if then
    \AUDIO_TITLE River spoken by Dvortygirl  - not in FLEx
    \AUDIO_DESCRIPTION How to pronounce the word river in English /lift/entry[2332]/pronunciation[1]/form[1]/text[1]
    \AUDIO_FILENAME media/20181016/En-us-river.ogg.mp3 /lift/entry[2332]/pronunciation[1]/media[1]/@href
    \AUDIO_SHARED_WITH_OTHER_DIALECTS 0 - not in FLEx
    \AUDIO_CHILD_FOCUSED 0 - not in FLEx
    \AUDIO_SOURCE Dvortygirl /lift/entry[2332]/pronunciation[1]/media[1]/label[1]/form[1]/text[1]/span[1]
    \AUDIO_RECORDER Dvortygirl - not in FLEx
    \IMG_TITLE Limpopo River by TSGT CARY HUMPHRIES - 
    <illustration href="6-print-artist-drawings\BICYCLE 09.jpg">
                <label>
                    <form lang="en">
                        <text>
                            <span lang="tsi">Image from Print Artist Platinum software, version 23,
                                Bonus Graphics CD.</span>
                        </text>
                    </form>
                </label>
            </illustration>
    \IMG_FILENAME Media/20181016/Limpopo.jpg
    \IMG_DESCRIPTION Aerial view, extreme long shot, looking down as the Limpopo River winds its way through Southern MOZAMBIQUE
    \IMG_SHARED_WITH_OTHER_DIALECTS 1 - not in FLEx
    \IMG_CHILD_FOCUSED 0 - not in FLEx
    \IMG_SOURCE TSGT CARY HUMPHRIES - Refer to above.
    \IMG_RECORDER Defense Imagery Management Operations Center - not in FLEx. 
    \VIDEO_TITLE Katze Dam Malibamatso River by SkyPixels - not in FLEx.
    \VIDEO_FILENAME media/20181016/Katze_Dam_Malibamatso_River.webm - not in FLEx.
    \VIDEO_DESCRIPTION The Katse Dam, a concrete arch dam on the Malibamat'so River in Lesotho, is Africa's second largest dam.The dam is part of the Lesotho Highlands Water Project, which will eventually include five large dams in remote rural areas. - not in FLEx.
    \VIDEO_SHARED_WITH_OTHER_DIALECTS 1 - not in FLEx.
    \VIDEO_CHILD_FOCUSED 0 - not in FLEx.
    \VIDEO_SOURCE SkyPixels - not in FLEx.
    \VIDEO_RECORDER SkyPixels - not in FLEx.
    \USERNAME dyona - Not sure what to do with this yet. 
    \CONTRIBUTOR Daniel Yona - Not sure what to do with this yet. 
    -->
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
    <!--Need to know the writing systems that are in use. Perhaps create parameters for these-->
    <xsl:template match="lift">
        <xsl:text>"WORD","PART_OF_SPEECH","PRONUNCIATION","DEFINITION","DEFINITION_2","DEFINITION_3","DEFINITION_4","LITERAL_TRANSLATION","RELATED_PHRASE","RELATED_PHRASE_DEFINITION","RELATED_PHRASE_LITERAL_TRANSLATION","RELATED_PHRASE_AUDIO_TITLE","RELATED_PHRASE_AUDIO_DESCRIPTION","RELATED_PHRASE_AUDIO_FILENAME","RELATED_PHRASE_AUDIO_SHARED_WITH_OTHER_DIALECTS","RELATED_PHRASE_AUDIO_CHILD_FOCUSED","RELATED_PHRASE_AUDIO_SOURCE","RELATED_PHRASE_AUDIO_RECORDER","CATEGORIES","CULTURAL_NOTE","CULTURAL_NOTE_2","REFERENCE","INCLUDE_IN_GAMES","CHILD_FRIENDLY","AUDIO_TITLE","AUDIO_DESCRIPTION","AUDIO_FILENAME","AUDIO_SHARED_WITH_OTHER_DIALECTS","AUDIO_CHILD_FOCUSED","AUDIO_SOURCE","AUDIO_RECORDER","IMG_TITLE","IMG_FILENAME","IMG_DESCRIPTION","IMG_SHARED_WITH_OTHER_DIALECTS","IMG_CHILD_FOCUSED","IMG_SOURCE","IMG_RECORDER","VIDEO_TITLE","VIDEO_FILENAME","VIDEO_DESCRIPTION","VIDEO_SHARED_WITH_OTHER_DIALECTS","VIDEO_CHILD_FOCUSED","VIDEO_SOURCE","VIDEO_RECORDER","USERNAME","CONTRIBUTOR"&#13;</xsl:text>
        <xsl:apply-templates select="entry"/>
    </xsl:template>
    
    <xsl:template match="entry">
        <!--Here we capture the lexeme form and exclude the audio-writing-system data that stores the sound files link.-->
        <xsl:text>"</xsl:text><xsl:value-of select="lexical-unit/form[@lang[not(contains(.,'audio'))]]/text"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/grammatical-info/@value"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select ="pronunciation[1]/form[1]/text[1]"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/definition/form/text"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[2]/definition/form/text"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[3]/definition/form/text"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[4]/definition/form/text"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--LITERAL TRANSLATION HERE--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/example[1]/form[1]/text[1]/."/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/example[1]/translation[@type='Free translation']/form[1]/text[1]/."/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/example[1]/translation[@type='Literal translation']/form[1]/text[1]/."/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_TITLE Floating river recording--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_DESCRIPTION--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="sense[1]/example[1]/form[@lang[contains(.,'audio')]]/text[1]"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_SHARED_WITH_OTHER_DIALECTS--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_CHILD_FOCUSED--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_SOURCE--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--RELATED_PHRASE_AUDIO_RECORDER--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--CATEGORIES--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--CULTURAL_NOTE--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--CULTURAL_NOTE_2--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--REFERENCE--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--INCLUDE_IN_GAMES--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--CHILD_FRIENDLY--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_TITLE--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_DESCRIPTION--><xsl:value-of select="pronunciation[1]/form[1]/text[1]/*"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_FILENAME--><xsl:value-of select="pronunciation[1]/media[1]/@href"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_SHARED_WITH_OTHER_DIALECTS--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_CHILD_FOCUSED--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_SOURCE--><xsl:value-of select="pronunciation[1]/media[1]/label[1]/form[1]/text[1]/*"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--AUDIO_RECORDER--><xsl:value-of select="HERE"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_TITLE (FLEx has caption which is on IMG_DESCRIPTION below)--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_FILENAME--><xsl:value-of select="sense[1]/illustration[1]/@href"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_DESCRIPTION--><xsl:value-of select="sense[1]/illustration[1]/label[1]/form[1]/text[1]/normalize-space(*)"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_SHARED_WITH_OTHER_DIALECTS--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_CHILD_FOCUSED--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_SOURCE--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--IMG_RECORDER--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_TITLE--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_FILENAME--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_DESCRIPTION--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_SHARED_WITH_OTHER_DIALECTS--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_SOURCE--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--VIDEO_RECORDER--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--USERNAME--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--USERNAME_2--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><!--CONTRIBUTOR--><!--<xsl:value-of select="HERE"/>--><xsl:text>",</xsl:text>
        <xsl:text>&#13;</xsl:text>    
    </xsl:template>
    
    <xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>