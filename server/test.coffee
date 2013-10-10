config = require './config'
spotify = require './node_modules/node-spotify/build/Debug/spotify'

spotify.login(
  config.spotify.username, config.spotify.password, 
  rememberMe = false, withRemembered = false
)
spotify.ready ->
  playlists = spotify.getPlaylists()
  for playlist in playlists
    debugger
    console.log playlist
