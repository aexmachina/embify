#!/bin/bash

dir="$( dirname "$( dirname $0 )" )"
cd "$dir/server/node_modules/node-spotify" \
  && node-gyp configure \
  && node-gyp build --debug
