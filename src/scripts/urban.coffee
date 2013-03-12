# Description:
#   Define terms via Urban Dictionary
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot urban me <term>         - Searches Urban Dictionary and returns definition
#   hubot urban define me <term>  - Searches Urban Dictionary and returns definition
#   hubot urban example me <term> - Searches Urban Dictionary and returns example 
#
# Author:
#   Travis Jeffery (@travisjeffery)
#   Robbie Trencheny (@Robbie)

# FIXME merge with whatis.coffee

module.exports = (robot) ->
  robot.respond /(urban)( define)?( example)?( me)? (.*)/i, (msg) ->
    urbanDict msg, msg.match[5], (entry) ->
      if msg.match[3]
        msg.send "#{entry.example}"
      else
        msg.send "#{entry.definition}"

urbanDict = (msg, query, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      callback(JSON.parse(body).list[0])

