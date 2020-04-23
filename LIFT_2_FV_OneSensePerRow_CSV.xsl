<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- Export from FieldWorks based on LIFT export. Creates a CSV file for FirstVoices.com which expects the following: 
    \WORD River  /lift/entry/lexical-unit/form/text
    \PART_OF_SPEECH noun /lift/entry[1]/sense[1]/grammatical-info[1]/@value
    \PRONUNCIATION ɹɪvəɹ /lift/entry[1]/pronunciation[1]/form[1]/text[1]
    \DEFINITION A large and often winding stream which drains a land mass, carrying water down from higher areas to a lower point, ending at an ocean or in an inland sea. /lift/entry[1]/sense[1]/definition[1]/form[1]/text[1]
    \LITERAL_TRANSLATION 0 
    \RELATED_PHRASE I'd like to float down river today. /lift/entry[11]/sense[1]/example[1]/form[1]/text[1]/span[1]
    \RELATED_PHRASE_DEFINITION One of the many things I'd like to do on a sunny day. /lift/entry[11]/sense[1]/example[1]/translation[@type="Free translation"]/form[1]/text[1]
    \RELATED_PHRASE_LITERAL_TRANSLATION 0 /lift/entry[11]/sense[1]/example[1]/translation[@type="Literal translation"]/form[1]/text[1]
    \RELATED_PHRASE_AUDIO_TITLE Floating river recording - not in FLEx
    \RELATED_PHRASE_AUDIO_DESCRIPTION "I'd like to float down river today." recorded by Dvortygirl - not in FLEx
    \RELATED_PHRASE_AUDIO_FILENAME media/20181016/river_float_audio.mp3  /lift/entry[11]/sense[1]/example[1]/form[@lang='tsi-Zxxx-x-audio']/text[1]
    \RELATED_PHRASE_AUDIO_SHARED_WITH_OTHER_DIALECTS 0 - not in FLEx, not in this output either.
    \RELATED_PHRASE_AUDIO_CHILD_FOCUSED 0 - not in FLEx - not in FLEx, not in this output either.
    \RELATED_PHRASE_AUDIO_SOURCE Dvortygirl - need to figure this out. In FLEx but complicated to get at. 
    \RELATED_PHRASE_AUDIO_RECORDER Dvortygirl - need to figure this out. In FLEx but complicated to get at. 
    \CATEGORIES Events, Activities, Body - String multiple of these together: <trait name ="semantic-domain-ddp4" value="Ts-W Handling and physical transfer"/> for the sense. We need to create a custom field that uses the FV categories. 
    \CULTURAL_NOTE There are about 165 major rivers in the world. <note type="anthropology">
<form lang="en"><text>D0</text></form>
</note>   
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
        <xsl:text>"WORD","PART_OF_SPEECH","PRONUNCIATION","DEFINITION","LITERAL_TRANSLATION","RELATED_PHRASE","RELATED_PHRASE_DEFINITION","RELATED_PHRASE_LITERAL_TRANSLATION","RELATED_PHRASE_AUDIO_TITLE","RELATED_PHRASE_AUDIO_FILENAME","RELATED_PHRASE_AUDIO_SOURCE","CATEGORIES","CULTURAL_NOTE","REFERENCE","INCLUDE_IN_GAMES","CHILD_FRIENDLY","AUDIO_TITLE","AUDIO_DESCRIPTION","AUDIO_FILENAME","AUDIO_SHARED_WITH_OTHER_DIALECTS","AUDIO_CHILD_FOCUSED","AUDIO_SOURCE","AUDIO_RECORDER","IMG_TITLE","IMG_FILENAME","IMG_DESCRIPTION","IMG_SOURCE","USERNAME","CONTRIBUTOR"&#13;</xsl:text>
        <xsl:apply-templates select="entry/sense"/>
    </xsl:template>
    <!--Instead of matching against entry, we match against sense for better use of the First Voices presentation to the user. 
        Thus no entries in FV will have multiple senses and instead there will be some entries in FV that are homographs.-->
    <xsl:template match="entry/sense">
        <!--Here we capture the lexeme form and exclude the audio-writing-system data that stores the sound files link.-->
        <!--WORD River  /lift/entry/lexical-unit/form/text-->
        <!--Store the form in variable vWord for use in later fields-->
        <xsl:variable name="vWord">
            <xsl:value-of select="../lexical-unit/form[@lang[not(contains(.,'audio'))]]/text"/>
        </xsl:variable>
        <!--WORD River  /lift/entry/lexical-unit/form/text. Don't use the form from audio-writing-system -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../lexical-unit/form[@lang[not(contains(.,'x-audio'))]]/text"/>
        <xsl:text>",</xsl:text>
        <!--PART_OF_SPEECH noun /lift/entry/sense/grammatical-info[1]/@value-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="grammatical-info/@value"/>
        <xsl:text>",</xsl:text>
        <!--PRONUNCIATION ɹɪvəɹ /lift/entry[1]/pronunciation[1]/form[1]/text[1]-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../pronunciation[1]/form[1]/text[1]"/>
        <xsl:text>",</xsl:text>
        <!--DEFINITION A large and often winding stream which drains a land mass, carrying water down from higher areas to a lower point, ending at an ocean or in an inland sea. /lift/entry[1]/sense[1]/definition[1]/form[1]/text[1]-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="definition/form/text"/>
        <xsl:text>",</xsl:text>
        <!-- LITERAL_TRANSLATION /lift/entry[99]/field[@type='literal-meaning]/form[1]/text[1]'-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../field[@type='literal-meaning']/form[1]/text[1]"/>
        <xsl:text>",</xsl:text>
        <!-- RELATED_PHRASE or what FieldWorks calls EXAMPLE SENTENCE: sense[1]/example[1]/form[1]/text[1] - Note that FV does not support multiple example sentences so we only export the first example on a sense-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/form[1]/text[1]/."/>
        <xsl:text>",</xsl:text>
        <!-- RELATED_PHRASE_DEFINITION (same as Free translation on an example sentence) -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/translation[@type='Free translation']/form[1]/text[1]/."/>
        <xsl:text>",</xsl:text>
        <!-- RELATED_PHRASE_LITERAL_TRANSLATION (same as Literal translation on an example sentence) -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/translation[@type='Literal translation']/form[1]/text[1]/."/>
        <xsl:text>",</xsl:text>
        <!-- ____________________ NEXT ELEMENTS ARE FOR AUDIO FILE FOR EXAMPLE SENTENCE ____________________ -->
        <!--"RELATED_PHRASE_AUDIO_TITLE" Required by FV, Web-friendly title for the audio. Generated only if there is an audio file, otherwise empty ""   -->
        <xsl:choose>
            <xsl:when test="example[1]/form[@lang[ends-with(., 'x-audio')]]/text[1]/.">
                <xsl:text>"</xsl:text>
                <xsl:text>Spoken example sentence with word: </xsl:text>
                <xsl:value-of select="$vWord"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- RELATED_PHRASE_AUDIO_FILENAME-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/form[@lang[ends-with(., 'x-audio')]]/text[1]/."/>
        <xsl:text>",</xsl:text>
        <!--RELATED_PHRASE_AUDIO_SOURCE -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/note[@type='reference']/form/text/."/>
        <xsl:text>",</xsl:text>
        <!-- ____________________ PREVIOUS ELEMENTS ARE FOR AUDIO FILE FOR EXAMPLE SENTENCE ____________________ -->
        <!--"CATEGORIES" FV uses a specified set of categories. FieldWorks users should create a custom field called FV_Categories on each sense, along with a FieldWorks custom list called FV_Categories. For now empty.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "CULTURAL_NOTE" Sm'algyax project uses this to refer to some anthropological categorization. For now empty.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "REFERENCE" -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../note[@type='bibliography']/form/text/."/>
        <xsl:text>",</xsl:text>
        <!-- "INCLUDE_IN_GAMES" For now, indicated as yes with 1. Eventually need to treat this as a publication type or use a custom field FV_Games-->
        <xsl:text>"</xsl:text>
        <xsl:text>1</xsl:text>
        <xsl:text>",</xsl:text>
        <!--"CHILD_FRIENDLY" Not used for now.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- ____________________ NEXT ELEMENTS ARE FOR AUDIO FILE FOR ENTRY ____________________ -->
        <!--This section is for entries that have their headwords recording using the audio-writing-system method in FieldWorks -->
        <!--"AUDIO_TITLE" Required by FV, Web-friendly title for the audio. Generated only if there is an audio file, otherwise empty ""   -->
        <xsl:choose>
            <xsl:when test="../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]/.">
                <xsl:text>"</xsl:text>
                <xsl:text>Person saying: </xsl:text>
                <xsl:value-of select="$vWord"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- "AUDIO_DESCRIPTION" Not currently used. Empty for now. -->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "AUDIO_FILENAME" -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]/."/>
        <xsl:text>",</xsl:text>
        <!-- ""AUDIO_SHARED_WITH_OTHER_DIALECTS"" Not used for now. -->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "AUDIO_CHILD_FOCUSED" Not used for now. -->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "AUDIO_SOURCE" Not used for now. -->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- "AUDIO_RECORDER", Not user for now -->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- ____________________ PREVIOUS ELEMENTS ARE FOR AUDIO FILE FOR ENTRY ____________________ -->
        
        <!-- ____________________ FOLLOWING ELEMENTS ARE FOR FIRST IMAGE FILE FOR THIS SENSE ____________________ -->
        <!-- IMG_TITLE - For image found on a sense. These are shown at the entry level in FV -->
        <xsl:choose>
            <!--Test to see if the sense has an illustration. If so, generate a title, otherwise, generate empty.-->
            <xsl:when test="illustration">
                <xsl:text>"</xsl:text>
                <xsl:text>Image depicting: </xsl:text>
                <xsl:value-of select="$vWord"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <!-- IMG_FILENAME -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="illustration[1]/@href"/>
        <xsl:text>",</xsl:text>
        <!-- IMG_DESCRIPTION - Empty for now.  --> 
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!-- IMG_SOURCE - FieldWorks Illustration label is mapped to this field-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="illustration[1]/label/form/text/."/>
        <xsl:text>",</xsl:text>
        <!-- ____________________ PREVIOUS ELEMENTS ARE FOR FIRST IMAGE FILE FOR THIS SENSE ____________________ -->
        <!--USERNAME Empty for now.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <!--CONTRIBUTOR Empty for now.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
