@echo off
setlocal enabledelayedexpansion

title Compressione Video con FFmpeg - Monitoraggio Frame

REM Imposta i percorsi dei file
set "INPUT_FILE=E:\folder\sample_file_4k.mp4"
set "OUTPUT_FILE=E:\folder\file_4k_compressed.mp4"

REM Estrai il nome del file senza percorso
for %%F in ("%INPUT_FILE%") do set "FILE_NAME=%%~nxF"
for %%F in ("%OUTPUT_FILE%") do set "OUTPUT_NAME=%%~nxF"

REM Imposta il target bitrate a circa 8500kbps
set "TARGET_BITRATE=8500k"

REM Ottieni informazioni sul file input
echo Analisi del file di input in corso...

REM Ottieni durata in secondi e framerate utilizzando json output che è più facile da parsare
for /f "delims=" %%a in ('ffprobe -v error -select_streams v:0 -of json -show_entries stream^=duration^,nb_frames "%INPUT_FILE%" 2^>nul') do (
    set "info=%%a"
    echo !info! | findstr "nb_frames" > nul
    if !errorlevel! equ 0 (
        for /f "tokens=2 delims=:, " %%b in ("!info!") do (
            set "TOTAL_FRAMES=%%b"
            set "TOTAL_FRAMES=!TOTAL_FRAMES:"=!"
            set "TOTAL_FRAMES=!TOTAL_FRAMES: =!"
        )
    )
)

REM Se nb_frames non è disponibile, prova a stimarlo usando durata e framerate
if not defined TOTAL_FRAMES (
    echo Impossibile ottenere il numero totale di frame direttamente, stimando...
    
    REM Ottieni la durata
    for /f "tokens=*" %%a in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%INPUT_FILE%" 2^>^&1') do (
        set "DURATION=%%a"
    )
    
    REM Ottieni il framerate
    for /f "tokens=*" %%a in ('ffprobe -v error -select_streams v:0 -show_entries stream^=avg_frame_rate -of default^=noprint_wrappers^=1:nokey^=1 "%INPUT_FILE%" 2^>^&1') do (
        set "FRAMERATE=%%a"
    )
    
    REM Gestisci il framerate nel formato x/y
    for /f "tokens=1,2 delims=/" %%a in ("!FRAMERATE!") do (
        set "num=%%a"
        set "den=%%b"
        if "!den!"=="" (
            set "FPS=!num!"
        ) else (
            set /a "FPS=!num! / !den!"
        )
    )
    
    REM Calcola il numero totale di frame (approssimato)
    set /a "TOTAL_FRAMES=(!DURATION! * !FPS!)"
    set "TOTAL_FRAMES=!TOTAL_FRAMES:.=!"
    set "TOTAL_FRAMES=!TOTAL_FRAMES:~0,-1!"
)

REM Se ancora non abbiamo un valore valido, usa un valore predefinito
if not defined TOTAL_FRAMES set "TOTAL_FRAMES=50000"
if "!TOTAL_FRAMES!"=="" set "TOTAL_FRAMES=50000"

echo Frame totali stimati: !TOTAL_FRAMES!

REM Mostra informazioni iniziali
echo.
echo +--------------------------------------------------------------+
echo ^|                   COMPRESSIONE VIDEO FFmpeg                  ^|
echo +--------------------------------------------------------------+
echo.
echo File di input: %FILE_NAME%
echo File di output: %OUTPUT_NAME%
echo Bitrate target: %TARGET_BITRATE%
echo Frame totali: !TOTAL_FRAMES!
echo.
echo Per interrompere la compressione in qualsiasi momento, premere CTRL+C
echo e confermare con 'Y', oppure premere 'q' sulla tastiera.
echo.
echo Premere INVIO per avviare la compressione...
pause > nul

REM Chiedi se sovrascrivere il file se esiste già
if exist "%OUTPUT_FILE%" (
    echo.
    echo ATTENZIONE: Il file di output esiste gia!
    echo Sovrascrivere il file esistente?
    set /p choice="Digita S per sovrascrivere o N per annullare: "
    if /i "!choice!" NEQ "S" (
        echo Operazione annullata.
        goto end
    )
)

REM Esegui FFmpeg con statistiche visibili ma senza log verboso
cls
echo +--------------------------------------------------------------+
echo ^|                      COMPRESSIONE IN CORSO                   ^|
echo +--------------------------------------------------------------+
echo.
echo File: %FILE_NAME%
echo Frame totali: !TOTAL_FRAMES!
echo.
echo Attendere, questa operazione potrebbe richiedere tempo...
echo Lo stato di avanzamento apparira qui sotto:
echo.

REM Esegui FFmpeg direttamente
ffmpeg -hide_banner -loglevel warning -stats -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 24 -b:v %TARGET_BITRATE% ^
       -maxrate 12000k -bufsize 15000k ^
       -c:a aac -b:a 192k ^
       -y ^
       "%OUTPUT_FILE%"

REM Verifica il codice di uscita di FFmpeg
if %errorlevel% equ 0 (
    REM Compressione completata con successo
    cls
    echo +--------------------------------------------------------------+
    echo ^|                   COMPRESSIONE COMPLETATA                    ^|
    echo +--------------------------------------------------------------+
    echo.
    
    REM Visualizza le dimensioni del file originale
    echo File originale: %FILE_NAME%
    for %%A in ("%INPUT_FILE%") do (
        set /a input_size=%%~zA
        set /a input_mb=!input_size! / 1048576
        echo Dimensione: !input_mb! MB
    )
    
    echo.
    REM Visualizza le dimensioni del file compresso
    echo File compresso: %OUTPUT_NAME%
    for %%A in ("%OUTPUT_FILE%") do (
        set /a output_size=%%~zA
        set /a output_mb=!output_size! / 1048576
        echo Dimensione: !output_mb! MB
    )
    
    REM Calcola la percentuale di spazio risparmiato
    set /a saved_mb=input_mb-output_mb
    set /a perc_saved=(saved_mb*100)/input_mb
    
    echo.
    echo +--------------------------------------------------------------+
    echo ^|                       STATISTICHE                           ^|
    echo +--------------------------------------------------------------+
    echo.
    echo Spazio risparmiato: !saved_mb! MB (!perc_saved!%%)
    
) else (
    REM Compressione interrotta o fallita
    cls
    echo +--------------------------------------------------------------+
    echo ^|                      PROCESSO INTERROTTO                     ^|
    echo +--------------------------------------------------------------+
    echo.
    echo La compressione e stata interrotta o si e verificato un errore.
    echo Controlla se il file di output e stato creato parzialmente.
)

:end
echo.
echo +--------------------------------------------------------------+
echo.
echo Premere un tasto per terminare...
pause > nul
