#!/bin/bash

dir="$( dirname "$( dirname $0 )" )"
cd "$dir/server" \
  && nodemon --watch app --watch node_modules/node-spotify/build/Debug --debug -e coffee,js wrapper.js
