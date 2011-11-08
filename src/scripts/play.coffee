# Play music. At your office. Like a boss.
#
# play.coffee uses play, an open source API to playing music:
#   https://github.com/holman/play
#
# You can watch the screencast at:
#   http://zachholman.com/screencast/play/
#
# Make sure you set up your HUBOT_PLAY_URL environment variable with the URL to
# your company's play.
#
# play - Plays music.
# stop - Stops the music.
# play next - Plays the next song.
# what's playing - Returns the currently-played song.
# I want this song - Returns a download link for the current song.
# I want this album - Returns a download link for the current album.
# play <artist> - Queue up ten songs from a given artist.
# play <name> by <artist> - Queues up a song by an artist.
# play album <album> - Queues up an album.
# list songs by <artist> - Lists the songs by the artist String.
# where's play - Gives you the URL to the web app.
# volume [0-10] - Adjust the volume of play.
# be quiet - Mute play.
# say <message> - `say` your message over your speakers.
# play stats - Show some play stats.

URL = "#{process.env.HUBOT_PLAY_URL}/api"

module.exports = (robot) ->
  robot.respond /where'?s play/i, (message) ->
    message.send("play's at #{process.env.HUBOT_PLAY_URL}")

  robot.respond /what'?s playing/i, (message) ->
    message.http("#{URL}/now_playing").get() (err, res, body) ->
      json = JSON.parse(body)
      str = "\"" + json.song_title + "\" by " +
            json.artist_name + ", from \"" + json.album_name + "\"."
      message.send("Now playing " + str)

  robot.respond /say (.*)/i, (message) ->
    message.http("#{URL}/say")
      .query(message: message.match[1])
      .get() (err, res, body) ->
        message.send(message.match[1])

  robot.respond /play stats/i, (message) ->
    message.http("#{URL}/stats")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        message.send(json.message)

  robot.respond /volume (.*)/i, (message) ->
    message.http("#{URL}/volume")
      .query(level: message.match[1])
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.success == 'true'
          message.send("Bumped the volume for ya.")
        else
          message.send("Whoa, can't change the volume. Weird.")

  robot.respond /quiet/i, (message) ->
    message.http("#{URL}/volume")
      .query(level: 1)
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.success == 'true'
          message.send("Running silent.")
        else
          message.send("Whoa, can't change the volume. Weird.")

  robot.respond /(un)?pause( play)?/i, (message) ->
    message.http("#{URL}/pause")
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.success == 'true'
          message.send("Fine, fine.")
        else
          message.send("Nope, can't. You're on your own.")

  robot.respond /play next/i, (message) ->
    message.http("#{URL}/next")
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.success == 'true'
          message.send("On to the next one.")
        else
          message.send("hwhoops")

  robot.respond /play ["']?(.+)["']?/i, (message) ->
    return if message.match[1].match(' by ')
    return if message.match[1] == 'next'
    return if message.match[1] == 'stats'
    return if message.match[1].split(' ')[0] == 'song'
    return if message.match[1].split(' ')[0] == 'album'
    return if message.match[1].split(' ')[0] == 'something'
    message.http("#{URL}/add_artist")
      .query(user_login: message.message.user.githubLogin, artist_name: message.match[1])
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.error
          message.send(json.error)
        else
          message.send("Queued up 10 " + json.artist_name + " tracks.")

  robot.respond /play album ["']?(.+)["']?/i, (message) ->
    message.http("#{URL}/add_album")
      .query(user_login: message.message.user.githubLogin, name: message.match[1])
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.error
          message.send(json.error)
        else
          str = json.album_name + " by " + json.artist_name + "."
          message.reply("Queued up " + str)

  robot.respond /play ["']?(.+)["']? by ["']?(.+)["']?/i, (message) ->
    message.http("#{URL}/add_song")
      .query(user_login: message.message.user.githubLogin, artist_name: message.match[2], song_title: message.match[1])
      .post() (err, res, body) ->
        json = JSON.parse(body)
        if json.song_title
          str = "\"" + json.song_title + "\" by " +
                json.artist_name + ", from \"" + json.album_name + "\"."
          message.send("Queued up " + str)
        else
          message.send("Never heard of it.")

  robot.respond /(I like|star) this song/i, (message) ->
    message.http("#{URL}/star_now_playing")
      .query(user_login: message.message.user.githubLogin)
      .post() (err, res, body) ->
        json = JSON.parse(body)
        message.send("You have a weird taste in music, but I'll remember it.")

  robot.respond /play something i('d)? like/i, (message) ->
    message.http("#{URL}/play_stars")
      .query(user_login: message.message.user.githubLogin)
      .post() (err, res, body) ->
        json = JSON.parse(body)
        message.send("Queued up " + json.song_title + " by " + json.artist_name)

  robot.respond /I want this song/i, (message) ->
    message.http("#{URL}/now_playing").get() (err, res, body) ->
      json = JSON.parse(body)
      message.send("Cool! Me too. You can snag it at: #{process.env.HUBOT_PLAY_URL}#{json.song_download_path}")

  robot.respond /I want this album/i, (message) ->
    message.http("#{URL}/now_playing").get() (err, res, body) ->
      json = JSON.parse(body)
      message.send("Cool! Me too. You can snag it at: #{process.env.HUBOT_PLAY_URL}#{json.album_download_path}")

  robot.respond /list songs by ["']?(.+)["']?/i, (message) ->
    artist = message.match[1]
    message.http("#{URL}/search")
      .query(facet: 'artist', q: artist)
      .get() (err, res, body) ->
        json  = JSON.parse(body)
        songs = json.song_titles.join("\n ")
        message.send("Songs by " + artist + ":\n  " + songs)
