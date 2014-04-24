# Description:
#   See the current list of delays or incidents on the London Underground
#
# Dependencies:
#   "cheerio": "0.12.1"
#
# Commands:
#   hubot tube - Replies with a list of current incidents/delays on the London Underground
#

cheerio = require("cheerio")

module.exports = (robot) ->

  robot.respond /tube$/i, (msg) ->
    query msg, (body, err) ->
      return msg.send "I couldn't seem to retrieve the current status of the Tube. Oh dear." if err
    
      $ = cheerio.load body, { ignoreWhitespace: true };
      if ($('linestatus').length == 0) 
        msg.send "Everything on the Underground is running smoothly, it seems."
      else 
        delays = []
        $('linestatus').each (index, delay) ->
          status = $(delay).attr('statusdetails')
          name = $(delay).children('line').attr('name')
          delays.push "#{name} - #{status}"
        msg.send "Current issues on the Underground:\n #{delays.join('\n')}"

 query = (msg, cb) ->
  msg.http("http://cloud.tfl.gov.uk/TrackerNet/LineStatus/incidentsonly")
    .get() (err, res, body) ->
      cb(body, err)