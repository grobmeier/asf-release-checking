#!/bin/bash

source functions.sh

# Setze die URL
URL="https://dist.apache.org/repos/dist/dev/logging/log4j-tools/"
FOLDER="log4j-tools-distribution"

NAME="apache-log4j-tools-0.6.0"

download_and_verify_dist $URL "$NAME-bin.zip" $FOLDER
download_and_verify_dist $URL "$NAME-src.zip" $FOLDER

download_single_file $URL "$NAME-email-announce.txt" $FOLDER
download_single_file $URL "$NAME-email-vote.txt" $FOLDER
download_single_file $URL "$NAME-site.zip" $FOLDER