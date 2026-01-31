#!/bin/sh

set -e

QUARTZ_REPO=${INPUT_QUARTZ_REPO:-https://github.com/jackyzha0/quartz.git}
QUARTZ_REF=${INPUT_QUARTZ_REPO_REF:-v4}

echo "Cloning Quartz from ${QUARTZ_REPO} (ref: ${QUARTZ_REF})"
git clone --depth 1 --branch "${QUARTZ_REF}" "${QUARTZ_REPO}" /quartz

cd /quartz

npm ci
npx quartz create -X new -l shortest

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION

# config
if [ -n "$INPUT_QUARTZ_CONFIG" ]; then
    echo "Copying custom config (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG -> $(pwd)/)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CONFIG .
else
    sed -i -e 's/pageTitle: "[^"]*"/pageTitle: "'"$INPUT_PAGE_TITLE"'"/' \
           -e 's/baseUrl: "[^"]*"/baseUrl: "'"$INPUT_PAGE_BASE_URL"'"/' \
           quartz.config.ts
fi

# theme
if [ -n "$INPUT_QUARTZ_LAYOUT" ]; then
    echo "Copying custom layout (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT -> $(pwd)/)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_LAYOUT .
fi

# icon/banner
if [ -n "$INPUT_QUARTZ_ICON" ]; then
    echo "Copying custom layout (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_ICON -> $DESTINATION_DIRECTORY/static/icon.png)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_ICON /quartz/quartz/static/icon.png
fi

if [ -n "$INPUT_QUARTZ_BANNER" ]; then
    echo "Copying custom banner (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_BANNER -> $DESTINATION_DIRECTORY/static/og-image.png)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_BANNER /quartz/quartz/static/og-image.png
fi

# custom.css
if [ -n "$INPUT_QUARTZ_CUSTOM_CSS" ]; then
    echo "Copying custom css (${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CUSTOM_CSS -> $(pwd)/styles/custom.scss)"
    cp ${GITHUB_WORKSPACE}/$INPUT_QUARTZ_CUSTOM_CSS /quartz/quartz/styles/custom.scss
fi

# content
mv $SOURCE_DIRECTORY/* /quartz/content/

# build
npx quartz build -o $DESTINATION_DIRECTORY -v
