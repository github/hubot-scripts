# Whois for gems, because gem names are like domains in the 90's
#
# gem whois <gemname> - returns gem details if it exists
#

module.exports = (robot) ->
  robot.respond /gem whois (.*)/i, (msg) ->
    gemname = escape(msg.match[1])
    msg.http("http://rubygems.org/api/v1/gems/#{gemname}.json")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          msg.send "   gem name: #{json.name}\n
     owners: #{json.authors}\n
       info: #{json.info}\n
    version: #{json.version}\n
  downloads: #{json.downloads}\n"
        catch err
          msg.send "Gem not found. It will be mine. Oh yes. It will be mine. *sinister laugh*"