#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Keine Zip-Datei angegeben."
    echo "Verwendung: $0 [Name der Zip-Datei]"
    exit 1
fi

# Setze den Pfad zu deinem Zip-File und der Signatur-Datei
ZIP_FILE="$1"
SIGNATURE_FILE="${ZIP_FILE}.asc"
HASH_FILE="${ZIP_FILE}.sha512"
SIGNING_KEY="0x077E8893A6DCC33DD4A4D5B256E73BA9A0B592D0"

# Importiere den öffentlichen Schlüssel
echo "Importiere den öffentlichen Schlüssel..."
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $SIGNING_KEY

# Überprüfe den SHA-512-Hash
echo "Überprüfe SHA-512-Hash..."

# Berechne den SHA-512-Hash und speichere ihn in einer Variablen
CALCULATED_HASH=$(shasum -a 512 "$ZIP_FILE" | awk '{print $1}')

# Lese den erwarteten Hash aus der Datei
EXPECTED_HASH=$(awk '{print $1}' "$HASH_FILE")

echo "SHA512 CALCULATED: $CALCULATED_HASH"
echo "SHA512 EXPECTED  : $EXPECTED_HASH"

# Vergleiche die Hashwerte
if [ "$CALCULATED_HASH" = "$EXPECTED_HASH" ]; then
    echo "SHA-512-Hash stimmt überein."
else
    echo "SHA-512-Hash stimmt nicht überein!"
    exit 1
fi

# Überprüfe die PGP-Signatur
echo "Überprüfe PGP-Signatur..."
gpg --verify $SIGNATURE_FILE $ZIP_FILE

echo "Überprüfung abgeschlossen."
