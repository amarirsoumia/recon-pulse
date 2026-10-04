#!/bin/bash

# 1. Initialization
INPUT_FILE=""
REPORT_FILE=""
TARGET_PORTS=""

# 2. CLI Parser (getopts)
while getopts "f:o:p:h" opt; do
    case "$opt" in
        f) INPUT_FILE="$OPTARG" ;;
        o) REPORT_FILE="$OPTARG" ;;
        p) TARGET_PORTS="$OPTARG" ;;
        h) 
           echo "Usage: $0 -f <targets_file> [-o report_file] [-p ports]"
           exit 0
           ;;
        ?) 
           echo "[!] Invalid option! Use -h for help."
           exit 1
           ;;
    esac
done

# 3. Defensive Sanity Checks
if [ -z "$INPUT_FILE" ]; then
    echo "[!] Error: Missing required targets file (-f)."
    echo "Usage: $0 -f <targets_file> [-o report_file] [-p ports]"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "[!] Error: Target file '$INPUT_FILE' not found!"
    exit 1
fi

# 4. Main Reconnaissance Engine
echo "[+] Initializing host discovery on: $INPUT_FILE"

while IFS= read -r host; do
    [ -z "$host" ] && continue

    if ping -c 1 -W 1 "$host" > /dev/null 2>&1; then
        echo "[+] Host $host -> ALIVE"
        [ -n "$REPORT_FILE" ] && echo "$host" >> "$REPORT_FILE"
    else
        echo "[-] Host $host -> UNREACHABLE"
    fi
done < "$INPUT_FILE"

echo "[+] Reconnaissance task completed successfully!" 
