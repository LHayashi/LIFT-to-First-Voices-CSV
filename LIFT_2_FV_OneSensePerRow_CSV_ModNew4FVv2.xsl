<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" 
    xmlns:my="http://example.com" version="2.0">
    <!-- Export from FieldWorks based on LIFT export. Creates a CSV file for FirstVoices.com --> 

    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
    <!-- Full path of FLEx fwdata file -->
    <xsl:param name="pFieldWorksFwdataFile"/>
    
    <!-- Full path of Exported LIFT file e.g. C:/Users/Larry/Desktop/TSI_LIFT/TSI_LIFT.lift-->
    <xsl:param name="pLIFTfile"/>
    
    <!-- Just the filename without the extension eg. TSI_LIFT -->
    <xsl:param name="pLIFTname">
        <xsl:value-of select="replace(tokenize($pLIFTfile, '/')[last()],'.lift','')"/>
    </xsl:param>
    
    <!-- Just the filepath without the LIFT file eg. C:/Users/Larry/Desktop/TSI_LIFT -->
    <xsl:param name="pLIFTfolder">
        <xsl:value-of select="string-join(tokenize($pLIFTfile,'/')[position()!=last()],'/')"/>
    </xsl:param>
    
    <!-- Built path to lift-ranges file eg. file:///C:/Users/Larry/Desktop/TSI_LIFT/TSI_LIFT.lift-ranges -->
    <xsl:param name="pLIFTranges">
        <xsl:value-of select="concat('file:///',$pLIFTfolder,'/',$pLIFTname,'.lift-ranges')"/>
    </xsl:param>
    
    <!-- Date Created and Modified for filtering entries in LIFT file -->
    <xsl:param name="pLastDateExport"/>
    <xsl:param name="pDateModified"/>
    
    <!-- Are the sound files being delivered as MP3orWAV -->
    <xsl:param name="pMP3orWAV"/>
    <!-- 
<range id="grammatical-info">
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
</range-element>
...
</range>
Based on the above structure found in LIFT.lift-ranges, an external XML file, we load just the parts-of-speech node with all of its elements
        into the variable vPOSRangeList. This variable is called later to retrieve the abbreviation for the Grammatical Category.
        The range/@id is the same as the full name of the default Analysis writing system for each element. -->
    <xsl:variable name="vPOSRangeList"       select="document($pLIFTranges)/lift-ranges/range[@id='grammatical-info']"/>
    <!--Need to know the writing systems that are in use. Perhaps create parameters for these-->
    <xsl:function name="my:escape_dbl_quotes">
        <xsl:param name="string2BEsc"/>
        <xsl:value-of select="replace($string2BEsc,'&quot;' , '&quot;&quot;')"/>
    </xsl:function>
    
    <xsl:function name="my:ASCIIfyFileName">
        <xsl:param name="fileName"/>
        <xsl:value-of select="replace($fileName,'[^a-zA-Z0-9\.]','_')"/>
    </xsl:function>
    
    <xsl:function name="my:MP3orWAV">
        <xsl:param name="fileName"></xsl:param>
        <xsl:choose>
            <xsl:when test="$pMP3orWAV='MP3'">
                <xsl:value-of
                    select="replace($fileName,'.wav','.mp3')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="replace($fileName,'.mp3','.wav')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="lift">
        <xsl:text>"WORD_ID","WORD","PART_OF_SPEECH","PRONUNCIATION","TRANSLATION","TRANSLATION_2","CATEGORIES","NOTE","ACKNOWLEDGEMENT","FOR_KIDS","AUDIO_TITLE","AUDIO_FILENAME","IMG_TITLE","IMG_FILENAME","IMG_SOURCE","RELATED_PHRASE","RELATED_PHRASE_TRANSLATION","RELATED_PHRASE_ACKNOWLEDGEMENT","RELATED_PHRASE_AUDIO_TITLE","RELATED_PHRASE_AUDIO_FILENAME","USERNAME","CONTRIBUTOR","DATE_CREATED","DATE_MODIFIED"&#13;</xsl:text>
        <!--<xsl:apply-templates select="entry[not(@dateCreated gt $pLastDateExport)][@dateModified gt $pLastDateExport]/sense"/>-->
        <xsl:choose>
            <xsl:when test="$pDateModified=''">
                <xsl:apply-templates select="entry/sense"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="entry[@dateCreated gt $pLastDateExport][@dateModified gt $pLastDateExport]/sense"/>        
            </xsl:otherwise>
        </xsl:choose>
        
        <!--<xsl:apply-templates select="entry[@dateCreated lt $pDateCreated][@dateModified gt $pDateCreated]/sense"/>-->
    </xsl:template>
    
    <xsl:template name="FVEntry" match="entry/sense">
        <!--Instead of matching against entry, we match against sense for better use of the First Voices presentation to the user. 
        Thus no entries in FV will have multiple senses and instead there will be some entries in FV that are homographs.-->
        <!--Here we capture the lexeme form and exclude the audio-writing-system data that stores the sound files link.-->
        <!--Store the form in variable vWord for use in later fields-->
        <xsl:variable name="vWord" >
            <xsl:value-of select="../lexical-unit/form[@lang[not(contains(., 'audio'))]]/text"/>
        </xsl:variable>
        <xsl:call-template name="WORD_ID"/>
        <xsl:call-template name="WORD"/>
        <xsl:call-template name="PART_OF_SPEECH"/>
        <xsl:call-template name="PRONUNCIATION"/>
        <xsl:call-template name="TRANSLATIONakaDEFINITION"/>
        <xsl:call-template name="TRANSLATION_2akaLITERAL_DEFINITION"/>
        <xsl:call-template name="CATEGORIES"/>
        <xsl:call-template name="NOTE"/>
        <xsl:call-template name="ACKNOWLEDGEMENT"/>
        <xsl:call-template name="FOR_KIDS"/>
        <xsl:call-template name="AUDIO_TITLE">
            <xsl:with-param name="WordPassThrough" select="$vWord"/>
        </xsl:call-template>
        <xsl:call-template name="AUDIO_FILENAME"/>     
        <xsl:call-template name="IMG_TITLE"/>
        <xsl:call-template name="IMG_FILENAME"/>
        <xsl:call-template name="IMG_SOURCE"/>
        <xsl:call-template name="RELATED_PHRASE"/>
        <xsl:call-template name="RELATED_PHRASE_TRANSLATION"/>
        <xsl:call-template name="RELATED_PHRASE_ACKNOWLEDGEMENT"/>
        <xsl:call-template name="RELATED_PHRASE_AUDIO_TITLE">
            <xsl:with-param name="WordPassThrough" select="$vWord"/>
        </xsl:call-template>
        <xsl:call-template name="RELATED_PHRASE_AUDIO_FILENAME"/>
       
      

        <!-- ____________________ PREVIOUS ELEMENTS ARE FOR FIRST IMAGE FILE FOR THIS SENSE ____________________ -->
        <!--USERNAME Empty for now.-->
        <xsl:text>"admin</xsl:text>
        <xsl:text>",</xsl:text>
        <!--CONTRIBUTOR Empty for now.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../@dateCreated"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../@dateModified"/>
        <xsl:text>"</xsl:text>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>
    
    <xsl:template name="WORD_ID">
        <!--WORD_ID Using the sense guid to create a unique identifier for each row-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="WORD">
        <!--WORD River  /lift/entry/lexical-unit/form/text-->
        <!--WORD River  /lift/entry/lexical-unit/form/text. Don't use the form from audio-writing-system -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../lexical-unit/form[@lang[not(contains(., 'x-audio'))]]/text"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="PART_OF_SPEECH">
        <!--PART_OF_SPEECH noun /lift/entry/sense/grammatical-info[1]/@value
        We load this value into the variable vCurrentPOS. 
        We then use the variable we set up at the very start of the document for LIFT.lift-ranges data
        where we have loaded all of the xml for the Grammatical categories.
        We match vCurrentPOS to the range-element/@id in the Grammatical categories, retrieve the abbreviation and its English form.-->
        <!-- Note that for now, the English abbreviation captures the First Voices category use -->
        <xsl:text>"</xsl:text>
        <xsl:variable name="vCurrentPOS" select="grammatical-info/@value"/>
        <xsl:value-of select="$vPOSRangeList/range-element[@id=$vCurrentPOS]/abbrev/form[@lang='en']/text"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="PRONUNCIATION">
        <!--PRONUNCIATION ɹɪvəɹ /lift/entry[1]/pronunciation[1]/form[1]/text[1]-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../pronunciation[1]/form[1]/text[1]"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    <xsl:template name="TRANSLATIONakaDEFINITION">
        <!--TRANSLATION A large and often winding stream which drains a land mass, carrying water down from higher areas to a lower point, ending at an ocean or in an inland sea. /lift/entry[1]/sense[1]/definition[1]/form[1]/text[1]-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="my:escape_dbl_quotes(definition/form[1]/text)"/>
        <xsl:text>",</xsl:text>        
    </xsl:template>
    <xsl:template name="TRANSLATION_2akaLITERAL_DEFINITION">
        <!-- TRANSLATION_2 /lift/entry[99]/field[@type='literal-meaning]/form[1]/text[1]'-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="my:escape_dbl_quotes(../field[@type='literal-meaning']/form[1]/text[1])"/>
        <xsl:text>",</xsl:text>   
    </xsl:template>
    <xsl:template name="RELATED_PHRASE">
        <!-- RELATED_PHRASE or what FieldWorks calls EXAMPLE SENTENCE: sense[1]/example[1]/form[1]/text[1] - Note that FV does not support multiple example sentences so we only export the first example on a sense-->
        <xsl:text>"</xsl:text>
        <!--Here we use replace to escape double-quotes found within the example sentence itself - Wolf said to Fish, "Let's go swimming!"-->
        <xsl:value-of select="my:escape_dbl_quotes(example[1]/form[1]/text[1]/.)"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="RELATED_PHRASE_TRANSLATION">
        <!-- RELATED_PHRASE_DEFINITION (same as Free translation on an example sentence) 
        2023-02-16 This is a required field in FirstVoices but some example sentences may only have a literal. 
        Thus here we check for the existence of a free translation. If there is one, we use it. 
        If not, we check for a literal translation and use it.-->
        <xsl:choose>
            <xsl:when test="example[1]/translation[@type = 'Free translation']">
                <xsl:text>"</xsl:text>
                <!--Here we use replace to escape double-quotes found within the example sentence itself - Wolf said to Fish, "Let's go swimming!"-->
                <xsl:value-of select="my:escape_dbl_quotes(example[1]/translation[@type = 'Free translation']/form[1]/text[1]/.)"/>                
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- Otherwise use Literal translation as the example sentence) -->
                <xsl:text>"</xsl:text>
                <!--Here we use replace to escape double-quotes found within the example sentence itself - Wolf said to Fish, "Let's go swimming!"-->
                <xsl:value-of select="my:escape_dbl_quotes(example[1]/translation[@type = 'Literal translation']/form[1]/text[1]/.)"/>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="RELATED_PHRASE_ACKNOWLEDGEMENT">
        <!--RELATED_PHRASE_AUDIO_SOURCE -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="example[1]/note[@type='reference']/form/text/."/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="RELATED_PHRASE_AUDIO_TITLE">
        <!--"RELATED_PHRASE_AUDIO_TITLE" Required by FV, Web-friendly title for the audio. Generated only if there is an audio file, otherwise empty ""   -->
        <xsl:param name="WordPassThrough"></xsl:param>
        <xsl:choose>
            <xsl:when test="example[1]/form[@lang[ends-with(., 'x-audio')]]/text[1]/.">
                <xsl:text>"</xsl:text>
                <xsl:text>Spoken example sentence with word: </xsl:text>
                <xsl:value-of select="$WordPassThrough"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="RELATED_PHRASE_AUDIO_FILENAME">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="my:ASCIIfyFileName(my:MP3orWAV(example[1]/form[@lang[ends-with(., 'x-audio')]]/text[1]/.))"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    <xsl:template name="AUDIO_TITLE">
        <!--"RELATED_PHRASE_AUDIO_TITLE" Required by FV, Web-friendly title for the audio. Generated only if there is an audio file, otherwise empty ""   -->
        <xsl:param name="WordPassThrough"></xsl:param>
        <xsl:choose>
            <xsl:when test="../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]/.">
                <xsl:text>"</xsl:text>
                <xsl:text>Person saying: </xsl:text>
                <xsl:value-of select="$WordPassThrough"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="AUDIO_FILENAME">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="my:ASCIIfyFileName(my:MP3orWAV(../lexical-unit/form[@lang[ends-with(., 'x-audio')]]/text[1]))"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    
    <xsl:template name="IMG_TITLE">
        <!--"IMAGE_TITLE" Required by FV, Web-friendly title for the image. Generated only if there is an image file, otherwise empty   -->
        <xsl:param name="WordPassThrough"></xsl:param>
        <xsl:choose>
                <xsl:when test="illustration">
                    <xsl:text>"</xsl:text>
                    <xsl:text>Image depicting: </xsl:text>
                    <xsl:value-of select="$WordPassThrough"/>
                    <xsl:text>",</xsl:text>
                </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="IMG_FILENAME">
        <xsl:text>"</xsl:text>
        <!--The string of functions here tokenizes the string based on the \ character and then selects the last token-->
        <xsl:value-of
            select="my:ASCIIfyFileName(replace(subsequence(reverse(tokenize(illustration[1]/@href,'\\')), 1, 1),'.bmp|.BMP','.jpg'))"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    <xsl:template name="IMG_SOURCE">
        <!-- FieldWorks Illustration label is mapped to this field-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="illustration[1]/label/form/text/."/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    <xsl:template name="CATEGORIES">
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
    
    <xsl:template name="ACKNOWLEDGEMENT">
        <!-- "ACKNOWLEDGEMENT of source on the entry" -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="my:escape_dbl_quotes(../note[@type='bibliography']/form/text/.)"/>
        <xsl:text>",</xsl:text>      
    </xsl:template>
    
    <xsl:template name="NOTE">
        <!-- "CULTURAL_NOTE" Sm'algyax project uses this to refer to some anthropological categorization. For now empty.-->
        <xsl:text>"</xsl:text>
        <xsl:text>",</xsl:text>
    </xsl:template>
    
    <xsl:template name="FOR_KIDS">
        <!--<trait name ="semantic-domain-ddp4" value="2.1.8.3 Male organs"/>-->
        <xsl:choose>
            <!--Check if in sensitive semantic domain category. Note this should be done manually with a publication type-->
            <xsl:when test="trait[starts-with(@value,'2.1.8.3') or starts-with(@value,'2.1.8.4') or starts-with(@value,'2.6.2')]">
                <xsl:text>"</xsl:text>
                <xsl:text>0</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <!-- If not in sensitive category then mark with 1-->
            <xsl:otherwise>
                <!-- For now, indicated as yes with 1. Eventually need to treat this as a publication type or use a custom field FV_Games-->
                <xsl:text>"</xsl:text>
                <xsl:text>1</xsl:text>
                <xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
