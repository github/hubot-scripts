# See what's playing on the Heavy Metal Supersite
#
# hardradio song - Display the song that's rocking on air
# hardradio listen - Displays a link to play the radio
#

module.exports = (robot) ->
  robot.respond /hardradio listen/i, (msg) ->
    msg.send "http://www.hardradio.com/streaming/hardmp3.pls"

  robot.respond /hardradio song/i, (msg) ->
    msg.http('http://axl.hardradio.com/playnow.txt')
    .get() (err, res, body) ->
      body = body.replace(/song=/g, "Tearing your speakers right now: ")
      msg.send body