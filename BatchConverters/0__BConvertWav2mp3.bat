@REM Converts Wav to mp3
@REM and copies all wavs from Linked Files\AudioVisual if they do not yet exist to the web\mp3s directory
@REM and then resizes ALL jpgs in the web "jpgs" directory
@REM larry_hayashi@sil.org
@echo on

@REM CALLS 000PARAMETERS.bat which has a list of source and destination directories.
@call .\000parameters.bat

@REM Goes through subdirectories of AUDIOVISUAL with each media file and converts it to mp3 if it does not exist
REM @echo off

setlocal
set dir1=%SOURCE_AUDIOVISUAL_DIRECTORY%
set dir2=%DEST_MP3S_DIRECTORY%

REM Get the path of this batch file.
REM dpI - expands %I to a drive letter and path only. When I=0, 0 is the calling file. i.e. this batch file.
cd "%~dp0"

REM Replicate tree. 
REM No real reason to create the SOURCE dir1 if not exist but we do anyhow.
REM Create DEST dir2 if not exist.
REM Then copy the directory structure not including files from SOURCE to DEST.
if not exist "%dir1%" md "%dir1%"
if not exist "%dir2%" md "%dir2%"

REM Not sure why but the presence of mp3s in the directory forces the xcopy to ask if it should overwrite it.
xcopy /t /e /Y "%dir1%" "%dir2%"

REM Get length of absolute path of dir1
REM This is kind of a crazy way to get the length of the string in the dir1.
REM This length will be used to help create a path for the relativesubfolder below.
<nul set /p "=%dir1%" >getLength.tmp
for %%F in (getLength.tmp) do set len=%%~zF
del getLength.tmp
REM Use below for testing code
REM echo %len%
REM pause


REM Process the files

REM Loops through directories in dir1 and all files contained within
for /r "%dir1%" %%F in (*) do ( 
  REM Refer to 000BatchDocumentation.txt for more info about ~_ values.
  set src=%%F
  set drive=%%~dF
  set path=%%~pF
  set filename=%%~nF
  set extension=%%~xF

  setlocal enableDelayedExpansion
  
  
  REM Use these for testing this batch file
  REM echo !relativesubfolder! "help"
  REM echo !src!
  REM echo !drive!
  REM echo !path!
  REM echo !filename!
  REM echo !extension!
  REM echo !relativesubfolder!
  
  
  REM First we put the drive letter and the full pathname minus the filename into relativesubfolder
  set relativesubfolder=!drive!!path!
  REM Then we subtract the length (:~NUMBER_from_end_of_variable_string) of the SOURCE dir1 from relativesubfolder and store it afresh in relativesubfolder
  set relativesubfolder=!relativesubfolder:~%len%!
  
  
  
  REM If the file in question is a wav file then we convert it to MP3
  if !extension!==.wav (
    REM We set newPathFilename with a new extension because we are converting the wav file to mp3 using LAME encoder
    REM dir2:~1,-1 pulls off the first character and the last character from dir2 which is the quotation marks
    set newPathFileName="!dir2:~1,-1!!relativesubfolder!!filename!.mp3"
    echo !newPathFileName!  
    if NOT exist !newPathFileName! "C:\Program Files (x86)\Lame For Audacity\lame.exe" --vbr-new -V 8 -b 16 -F -B -a -m m -q 1 --nohist "%%F" !newPathFileName!
  )

  REM If the file in question is an mp3 file, we simply copy it over as is.
  if !extension!==.mp3 (
    set newPathFileName="!dir2:~1,-1!!relativesubfolder!!filename!.mp3"
    echo !newPathFileName!
    if NOT exist !newPathFileName! copy /Y "!src!" "!newPathFileName!"
  )
  endlocal
REM pause
)
echo(
echo Done!
echo(
REM pause