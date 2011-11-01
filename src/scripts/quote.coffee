# Display a random quote or one from a specific person
#
# enlighten - random quote
# quote     - random quote
# quote from <person>
#
# Optionally set HUBOT_QUOTE_MAX_LINES to limit how long a quote
# is. Default is 4
module.exports = (robot) ->
  robot.respond /enlighten|quote from (.*)|quote/i, (msg) ->
    params = {max_lines: process.env.HUBOT_QUOTE_MAX_LINES || '4'}
    if msg.match[1]
      params['source'] = msg.match[1].split(/\s+/).join('+')

    msg.http('http://www.iheartquotes.com/api/v1/random')
      .query(params)
      .get() (err, res, body) ->
        body = body.replace(/\s*\[\w+\]\s*http:\/\/iheartquotes.*\s*$/m, '')
        body = body.replace(/&quot;/g, "'")
        msg.send body
