@echo off
setlocal enabledelayedexpansion

REM Imposta i percorsi dei file
set "INPUT_FILE=percorso\al\tuo\video.mp4"
set "OUTPUT_FILE=percorso\al\video_compresso_per_telegram.mp4"

REM Imposta il target bitrate (ridotto da 17768kbps)
set "TARGET_BITRATE=10000k"

REM Visualizza informazioni iniziali
echo ------------------------------------------------------
echo    COMPRESSIONE VIDEO PER TELEGRAM
echo ------------------------------------------------------
echo Input: %INPUT_FILE%
echo Output: %OUTPUT_FILE%
echo Target Bitrate: %TARGET_BITRATE%
echo ------------------------------------------------------
echo Compressione video in corso...

REM Comprimi il video con FFmpeg
ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 22 -b:v %TARGET_BITRATE% ^
       -maxrate 12000k -bufsize 15000k ^
       -c:a aac -b:a 192k ^
       "%OUTPUT_FILE%"

REM Visualizza le dimensioni del file originale e compresso
echo.
echo ------------------------------------------------------
echo Dimensione file originale:
for %%A in ("%INPUT_FILE%") do (
    set /a size_mb=%%~zA / 1048576
    echo %%~zA bytes (!size_mb! MB)
)

echo.
echo Dimensione file compresso:
for %%A in ("%OUTPUT_FILE%") do (
    if exist "%OUTPUT_FILE%" (
        set /a size_mb=%%~zA / 1048576
        echo %%~zA bytes (!size_mb! MB)
        
        REM Controlla se il file è sotto i 2GB
        if !size_mb! LEQ 2048 (
            echo [SUCCESSO] Il file è sotto il limite di 2GB di Telegram
        ) else (
            echo [ATTENZIONE] Il file è ancora sopra i 2GB. Prova a ridurre ulteriormente il bitrate.
        )
    ) else (
        echo [ERRORE] File di output non trovato!
    )
)

echo.
echo Compressione completata! Il file compresso è: %OUTPUT_FILE%
echo ------------------------------------------------------

pause