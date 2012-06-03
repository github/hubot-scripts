# Define terms via Urban Dictionary
#
# — Travis Jeffery (@travisjeffery)
#
# urban me <term>         - Searches Urban Dictionary and returns definition
# urban define me <term>  - Searches Urban Dictionary and returns definition
# urban example me <term> - Searches Urban Dictionary and returns example 


module.exports = (robot) ->
  robot.respond /(urban)( define)?( example)?( me)? (.*)/i, (msg) ->
    urbanDict msg, msg.match[5], (entry) ->
      if msg.match[3]
        msg.send "#{entry.example}"
      else
        msg.send "#{entry.definition}"

urbanDict = (msg, query, callback) ->
  msg.http("http://urbandict.me/api/#{escape(query)}")
    .get() (err, res, body) ->
      callback(JSON.parse(body).entries[0])

