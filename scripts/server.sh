#!/bin/bash

dir="$( dirname "$( dirname $0 )" )"
cd "$dir/server" \
  && nodemon $@ \
      --watch "lib" \
      --watch "node_modules/node-spotify/build/Debug" \
      main.coffee
