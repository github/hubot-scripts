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
#   hubot what is <term>?         - Searches Urban Dictionary and returns definition
#   hubot urban me <term>         - Searches Urban Dictionary and returns definition
#   hubot urban define me <term>  - Searches Urban Dictionary and returns definition
#   hubot urban example me <term> - Searches Urban Dictionary and returns example 
#
# Author:
#   Travis Jeffery (@travisjeffery)
#   Robbie Trencheny (@Robbie)
#
# Contributors:
#   Benjamin Eidelman (@beneidel)

module.exports = (robot) ->

  robot.respond /what ?is ([^\?]*)[\?]*/i, (msg) ->
    urbanDict msg, msg.match[1], (found, entry, sounds) ->
      if !found
        msg.send "I don't know what \"#{msg.match[1]}\" is"
        return
      msg.send "#{entry.definition}"
      if sounds and sounds.length
        msg.send "#{sounds.join(' ')}"


  robot.respond /(urban)( define)?( example)?( me)? (.*)/i, (msg) ->
    urbanDict msg, msg.match[5], (found, entry, sounds) ->
      if !found
        msg.send "\"#{msg.match[5]}\" not found"
        return
      if msg.match[3]
        msg.send "#{entry.example}"
      else
        msg.send "#{entry.definition}"
      if sounds and sounds.length
        msg.send "#{sounds.join(' ')}"

urbanDict = (msg, query, callback) ->
  msg.http("http://api.urbandictionary.com/v0/define?term=#{escape(query)}")
    .get() (err, res, body) ->
      result = JSON.parse(body)
      if result.list.length
        callback(true, result.list[0], result.sounds)
      else
        callback(false)

