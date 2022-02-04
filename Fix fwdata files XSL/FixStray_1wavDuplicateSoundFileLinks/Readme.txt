Get list of stray file from the First Voices import process
(better yet build a validator of the fwdata file with respect to sound files in the AudioVisual Folder)
Also look for double sound files in the AudioWritingSystem ... not sure how those are getting created but they are.

Put list into strayfilelist.xml
Use FixStrayFileLinks.xsl on fwdata file. 

Scrub the above

There are 378 _1.wav links between LexemeForm Audio and Example Sentence Audio. 7 of them are shared across the same entry. 

There are 388 sound files that end in _1.wav.  

Do a search and replace on fwdata getting rid of _1.wav. Run 

There are approx 380+ sound files as problematic from FV import routine. What is the Venn diagram on the three areas above? There does not seem to be overlap.



