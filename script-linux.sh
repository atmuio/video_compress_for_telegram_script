#!/bin/bash

# TelegramVideoCompressor - Script per Linux/macOS
# Comprime video di grandi dimensioni per Telegram mantenendo la massima qualità possibile

# Impostazioni di default
INPUT_FILE="percorso/al/tuo/video.mp4"
OUTPUT_FILE="percorso/al/video_compresso_per_telegram.mp4"
TARGET_BITRATE="10000k"
CRF=22
PRESET="slow"

# Funzione per visualizzare l'uso
function show_usage {
    echo "Uso: $0 -i [input_file] -o [output_file] [-b bitrate] [-c crf] [-p preset]"
    echo ""
    echo "Opzioni:"
    echo "  -i  File video di input (obbligatorio)"
    echo "  -o  File video di output (obbligatorio)"
    echo "  -b  Target bitrate (default: $TARGET_BITRATE)"
    echo "  -c  CRF value (default: $CRF, valori più bassi = qualità migliore)"
    echo "  -p  Preset di codifica (default: $PRESET, opzioni: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow)"
    echo ""
    echo "Esempio: $0 -i miovideo.mp4 -o video_compresso.mp4 -b 8000k -c 23 -p medium"
    exit 1
}

# Analizza i parametri
while getopts "i:o:b:c:p:h" opt; do
    case ${opt} in
        i )
            INPUT_FILE=$OPTARG
            ;;
        o )
            OUTPUT_FILE=$OPTARG
            ;;
        b )
            TARGET_BITRATE=$OPTARG
            ;;
        c )
            CRF=$OPTARG
            ;;
        p )
            PRESET=$OPTARG
            ;;
        h )
            show_usage
            ;;
        \? )
            show_usage
            ;;
    esac
done

# Verifica che i parametri obbligatori siano stati forniti
if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" ]]; then
    echo "Errore: I file di input e output sono obbligatori."
    show_usage
fi

# Verifica che il file di input esista
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Errore: Il file di input '$INPUT_FILE' non esiste."
    exit 1
fi

# Visualizza informazioni iniziali
echo "-----------------------------------------------------"
echo "    COMPRESSIONE VIDEO PER TELEGRAM"
echo "-----------------------------------------------------"
echo "Input: $INPUT_FILE"
echo "Output: $OUTPUT_FILE"
echo "Target Bitrate: $TARGET_BITRATE"
echo "CRF: $CRF"
echo "Preset: $PRESET"
echo "-----------------------------------------------------"
echo "Compressione video in corso..."

# Comprimi il video con FFmpeg
ffmpeg -i "$INPUT_FILE" \
       -c:v libx264 -preset $PRESET -crf $CRF -b:v $TARGET_BITRATE \
       -maxrate 12000k -bufsize 15000k \
       -c:a aac -b:a 192k \
       "$OUTPUT_FILE"

# Controlla se ffmpeg è terminato con successo
if [ $? -ne 0 ]; then
    echo "Errore durante la compressione del video."
    exit 1
fi

# Visualizza le dimensioni del file originale e compresso
echo ""
echo "Dimensione file originale:"
du -h "$INPUT_FILE"

echo ""
echo "Dimensione file compresso:"
du -h "$OUTPUT_FILE"

# Calcola le dimensioni in byte
ORIGINAL_SIZE=$(stat -c%s "$INPUT_FILE" 2>/dev/null || stat -f%z "$INPUT_FILE")
COMPRESSED_SIZE=$(stat -c%s "$OUTPUT_FILE" 2>/dev/null || stat -f%z "$OUTPUT_FILE")

# Converti byte in MB
ORIGINAL_MB=$((ORIGINAL_SIZE / 1048576))
COMPRESSED_MB=$((COMPRESSED_SIZE / 1048576))

echo ""
echo "Dimensioni in MB:"
echo "Originale: $ORIGINAL_MB MB"
echo "Compresso: $COMPRESSED_MB MB"

# Controlla se il file è sotto i 2GB
if [ $COMPRESSED_MB -le 2048 ]; then
    echo "[SUCCESSO] Il file è sotto il limite di 2GB di Telegram"
else
    echo "[ATTENZIONE] Il file è ancora sopra i 2GB. Prova a ridurre ulteriormente il bitrate."
fi

echo ""
echo "Compressione completata! Il file compresso è: $OUTPUT_FILE"
echo "-----------------------------------------------------"