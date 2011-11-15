# Uses downforeveryoneorjustme.com to check if a site is up.
#
# is <domain> up?   - Checks if <domain> is up
#
# Written by @jmhobbs

module.exports = (robot) ->
  robot.respond /is (.*?) (up|down)(\?)?/i, (msg) ->
    isUp msg, msg.match[1], (domain) ->
      msg.send domain

isUp = (msg, domain, cb) ->
  msg.http('http://www.isup.me/' + domain)
    .get() (err, res, body) ->
      if body.match("It's just you.")
        cb "#{domain} looks UP from here."
      else if body.match("It's not just you!")
        cb "#{domain} looks DOWN from here."
      else
        cb "Not sure, #{domain} returned an error."

