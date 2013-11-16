#!/bin/bash

dir="$( dirname "$( dirname $0 )" )"
cd "$dir/server" \
  && nodemon $@ \
      --watch "dnode-server.coffee" \
      --watch "lib/dnode/" \
      --watch "lib/spotify-adapter.coffee" \
      --watch "node_modules/dnode-object/" \
      dnode-server.coffee
