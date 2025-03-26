# TelegramVideoCompressor

Script per comprimere video di grandi dimensioni per Telegram mantenendo la massima qualità possibile. Telegram ha un limite di 2GB per i file nella versione gratuita, e questo strumento ti aiuta a comprimere i tuoi video sotto questo limite.

## 📋 Prerequisiti

- **Windows** (lo script è compatibile con Windows 7/8/10/11)
- **FFmpeg** installato sul tuo sistema

## 🚀 Installazione di FFmpeg

### Metodo 1: Installazione manuale

1. **Scarica FFmpeg**:
   - Visita [ffmpeg.org/download](https://ffmpeg.org/download.html) o [BtbN's FFmpeg Builds](https://github.com/BtbN/FFmpeg-Builds/releases)
   - Scarica la versione "Full" o "Essentials" (preferibilmente la versione "static")

2. **Estrai i file**:
   - Estrai il contenuto del file ZIP in una cartella (esempio: `C:\FFmpeg`)
   - La cartella dovrebbe contenere una sottocartella `bin` con gli eseguibili

3. **Aggiungi FFmpeg al Path di sistema**:
   - Cerca "Environment variables" nel menu Start
   - Clicca su "Edit the system environment variables"
   - Nella finestra "System Properties", clicca su "Environment Variables..."
   - Nella sezione "System variables", trova "Path" e selezionala
   - Clicca su "Edit..."
   - Clicca su "New" e aggiungi il percorso alla cartella bin (es. `C:\FFmpeg\bin`)
   - Clicca "OK" per chiudere tutte le finestre

4. **Verifica l'installazione**:
   - Apri un nuovo prompt dei comandi (cmd)
   - Digita `ffmpeg -version`
   - Se vedi le informazioni sulla versione, l'installazione è riuscita

### Metodo 2: Usando Chocolatey (Package Manager per Windows)

Se hai [Chocolatey](https://chocolatey.org/) installato, esegui:

```
choco install ffmpeg
```

## 📥 Download e Utilizzo

1. **Scarica lo Script**:
   - Clona questo repository o scarica il file `compress_for_telegram.bat`

2. **Configura lo Script**:
   - Apri `compress_for_telegram.bat` con un editor di testo
   - Modifica queste righe con i percorsi corretti:
     ```batch
     set "INPUT_FILE=percorso\al\tuo\video.mp4"
     set "OUTPUT_FILE=percorso\al\video_compresso_per_telegram.mp4"
     ```

3. **Esegui lo Script**:
   - Fai doppio clic su `compress_for_telegram.bat`
   - Lo script inizierà a comprimere il video e mostrerà i progressi

## ⚙️ Personalizzazione delle Impostazioni

Puoi personalizzare le impostazioni di compressione modificando i seguenti parametri nello script:

- **TARGET_BITRATE**: Imposta il bitrate target per il video (default: `10000k`)
  ```batch
  set "TARGET_BITRATE=10000k"  # Modifica questo valore
  ```

- **CRF (Constant Rate Factor)**: Controlla la qualità (valori più bassi = qualità migliore)
  ```batch
  ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 22 ...  # Modifica il valore del CRF
  ```

- **PRESET**: Controlla la velocità di codifica vs compressione
  ```batch
  ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow ...  # Cambia 'slow' con 'medium', 'fast', ecc.
  ```

## 📊 Guida ai Parametri di Compressione

### Bitrate

| Risoluzione | Bitrate Consigliato | Note                  |
|-------------|---------------------|------------------------|
| 4K (2160p)  | 15000k-20000k       | Per alta qualità       |
| 2K (1440p)  | 10000k-15000k       | Impostazione di default|
| Full HD     | 8000k-10000k        | Buon compromesso       |
| HD (720p)   | 5000k-7000k         | Per file più piccoli   |

### CRF (Constant Rate Factor)

| Valore CRF | Qualità        | Note                         |
|------------|----------------|------------------------------|
| 18-20      | Molto alta     | Quasi lossless, file grandi  |
| 21-24      | Alta           | Default, buon compromesso    |
| 25-28      | Media          | Compressione maggiore        |
| 29+        | Bassa          | File piccoli, qualità ridotta|

## 🧩 Esempi Pratici

### Esempio 1: Compressione di un Video 4K

```batch
set "INPUT_FILE=C:\Videos\mio_video_4k.mp4"
set "OUTPUT_FILE=C:\Videos\mio_video_4k_compresso.mp4"
set "TARGET_BITRATE=15000k"
```

### Esempio 2: Compressione Massima per File Molto Grandi

```batch
set "INPUT_FILE=C:\Videos\video_enorme.mp4"
set "OUTPUT_FILE=C:\Videos\video_compresso.mp4"
set "TARGET_BITRATE=7000k"
```

Modifica anche il valore CRF:
```batch
ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset slow -crf 26 -b:v %TARGET_BITRATE% ...
```

### Esempio 3: Mantenere Alta Qualità con Video HD

```batch
set "INPUT_FILE=C:\Videos\videohd.mp4"
set "OUTPUT_FILE=C:\Videos\videohd_compresso.mp4"
set "TARGET_BITRATE=8000k"
```

Modifica anche il valore CRF:
```batch
ffmpeg -i "%INPUT_FILE%" -c:v libx264 -preset veryslow -crf 20 -b:v %TARGET_BITRATE% ...
```

## ❓ Problemi Comuni e Soluzioni

### Errore "Protocol not found"

**Problema**: `Error opening output file: Protocol not found`

**Soluzione**: Assicurati che il percorso di output inizi con la lettera del drive (es. `C:\path\to\file.mp4`)

### Errore "File not found"

**Problema**: `No such file or directory`

**Soluzione**: Verifica che il percorso del file di input sia corretto e che non contenga caratteri speciali problematici

### Errore con percorsi contenenti spazi

**Problema**: `Error splitting the argument list`

**Soluzione**: Assicurati che i percorsi con spazi siano tra virgolette doppie:
```batch
set "INPUT_FILE=C:\My Videos\video file.mp4"
```

## 🔄 Alternative con Interfaccia Grafica

Se preferisci una soluzione con interfaccia grafica:

- **[HandBrake](https://handbrake.fr/)**: Open source e facile da usare
- **[XMedia Recode](https://www.xmedia-recode.de/en/)**: Versatile con molte opzioni
- **[Any Video Converter](https://www.any-video-converter.com/)**: Semplice e intuitivo

## 📜 Licenza

Questo progetto è distribuito con licenza MIT. Sentiti libero di utilizzarlo e modificarlo come preferisci.

## 👥 Contributi

Contributi, problemi e richieste di funzionalità sono benvenuti! Non esitare ad aprire un issue o una pull request.
