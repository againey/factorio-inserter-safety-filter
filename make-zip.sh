#!/bin/bash

MODNAME='inserter-safety-filter'
VERSION=$1
ZIPFILE="${MODNAME}_${VERSION}.zip"
DIRECTORY=$MODNAME
EXCLUDE="${DIRECTORY}/make-zip.sh ${DIRECTORY}/thumbnail-filter-blacklist-item.png ${DIRECTORY}/thumbnail-data.lua ${DIRECTORY}/TODO.md ${DIRECTORY}/.editorconfig ${DIRECTORY}/${MODNAME}_*.zip"

find . -name "${MODNAME}_*.zip" -delete
cd ..
zip -r $DIRECTORY/$ZIPFILE $DIRECTORY -x $DIRECTORY/.git\* $EXCLUDE
cd $DIRECTORY
