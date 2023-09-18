#!/bin/sh

cd /quartz

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION

mv $SOURCE_DIRECTORY/* /quartz/content/

# config
if [ -n "$INPUT_QUARTZ_CONFIG" ]; then
    echo "Copying custom config (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG -> $(pwd)/)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG .
else
    wget -O temp.quartz.config.ts https://raw.githubusercontent.com/jackyzha0/quartz/v4/quartz.config.ts

    sed -e 's/pageTitle: "[^"]*"/pageTitle: "'"$INPUT_PAGE_TITLE"'"/' \
        temp.quartz.config.ts > quartz.config.ts
fi

# theme
if [ -n "$INPUT_QUARTZ_LAYOUT" ]; then
    echo "Copying custom layout (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT -> $(pwd)/)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT .
fi

# build
npx quartz build -o $DESTINATION_DIRECTORY -v

# icon/banner
if [ -n "$INPUT_QUARTZ_ICON" ]; then
    echo "Copying custom layout (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_ICON -> $DESTINATION_DIRECTORY/static/icon.png)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_ICON $DESTINATION_DIRECTORY/static/icon.png
fi

if [ -n "$INPUT_QUARTZ_BANNER" ]; then
    echo "Copying custom banner (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_BANNER -> $DESTINATION_DIRECTORY/static/og-image.png)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_BANNER $DESTINATION_DIRECTORY/static/og-image.png
fi
