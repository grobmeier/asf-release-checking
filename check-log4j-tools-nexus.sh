#!/bin/bash

source functions.sh

# Setze die URL
URL="https://repository.apache.org/content/repositories/orgapachelogging-1233/org/apache/logging/log4j/log4j-changelog-maven-plugin/0.6.0/"
FOLDER="log4j-changelog-maven-plugin"

# Dateien herunterladen
download_and_verify $URL "log4j-changelog-maven-plugin-0.6.0-cyclonedx.xml" $FOLDER
download_and_verify $URL "log4j-changelog-maven-plugin-0.6.0-sources.jar" $FOLDER
download_and_verify $URL "log4j-changelog-maven-plugin-0.6.0.jar" $FOLDER
download_and_verify $URL "log4j-changelog-maven-plugin-0.6.0.pom" $FOLDER

URL="https://repository.apache.org/content/repositories/orgapachelogging-1233/org/apache/logging/log4j/log4j-changelog/0.6.0/"
FOLDER="log4j-changelog"

NAME="log4j-changelog-0.6.0"
download_and_verify $URL "$NAME-cyclonedx.xml" $FOLDER
download_and_verify $URL "$NAME-sources.jar" $FOLDER
download_and_verify $URL "$NAME.jar" $FOLDER
download_and_verify $URL "$NAME.pom" $FOLDER