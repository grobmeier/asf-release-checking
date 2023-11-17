#!/bin/bash

# Funktion zum Herunterladen von Dateien und ihren Signaturen
download_files() {
    local url=$1
    local filename=$2
    local folder=$3

    # Erstelle den Ordner, falls er nicht existiert
    mkdir -p "$folder"

    # Überprüfe, ob die Datei existiert, und lade sie herunter, falls nicht
    for ext in '' '.asc' '.md5' '.sha1'
    do
        local filepath="$folder/$filename$ext"
        if [ ! -f "$filepath" ]; then
            echo "Lade $filepath herunter..."
            wget --no-check-certificate -q -P "$folder" "$url/$filename$ext"
        else
            echo "$filepath existiert bereits, Überspringen des Downloads."
        fi
    done
}

download_single_file() {
    local url=$1
    local filename=$2
    local folder=$3

    # Erstelle den Ordner, falls er nicht existiert
    mkdir -p "$folder"

    # Überprüfe, ob die Datei existiert, und lade sie herunter, falls nicht
    local filepath="$folder/$filename"
    if [ ! -f "$filepath" ]; then
        echo "Lade $filepath herunter..."
        wget --no-check-certificate -q -P "$folder" "$url/$filename"
    else
        echo "$filepath existiert bereits, Überspringen des Downloads."
    fi
}

download_files_dist() {
    local url=$1
    local filename=$2
    local folder=$3

    # Erstelle den Ordner, falls er nicht existiert
    mkdir -p "$folder"

    # Überprüfe, ob die Datei existiert, und lade sie herunter, falls nicht
    for ext in '' '.asc' '.sha512'
    do
        local filepath="$folder/$filename$ext"
        if [ ! -f "$filepath" ]; then
            echo "Lade $filepath herunter..."
            wget --no-check-certificate -q -P "$folder" "$url/$filename$ext"
        else
            echo "$filepath existiert bereits, Überspringen des Downloads."
        fi
    done
}

# Funktion zur Überprüfung der PGP-Signatur
verify_signature() {
    local file=$1
    local folder=$2

    echo "Überprüfe die PGP-Signatur für $file..."
    # gpg --status-fd 2 --verify "$folder/$file.asc" "$folder/$file"

    if gpg --status-fd 2 --verify "$folder/$file.asc" "$folder/$file" 2>/dev/null; then
        echo -e "\033[32mGPG-Prüfung erfolgreich\033[0m"
    else
        echo -e "\033[31mGPG-Prüfung fehlgeschlagen\033[0m"
        exit 1
    fi
}

# Funktion zur Überprüfung der MD5-Hashes
verify_md5() {
    local file=$1
    local folder=$2
    local expected_hash=$(cat "$folder/$file.md5")

    echo "Überprüfe den MD5-Hash für $file..."

    # Berechne den aktuellen MD5-Hash des Files
    local calculated_hash=$(md5 -q "$folder/$file")

    # Vergleiche die Hashwerte
    if [ "$calculated_hash" = "$expected_hash" ]; then
        echo -e "\033[32mMD5-Hash stimmt überein: $file\033[0m"
    else
        echo -e "\033[31mMD5-Hash stimmt NICHT überein: $file\033[0m"
        exit 1
    fi
}

# Funktion zur Überprüfung der SHA1-Hashes
verify_sha1() {
    local file=$1
    local folder=$2
    local expected_hash=$(cat "$folder/$file.sha1")

    echo "Überprüfe den SHA1-Hash für $file..."

    # Berechne den aktuellen SHA1-Hash des Files
    local calculated_hash=$(shasum -a 1 "$folder/$file" | awk '{print $1}')

    # Vergleiche die Hashwerte
    if [ "$calculated_hash" = "$expected_hash" ]; then
        echo -e "\033[32mSHA1-Hash stimmt überein. $file\033[0m"
    else
        echo -e "\033[31mSHA1-Hash stimmt NICHT überein! $file\033[0m"
        exit 1
    fi
}


# Funktion zur Überprüfung des SHA-512-Hashes
verify_sha512() {
    local file=$1
    local hash_file=$2
    local folder=$3

    local full_file_path="$folder/$file"
    local full_hash_file_path="$folder/$hash_file"

    echo "Überprüfe SHA-512-Hash für $full_file_path..."

    # Berechne und vergleiche den SHA-512-Hash
    local calculated_hash=$(shasum -a 512 "$full_file_path" | awk '{print $1}')
    local expected_hash=$(awk '{print $1}' "$full_hash_file_path")

    echo "SHA512 CALCULATED: $calculated_hash"
    echo "SHA512 EXPECTED  : $expected_hash"

    if [ "$calculated_hash" = "$expected_hash" ]; then
         echo -e "\033[32mSHA512-Hash stimmt überein. $file\033[0m"
    else
         echo -e "\033[31mSHA512-Hash stimmt NICHT überein! $file\033[0m"
        exit 1
    fi
}

import_public_key() {
    local signing_key=$1
    echo "Importiere den öffentlichen Schlüssel..."
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $signing_key
}

# Herunterladen und Überprüfen der Dateien
download_and_verify() {
    local url=$1
    local filename=$2
    local folder=$3

    download_files $URL $filename $FOLDER
    verify_signature $filename $FOLDER
    verify_md5 $filename $FOLDER 
    verify_sha1 $filename $FOLDER
}

download_and_verify_dist() {
    local url=$1
    local filename=$2
    local folder=$3
    local signing_key=$4

    import_public_key $signing_key
    download_files_dist $url $filename $folder
    verify_signature $filename $folder
    verify_sha512 $filename "$filename.sha512" $folder
}



