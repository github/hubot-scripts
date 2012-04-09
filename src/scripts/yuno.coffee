# <name> y u no <action>   - U NO WHAT IT DOES.
# Get image generation script at https://github.com/alexdean/yuno

module.exports = (robot) ->
  robot.hear /(.*) y u no (.*)/i, (msg) ->
    if not process.env.HUBOT_YUNO_URL?
      msg.send "HUBOT_YUNO_URL is not set."
      return

    msg.http(process.env.HUBOT_YUNO_URL)
      .query(
        auth: process.env.HUBOT_YUNO_AUTH_TOKEN,
        name: msg.match[1],
        action: msg.match[2]
      )
      .get() (err, res, body) ->
        if err
          msg.send "error: #{err}"
          return
        msg.send body
