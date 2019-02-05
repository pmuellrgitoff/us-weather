#!/usr/bin/env bash

echo "building web resources in the docs dir"

# set directory names
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_DIR="$SCRIPT_DIR/.."
SRC_DIR="$BASE_DIR/src"
DIST_DIR="$BASE_DIR/docs"
NODE_MODULES_DIR="$BASE_DIR/node_modules"

PATH="$BASE_DIR/tools:$BASE_DIR/node_modules/.bin:$PATH"

# clean the dist directory
rm -rf "$DIST_DIR"

# copy the html
echo "copying html files"
mkdir -p "$DIST_DIR"
cp -R "$SRC_DIR/"*.html "$DIST_DIR"

# copy the images
echo "copying image files"
mkdir -p "$DIST_DIR/images"
cp -R "$SRC_DIR/images/" "$DIST_DIR/images"

# copy leaflet images
cp -R "$NODE_MODULES_DIR/leaflet/dist/images/" "$DIST_DIR/images"

# build css 
echo ""
echo "building css files"
lessc "$SRC_DIR/css/index.less" "$DIST_DIR/index.css"
RC=$?
if [ $RC -ne 0 ]
then
  exit $RC
fi

# check for dev mode
WEBPACK_ARGS=
if [[ ! -z "$DEV_MODE" ]]
then
  WEBPACK_ARGS=--env.development
fi

echo ""
echo "building js files"
webpack $WEBPACK_ARGS
RC=$?
if [ $RC -ne 0 ]
then
  exit $RC
fi

# update built-on.txt file
echo ""
date "+%Y-%m-%d %H:%M:%S" > $DIST_DIR/built-on.txt
exit 0
