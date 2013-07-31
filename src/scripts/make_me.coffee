# Description
#   Companion Hubot script for operating
#   https://github.com/make-me/make-me/
#
# Dependencies:
#   None
#
# Configuration:
#   The make-me HTTP server location, username and password
#   can be configured from the enviornment with `$HUBOT_MAKE_ME_URL`,
#   `$HUBOT_MAKE_ME_USER` and `$HUBOT_MAKE_ME_PASS`
#
# Commands:
#   hubot 3d me <url..url_n> [options] - 3D Print the URLs
#   hubot 3d? - Show some help
#
# Notes:
#   None
#
# Author:
#   @sshirokov and @skalnik
util = require 'util'
qs = require 'querystring'

makeServer = process.env.HUBOT_MAKE_ME_URL or 'http://localhost:9292'
[authUser, authPass] = [process.env.HUBOT_MAKE_ME_USER or 'hubot', process.env.HUBOT_MAKE_ME_PASS or 'isalive']
auth64 = (new Buffer("#{authUser}:#{authPass}")).toString("base64")

module.exports = (robot) ->
  robot.respond /3d\??$/i, (msg) ->
    response = """#{robot.name} 3d me [STL URLs] [[options]] - prints an STL file
You can list multiple URLs separated by spaces.

  Options can follow the URL and are:
    '(high|medium|low) quality' -- sets the quality of the print. Default: medium
    'xN' (e.g. x2)              -- print more than one of a thing at once
    'with supports'             -- adds supports to the model, for complex overhangs. Default: disabled
    'with raft'                 -- prints on a plastic raft, for models with little platform contact. Default: disabled
    'xx% solid'                 -- changes how solid the object is on the inside. Default: 5%
    'scale by X.Y' (e.g. 0.5)   -- scale the size of the model by a factor

#{robot.name} 3d snapshot - takes a picture and tells you the locked status
#{robot.name} 3d unlock - unlocks the printer after you clean up

Only 1 print at a time is allowed, and you are required to tell
#{robot.name} after you've cleaned your print off.

The web frontend is at #{makeServer}, and
the most current log is always available at #{makeServer}/log"""
    msg.send response

  robot.respond /3d (snapshot|status)/i, (msg) ->
    locked_msg = "unlocked"
    msg.http(makeServer + "/lock")
      .header("Authorization", "Basic #{auth64}")
      .get() (err, res, body) =>
        if res.statusCode is 423
          locked_msg = "locked"

        msg.http(makeServer).scope('photo.json')
          .get() (err, res, body) =>
            if res.statusCode is 200
              msg.reply "I can't see anything, what does it look like to you? I hear the machine is #{locked_msg}."
              images = JSON.parse(body)?.images
              for image in images
                msg.send image
            else
              msg.reply "I can't seem to get a hold of a picture for you, but the internets tell me the machine is #{locked_msg}."

  robot.respond /3d unlock( me)?/i, (msg) ->
    msg.http(makeServer + "/lock")
      .header("Authorization", "Basic #{auth64}")
      .post(qs.encode({"_method": "DELETE"})) (err, res, body) =>
        if res.statusCode is 200
          msg.reply "Oh you finally decided to clean up?"
        else if res.statusCode is 404
          msg.reply "There's no lock. Go print something awesome!"
        else
          msg.reply "Unexpected status code #{res.statusCode}!"
          msg.reply body

  robot.respond /(3d|make)( me)?( a)? (http[^\s]+)\s*(.*)/i, (msg) ->
    things = [msg.match[4]]
    count = 1
    scale = 1.0
    supports = false
    raft = false
    quality = 'medium'
    density = 0.05
    options = msg.match[5]

    # Extract any extra urls
    while url = /(http[^\s]+)\s?/.exec(options)
      things.push url[1]
      options = options.slice(url[1].length + 1)

    if count_op = /x(\d+)/.exec(options)
      count = parseInt(count_op[1])

    if /with support/.exec(options)
      supports = true

    if /with raft/.exec(options)
      raft = true

    if quality_op = /(\w+) quality/.exec(options)
      quality = quality_op[1]

    if density_op = /(\d+)% solid/.exec(options)
      density = parseFloat(density_op[1]) / 100.0

    if scale_op = /scale by (\d+\.\d+)/.exec(options)
      scale = parseFloat(scale_op[1])

    reply = "Telling the 3D printer to print #{things.length} models"
    reply += " with the options: #{options}" if options.length > 0
    msg.reply reply

    msg.http(makeServer + "/print")
      .header("Authorization", "Basic #{auth64}")
      .post(JSON.stringify({
        url: things,
        count: count,
        scale: scale,
        quality: quality,
        density: density,
        slicer_args: {
          doSupport: supports,
          doRaft: raft
        }
      })) (err, res, body) =>
        if res.statusCode is 200
          msg.reply "Your thing is printin'! Check logs at #{makeServer}"
        else if res.statusCode is 409
          msg.reply "I couldn't process that pile of triangles."
        else if res.statusCode is 423
          msg.reply "Wait your turn, someone is already printing a thing. You can check progress at #{makeServer}"
        else if err or res.statusCode is 500
          msg.reply "Something broke!"
