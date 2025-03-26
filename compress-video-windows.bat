@echo off
setlocal enabledelayedexpansion

REM Imposta i percorsi dei file
set "INPUT_FILE=E:\folder\sample_file_4k.mp4"
set "OUTPUT_FILE=E:\folder\file_4k_compressed.mp4"
set "PROGRESS_FILE=%TEMP%\ffmpeg_progress.txt"

REM Imposta il target bitrate a circa 8500kbps
set "TARGET_BITRATE=8500k"

REM Ottieni la durata del video
for /f "tokens=*" %%a in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%INPUT_FILE%"') do (
    set "TOTAL_DURATION=%%a"
)

echo Durata totale del video: !TOTAL_DURATION! secondi

REM Comprimi il video con output del progresso
echo Compressione video in corso...
echo.

REM Avvia FFmpeg con output di progresso
start /B cmd /c "ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 24 -b:v %TARGET_BITRATE% ^
       -maxrate 12000k -bufsize 15000k ^
       -c:a aac -b:a 192k ^
       -progress "%PROGRESS_FILE%" ^
       "%OUTPUT_FILE%" 2>&1"

REM Visualizza il progresso
:progress_loop
if not exist "%PROGRESS_FILE%" (
    ping -n 2 127.0.0.1 > nul
    goto progress_loop
)

:read_progress
set "current_time="
set "speed="
set "progress="
set "time_remaining="

for /f "tokens=1,2 delims==" %%a in ('type "%PROGRESS_FILE%"') do (
    if "%%a"=="out_time_ms" (
        set /a "current_ms=%%b / 1000"
        set /a "current_time=!current_ms! / 1000"
    )
    if "%%a"=="speed" (
        set "speed=%%b"
    )
    if "%%a"=="progress" (
        set "progress=%%b"
    )
)

REM Calcola il tempo rimanente stimato
if defined current_time if defined TOTAL_DURATION if defined speed (
    for /f "tokens=1 delims=." %%s in ("!speed!") do (
        set "speed_value=%%s"
        if !speed_value! GTR 0 (
            set /a "remaining_seconds=(!TOTAL_DURATION! - !current_time!) / !speed_value!"
            set /a "remaining_minutes=!remaining_seconds! / 60"
            set /a "remaining_seconds=!remaining_seconds! %% 60"
            set "time_remaining=!remaining_minutes!m !remaining_seconds!s"
        ) else (
            set "time_remaining=Calcolando..."
        )
    )
) else (
    set "time_remaining=Calcolando..."
)

cls
echo Compressione video in corso...
echo.
if defined current_time if defined TOTAL_DURATION (
    set /a "percent=(!current_time! * 100) / !TOTAL_DURATION!"
    echo Progresso: !percent!%% completato
) else (
    echo Progresso: Calcolando...
)
echo Tempo trascorso: !current_time! secondi
echo Velocità: !speed!x
echo Tempo stimato rimanente: !time_remaining!
echo.
echo Premere CTRL+C per interrompere...

if "!progress!"=="end" goto encoding_completed

REM Loop ogni secondo
ping -n 2 127.0.0.1 > nul
goto read_progress

:encoding_completed
del "%PROGRESS_FILE%" 2>nul

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
