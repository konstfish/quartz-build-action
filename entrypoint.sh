#!/bin/sh

cd /quartz

SOURCE_DIRECTORY=../${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION

if [ -n "$INPUT_QUARTZ_CONFIG" ]; then
    echo "Copying custom config"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG .
else
    wget -O temp.quartz.config.ts https://raw.githubusercontent.com/jackyzha0/quartz/v4/quartz.config.ts


    sed -e 's/pageTitle: "[^"]*"/pageTitle: "'"$INPUT_PAGE_TITLE"'"/' temp.quartz.config.ts > quartz.config.ts
fi

if [ -n "$INPUT_QUARTZ_LAYOUT" ]; then
    echo "Copying custom layout"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT .
fi

npx quartz build -d $SOURCE_DIRECTORY -o $DESTINATION_DIRECTORY -v