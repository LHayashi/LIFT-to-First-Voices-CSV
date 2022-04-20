<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fw="http://example.com/fw" version="2.0">
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
    <!-- Parameters: 
    pExportMode = all | modified | new entries only since date 
    pVernacular = Code for vernacular encoding that should be used eg. tsi 
    pFieldWorksFwdataFile = Full path of FLEx fwdata file
    pLIFTfile = Full path of Exported LIFT file e.g. C:/Users/Larry/Desktop/TSI_LIFT/TSI_LIFT.lift
    pDateFrom = Date Range from
    pDateTo = Date Range to
    -->
    <xsl:param name="pExportMode"/>
    <xsl:param name="pVernacular"/>
    <xsl:param name="pFieldWorksFwdataFile"/>
    <xsl:param name="pLIFTfile"/>
    <xsl:param name="pDateFrom"/>
    <xsl:param name="pDateTo"/>

    <xsl:param name="pLIFTname">
        <!-- Calculated: Just the filename without the extension eg. TSI_LIFT -->
        <xsl:value-of select="replace(tokenize($pLIFTfile, '/')[last()],'.lift','')"/>
    </xsl:param>
    <xsl:param name="pLIFTfolder">
        <!-- Calculated: Just the filepath without the LIFT file eg. C:/Users/Larry/Desktop/TSI_LIFT -->
        <xsl:value-of select="string-join(tokenize($pLIFTfile,'/')[position()!=last()],'/')"/>
    </xsl:param>
    <xsl:param name="pLIFTranges">
        <!-- Calculated: Built path to lift-ranges file eg. file:///C:/Users/Larry/Desktop/TSI_LIFT/TSI_LIFT.lift-ranges -->
        <xsl:value-of select="concat('file:///',$pLIFTfolder,'/',$pLIFTname,'.lift-ranges')"/>
    </xsl:param>
    
    <xsl:variable name="vPOSRangeList"
        select="document($pLIFTranges)/lift-ranges/range[@id='grammatical-info']">
        <!-- <range id="grammatical-info">
        <range-element id="adverb" guid="1dc86d89-0649-4ed8-8b5f-4283648a8a78">
            <label>
                <form lang="en"><text>adverb</text></form>
                <form lang="es"><text>Adverbio</text></form>
                <form lang="fr"><text>Adverbe</text></form>
            </label>
            <abbrev>
                <form lang="en"><text>adverb</text></form>
                <form lang="es"><text>adv</text></form>
                <form lang="fr"><text>adv</text></form>
            </abbrev>
        </range-element> ... </range> Based on the above structure found in LIFT.lift-ranges, an
    external XML file, we load just the parts-of-speech node with all of its elements into the
    variable vPOSRangeList. This variable is called later to retrieve the abbreviation for the
    Grammatical Category. The range/@id is the same as the full name of the default Analysis writing
    system for each element. -->
    </xsl:variable>
    
    <xsl:function name="fw:sq2dq" as="xs:string">
        <!-- Replaces single quotes with double quotes for comma separated standard-->
        <xsl:param name="input"/>
        <xsl:value-of select="replace($input,'&quot;' , '&quot;&quot;')"/>
    </xsl:function>
    <xsl:function name="fw:csvdq">
        <!-- Surround data with double quotes for comma separated standard. 
            Follow with a separator value of comma unless it is the last value -->
        <xsl:param name="input"/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$input"/>
        <xsl:text>",</xsl:text>
    </xsl:function>
    
    
    <!--Need to know the writing systems that are in use. Perhaps create parameters for these-->
    <xsl:template match="lift">
        <xsl:text>"WORD_ID","WORD","PART_OF_SPEECH","PRONUNCIATION","DEFINITION","LITERAL_TRANSLATION","RELATED_PHRASE","RELATED_PHRASE_DEFINITION","RELATED_PHRASE_LITERAL_TRANSLATION","RELATED_PHRASE_AUDIO_TITLE","RELATED_PHRASE_AUDIO_FILENAME","RELATED_PHRASE_AUDIO_SOURCE","CATEGORIES","CULTURAL_NOTE","REFERENCE","INCLUDE_IN_GAMES","CHILD_FRIENDLY","AUDIO_TITLE","AUDIO_DESCRIPTION","AUDIO_FILENAME","AUDIO_SHARED_WITH_OTHER_DIALECTS","AUDIO_CHILD_FOCUSED","AUDIO_SOURCE","AUDIO_RECORDER","IMG_TITLE","IMG_FILENAME","IMG_DESCRIPTION","IMG_SOURCE","USERNAME","CONTRIBUTOR"&#13;</xsl:text>
        <xsl:choose>
            <xsl:when test="$pExportMode='new'">
                <xsl:apply-templates select="entry[@dateCreated &gt;= $pDateFrom]/sense"/>
            </xsl:when>
            <xsl:when test="$pExportMode='modified'">
                <xsl:apply-templates
                    select="entry
                    [@dateCreated &lt;= $pDateFrom]
                    [@dateModified &gt;= $pDateFrom]
                    [@dateModified &lt;= $pDateTo]/sense"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="entry/sense"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="entry/sense">
        <!--Instead of matching against entry, 
            we match against sense for better use 
            of the First Voices presentation to the user. 
            Thus no entries in FV will have multiple senses 
            and instead there will be some entries in FV that are homographs.
            WORD River  /lift/entry/lexical-unit/form/text-->

        <xsl:variable name="vWord">
            <!--Store the form in variable vWord for use in later fields-->
            <xsl:value-of select="../lexical-unit/form[@lang=$pVernacular]/text"/>
        </xsl:variable>

        <!--The following templates are called not applied inorder to create consistent csv
        Some are called with a parameter which is set to the value of $vWord-->
        <xsl:call-template name="idHeadWordPOS"/>
        <xsl:call-template name="pronunciation"/>
        <xsl:call-template name="definition"/>
        <xsl:call-template name="illustration">
            <xsl:with-param name="vWord" select="$vWord"/>
        </xsl:call-template>
        <xsl:call-template name="FVCategories"/>
        <xsl:call-template name="cultureNote"/>
        <xsl:call-template name="reference"/>
        <xsl:call-template name="childFriendly"/>
        <xsl:call-template name="audioEntry">
            <xsl:with-param name="vWord" select="$vWord"/>
        </xsl:call-template>
        <xsl:call-template name="imageSense">
            <xsl:with-param name="vWord" select="$vWord"/>
        </xsl:call-template>

        <!--USERNAME Empty for now.-->
        <xsl:text>"admin</xsl:text>
        <xsl:text>",</xsl:text>
        <!--CONTRIBUTOR Empty for now. Last column = no comma. Paragraph return instead. -->
        <xsl:text>"</xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>

    <!-- Note these templates are NAMED and not MATCHED.
        The templates are called from entry/sense template
        and must be called in order that "", appears when
        there is NO match. -->

    <xsl:template name="idHeadWordPOS">
        <!--WORD_ID Using the sense guid to create a unique identifier for each row-->
        <xsl:value-of select="fw:csvdq(@id)"/>
        <!--WORD River  /lift/entry/lexical-unit/form/text. Use the form from the set vernacular writing-system -->

        <xsl:value-of select="fw:csvdq(../lexical-unit/form[@lang=$pVernacular]/text)"/>
        <!--PART_OF_SPEECH
            noun /lift/entry/sense/grammatical-info[1]/@value
            We load this value into the variable vCurrentPOS. 
            We then use the variable we set up at the very start of the document for LIFT.lift-ranges data
            where we have loaded all of the xml for the Grammatical categories.
            We match vCurrentPOS to the range-element/@id in the Grammatical categories, 
            retrieve the abbreviation and its English form.-->
        <!-- Note that for now, the English abbreviation captures the First Voices category use -->
        <xsl:variable name="vCurrentPOS" select="grammatical-info/@value"/>
        <xsl:value-of
            select="fw:csvdq($vPOSRangeList/range-element[@id=$vCurrentPOS]/abbrev/form[@lang='en']/text)"
        />
    </xsl:template>


    <xsl:template name="pronunciation">
        <!--PRONUNCIATION
            ɹɪvəɹ /lift/entry[1]/pronunciation[1]/form[1]/text[1]-->
        <xsl:value-of select="fw:csvdq(../pronunciation[1]/form[1]/text[1])"/>
    </xsl:template>

    <xsl:template name="definition">
        <!--DEFINITION
            A large and often winding stream which drains a land mass.
            /lift/entry[1]/sense[1]/definition[1]/form[1]/text[1]-->
        <xsl:value-of select="fw:csvdq(fw:sq2dq(definition/form[1]/text))"/>

        <!-- LITERAL_TRANSLATION aka FieldWorks Literal Meaning
            /lift/entry[99]/field[@type='literal-meaning]/form[1]/text[1]'-->
        <xsl:value-of select="fw:csvdq(fw:sq2dq(../field[@type='literal-meaning']/form[1]/text[1]))"
        />
    </xsl:template>

    <xsl:template name="illustration">
        <xsl:param name="vWord"/>
        <!-- RELATED_PHRASE = FieldWorks EXAMPLE SENTENCE:
            sense[1]/example[1]/form[1]/text[1] - 
            Note that FV does not support multiple example sentences so we only export the first example on a sense-->
        <xsl:value-of select="fw:csvdq(fw:sq2dq(example[1]/form[1]/text[1]))"/>

        <!-- RELATED_PHRASE_DEFINITION = FieldWorks FREE TRANSLATION on an example sentence) -->
        <xsl:value-of
            select="fw:csvdq(fw:sq2dq(example[1]/translation[@type='Free translation']/form[1]/text[1]/.))"/>

        <!-- RELATED_PHRASE_LITERAL_TRANSLATION (same as Literal translation on an example sentence) -->
        <xsl:value-of
            select="fw:csvdq(fw:sq2dq(example[1]/translation[@type='Literal translation']/form[1]/text[1]/.))"/>

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
                <xsl:value-of select="fw:csvdq('')"/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- RELATED_PHRASE_AUDIO_FILENAME-->
        <xsl:text>"</xsl:text>
        <!-- Replaces .wav with mp3 -->
        <xsl:value-of
            select="replace(example[1]/form[@lang[ends-with(., 'x-audio')]]/text[1]/.,'.wav','.mp3')"/>
        <xsl:text>",</xsl:text>
        <!--RELATED_PHRASE_AUDIO_SOURCE -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/note[@type='reference']/form/text/."/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="FVCategories">
        <!--"CATEGORIES" FV uses a specified set of categories. 
            FieldWorks users should create a custom field called FVCategories on each sense, along with a FieldWorks custom list called FV_Categories.
            These are stored in FieldWorks LIFT as a sequence of traits.
        <trait name="FVCategories" value="Plants"/>
        <trait name="FVCategories" value="Food Plants"/>
        <trait name="FVCategories" value="Shrubs"/> 
        XSL 2.0 and above allow for the use of the separator attribute leaving its value off the last occurrence.
        Ain't that sweet? -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="trait[@name='FVCategories']/@value" separator=","/>
        <!--<xsl:for-each select="trait[@name='FVCategories']">
                <xsl:value-of select="@value" separator=", "/>
        </xsl:for-each>-->
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="cultureNote">
        <!-- "CULTURAL_NOTE" Sm'algyax project uses this to refer to some anthropological categorization. For now empty.-->
        <xsl:value-of select="fw:csvdq('')"/>
    </xsl:template>
    <xsl:template name="reference">
        <xsl:value-of select="fw:csvdq(fw:sq2dq(../note[@type='bibliography']/form/text/.))"/>
    </xsl:template>
    <xsl:template name="childFriendly">
        <xsl:choose>
            <!--Check if in sensitive semantic domain category. Note this should be done manually with a publication type-->
            <xsl:when
                test="trait[starts-with(@value,'2.1.8.3') or starts-with(@value,'2.1.8.4') or starts-with(@value,'2.6.2')]">
                <!-- "INCLUDE_IN_GAMES" Indicate with ZERO-->
                <xsl:value-of select="fw:csvdq('0')"/>
                <!--"CHILD_FRIENDLY" Indicate with ZERO.-->
                <xsl:value-of select="fw:csvdq('0')"/>
            </xsl:when>
            <!-- If not in sensitive category then mark with 1-->
            <xsl:otherwise>
                <!-- "INCLUDE_IN_GAMES" For now, indicated as yes with 1. Eventually need to treat this as a publication type or use a custom field FV_Games-->
                <xsl:value-of select="fw:csvdq('1')"/>
                <!--"CHILD_FRIENDLY" Indicate with 1.-->
                <xsl:value-of select="fw:csvdq('1')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="audioEntry">
        <xsl:param name="vWord"/>
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
        <!--        <xsl:value-of select="../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]/."/>-->
        <!-- Replaces .wav with .mp-->
        <xsl:value-of
            select="replace(../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]/.,'.wav','.mp3')"/>
        <xsl:text>",</xsl:text>
        <!-- ""AUDIO_SHARED_WITH_OTHER_DIALECTS"" Not used for now. -->
        <xsl:value-of select="fw:csvdq('')"/>
        <!-- "AUDIO_CHILD_FOCUSED" Not used for now. -->
        <xsl:value-of select="fw:csvdq('')"/>
        <!-- "AUDIO_SOURCE" Not used for now. -->
        <xsl:value-of select="fw:csvdq('')"/>
        <!-- "AUDIO_RECORDER", Not used for now -->
        <xsl:value-of select="fw:csvdq('')"/>
    </xsl:template>

    <xsl:template name="imageSense">
        <xsl:param name="vWord"/>
        <!-- IMG_TITLE - For image found on a sense. These are shown at the entry level in FV -->
        <xsl:choose>
            <!--Test to see if the sense has an illustration. If so, generate a title, otherwise, generate empty.-->
            <xsl:when test="illustration">
                <xsl:value-of select="fw:csvdq(concat('Image depicting: ',$vWord))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="fw:csvdq('')"/>
            </xsl:otherwise>
        </xsl:choose>

        <!-- IMG_FILENAME -->
        <xsl:text>"</xsl:text>
        <!--The string of functions here tokenizes the string based on the \ character and then selects the last token-->
        <xsl:value-of
            select="replace(subsequence(reverse(tokenize(illustration[1]/@href,'\\')), 1, 1),'.bmp|.BMP','.jpg')"/>
        <xsl:text>",</xsl:text>

        <!-- IMG_DESCRIPTION - Empty for now.  -->
        <xsl:value-of select="fw:csvdq('')"/>

        <!-- IMG_SOURCE - FieldWorks Illustration label is mapped to this field-->
        <xsl:value-of select="fw:csvdq(illustration[1]/label/form/text/.)"/>
    </xsl:template>

    <xsl:template name="copystuff" match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
