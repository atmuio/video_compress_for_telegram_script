@echo off
setlocal enabledelayedexpansion

REM Imposta i percorsi dei file
set "INPUT_FILE=E:\folder\sample_file_4k.mp4"
set "OUTPUT_FILE=E:\folder\file_4k_compressed.mp4"

REM Imposta il target bitrate a circa 10000kbps (ridotto dal tuo 17768kbps)
set "TARGET_BITRATE=10000k"

REM Comprimi il video
echo Compressione video in corso...
ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 22 -b:v %TARGET_BITRATE% ^
       -maxrate 12000k -bufsize 15000k ^
       -c:a aac -b:a 192k ^
       "%OUTPUT_FILE%"

REM Visualizza le dimensioni del file originale e compresso
echo.
echo Dimensione file originale:
for %%A in ("%INPUT_FILE%") do echo %%~zA bytes (%%~zA / 1048576 MB)

echo Dimensione file compresso:
for %%A in ("%OUTPUT_FILE%") do echo %%~zA bytes (%%~zA / 1048576 MB)

echo.
echo Compressione completata! Il file compresso è: %OUTPUT_FILE%
echo.

pause
