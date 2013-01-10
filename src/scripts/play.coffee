# Description:
#   Play music. At your office. Like a boss. https://github.com/play/play
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PLAY_URL
#   HUBOT_PLAY_TOKEN
#
# Commands:
#   hubot play - Plays music.
#   hubot play next - Plays the next song.
#   hubot play previous - Plays the previous song.
#   hubot what's playing - Returns the currently-played song.
#   hubot what's next - Returns next song in the queue.
#   hubot I want this song - Returns a download link for the current song.
#   hubot I want this album - Returns a download link for the current album.
#   hubot play <artist> - Queue up ten songs from a given artist.
#   hubot play <album> - Queue up an entire album.
#   hubot play <song> - Queue up a particular song. This grabs the first song by playcount.
#   hubot play <something> right [fucking] now - Play this shit right now.
#   hubot where's play - Gives you the URL to the web app.
#   hubot volume? - Returns the current volume level.
#   hubot volume [0-100] - Sets the volume.
#   hubot be quiet - Mute play.
#   hubot say <message> - `say` your message over your speakers.
#   hubot clear play - Clears the Play queue.
#
# Author:
#   holman

URL = "#{process.env.HUBOT_PLAY_URL}"

authedRequest = (message, path, action, options, callback) ->
  message.http("#{URL}#{path}")
    .query(login: message.message.user.githubLogin, token: "#{process.env.HUBOT_PLAY_TOKEN}")
    .header('Content-Length', 0)
    .query(options)[action]() (err, res, body) ->
      callback(err,res,body)

module.exports = (robot) ->
  robot.respond /where'?s play/i, (message) ->
    message.finish()
    authedRequest message, '/stream_url', 'get', {}, (err, res, body) ->
      message.send("play's at #{URL} and you can stream from #{body}")

  robot.respond /what'?s playing/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)
      str = "\"#{json.name}\" by #{json.artist}, from \"#{json.album}\"."
      message.send("#{URL}/images/art/#{json.id}.png?login=HOTFIX#.jpg")
      message.send("Now playing " + str)

  robot.respond /what'?s next/i, (message) ->
    authedRequest message, '/queue', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)
      song = json.songs[1]
      if typeof(song) == "object"
        message.send("We will play this awesome track \"#{song.name}\" by #{song.artist} in just a minute!")
      else
        message.send("The queue is empty :( Try adding some songs, eh?")

  robot.respond /say (.*)/i, (message) ->
    authedRequest message, '/say', 'post', {message: message.match[1]}, (err, res, body) ->
      message.send(message.match[1])

  robot.respond /play next/i, (message) ->
    message.finish()
    authedRequest message, '/next', 'put', {}, (err, res, body) ->
      json = JSON.parse(body)
      message.send("On to the next one (which conveniently is #{json.artist}'s \"#{json.name}\")")


  #
  # VOLUME
  #

  robot.respond /app volume\?/i, (message) ->
    message.finish()
    authedRequest message, '/app-volume', 'get', {}, (err, res, body) ->
      message.send("Yo :#{message.message.user.name}:, the volume is #{body} :mega:")

  robot.respond /app volume (.*)/i, (message) ->
    params = {volume: message.match[1]}
    authedRequest message, '/app-volume', 'put', params, (err, res, body) ->
      message.send("Bumped the volume to #{body}, :#{message.message.user.name}:")

  robot.respond /volume\?/i, (message) ->
    message.finish()
    authedRequest message, '/system-volume', 'get', {}, (err, res, body) ->
      message.send("Yo :#{message.message.user.name}:, the volume is #{body} :mega:")

  robot.respond /volume ([+-])?(.*)/i, (message) ->
    if message.match[1]
      multiplier = if message.match[1][0] == '+' then 1 else -1

      authedRequest message, '/system-volume', 'get', {}, (err, res, body) ->
        newVolume = parseInt(body) + parseInt(message.match[2]) * multiplier

        params = {volume: newVolume}
        authedRequest message, '/system-volume', 'put', params, (err, res, body) ->
          message.send("Bumped the volume to #{body}, :#{message.message.user.name}:")
    else
      params = {volume: message.match[2]}
      authedRequest message, '/system-volume', 'put', params, (err, res, body) ->
        message.send("Bumped the volume to #{body}, :#{message.message.user.name}:")

  robot.respond /pause|(pause play)|(play pause)/i, (message) ->
    message.finish()
    params = {volume: 0}
    authedRequest message, '/system-volume', 'put', params, (err, res, body) ->
      message.send("The office is now quiet. (But the stream lives on!)")

  robot.respond /(unpause play)|(play unpause)/i, (message) ->
    message.finish()
    params = {volume: 50}
    authedRequest message, '/system-volume', 'put', params, (err, res, body) ->
      message.send("The office is now rockin' at half-volume.")

  robot.respond /start play/i, (message) ->
    message.finish()
    authedRequest message, '/play', 'put', {}, (err, res, body) ->
      json = JSON.parse(body)
      message.send("Okay! :)")

  robot.respond /stop play/i, (message) ->
    message.finish()
    authedRequest message, '/pause', 'put', {}, (err, res, body) ->
      json = JSON.parse(body)
      message.send("Okay. :(")


  #
  # STARS
  #

  robot.respond /I want this song/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)
      url  = "#{URL}/song/#{json.id}/download"
      message.send("Pretty rad, innit? Grab it for yourself: #{url}")

  robot.respond /I want this album/i, (message) ->
    authedRequest message, '/now_playing', 'get', {}, (err, res, body) ->
      json = JSON.parse(body)
      url  = "#{URL}/artist/#{escape json.artist}/album/#{escape json.album}/download"
      message.send("you fucking stealer: #{url}")

  robot.respond /(play something i('d)? like)|(play the good shit)/i, (message) ->
    message.finish()
    authedRequest message, '/queue/stars', 'post', {}, (err, res, body) ->
      json = JSON.parse(body)

      str = json.songs.map (song) ->
        "\"#{song.name} by #{song.artist}\""
      str.join(', ')

      message.send("NOW HEAR THIS: You will soon listen to #{str}")

  robot.respond /I (like|star|love|dig) this( song)?/i, (message) ->
    authedRequest message, '/now_playing', 'post', {}, (err, res, body) ->
      json = JSON.parse(body)
      message.send("It's certainly not a pedestrian song, is it. I'll make a "+
                   "note that you like #{json.artist}'s \"#{json.name}\".")

  #
  # PLAYING
  #

  robot.respond /play (.*)/i, (message) ->
    params = {subject: message.match[1]}
    authedRequest message, '/freeform', 'post', params, (err, res, body) ->
      if body.length == 0
        return message.send("That doesn't exist in Play. Or anywhere, probably. If it's not"+
               " in Play the shit don't exist. I'm a total hipster.")

      json = JSON.parse(body)
      str = json.songs.map (song) ->
        "\"#{song.name}\" by #{song.artist}"
      str.join(', ')

      message.send("Queued up #{str}")

  robot.respond /clear play/i, (message) ->
    authedRequest message, '/queue/all', 'delete', {}, (err, res, body) ->
      message.send(":fire: :bomb:")

  robot.respond /spin (it|that shit)/i, (message) ->
    authedRequest message, '/dj', 'post', {}, (err, res, body) ->
      message.send(":mega: :cd: :dvd: :cd: :dvd: :cd: :dvd: :speaker:")

  robot.respond /stop (spinning|dj)/i, (message) ->
    authedRequest message, '/dj', 'delete', {note: "github-dj-#{message.message.user.githubLogin}"}, (err, res, body) ->
      message.send("Nice work. You really did a great job. Your session has been saved and added to Play as: #{body}")
