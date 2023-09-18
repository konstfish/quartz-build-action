#!/bin/sh

cd /quartz

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION

mv $SOURCE_DIRECTORY /quartz/content

# config
if [ -n "$INPUT_QUARTZ_CONFIG" ]; then
    echo "Copying custom config"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG .
else
    wget -O temp.quartz.config.ts https://raw.githubusercontent.com/jackyzha0/quartz/v4/quartz.config.ts

    sed -e 's/pageTitle: "[^"]*"/pageTitle: "'"$INPUT_PAGE_TITLE"'"/' \
        temp.quartz.config.ts > quartz.config.ts
fi

# theme
if [ -n "$INPUT_QUARTZ_LAYOUT" ]; then
    echo "Copying custom layout"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT .
fi

# icon/banner
if [ -n "$INPUT_QUARTZ_" ]; then
    echo "Copying custom layout"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT .
fi

npx quartz build -o $DESTINATION_DIRECTORY -v