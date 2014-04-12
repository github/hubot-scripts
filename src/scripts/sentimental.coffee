# Description:
#   Calculate the average Sentimental / happiness score for each person based on their spoken words
#
# Dependencies:
#   Sentimental
#   Redis
#
# Configuration:
#   None
#
# Commands:
#   hubot check on {username}||everyone
#
# Notes:
# { score: 3,
#   comparative: 1,
#   positive: { score: 3, comparative: 1, words: [ 'happy' ] },
#   negative: { score: 1, comparative: 0.047619047619047616, words: [ 'shoot' ] } 
# }

analyze = require('Sentimental').analyze
positivity = require('Sentimental').positivity
negativity = require('Sentimental').negativity

Url   = require "url"
Redis = require "redis"

module.exports = (robot) ->

  info   = Url.parse process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL or process.env.BOXEN_REDIS_URL or 'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)

  robot.hear /(.*)/i, (msg) ->
    spokenWord = msg.match[1]
    if spokenWord and spokenWord.length > 0 and !new RegExp("^" + robot.name).test(spokenWord)
      analysis = analyze spokenWord
      username = msg.message.user.name
      #console.log "#{username} scored #{analysis.score} with comparative #{analysis.comparative}"
      #console.log analysis

      client.get "sent:userScore", (err, reply) ->
        if err
          throw err
        else if reply
          sent = JSON.parse(reply.toString())
        else
          console.log "new sentimental data"
          sent = {}

        sent[username] = {score: 0, messages: 0, average: 0} if !sent[username] or !sent[username].average
        sent[username].score += analysis.score
        sent[username].messages += 1
        sent[username].average = sent[username].score / sent[username].messages
        #console.log sent

        client.set "sent:userScore", JSON.stringify(sent)

        if analysis.score < -2
          #msg.send "http://cdn.thenuge.com/wp-content/uploads/2011/11/sad-face-paper-bag.jpg"
          msg.send "stay positive #{msg.message.user.name}"

        #console.log "#{username} now has #{sent[username].score} / #{sent[username].average}"

  robot.respond /check everyone/i, (msg) ->
    msg.send "this is deprecated, please use \"check on everyone\""

  robot.respond /check on (.*)/i, (msg) ->
    username = msg.match[1]
    client.get "sent:userScore", (err, reply) ->
      if err
        throw err
      else if reply
        sent = JSON.parse(reply.toString())
        if username != "everyone" and (!sent[username] or sent[username].average == undefined)
          msg.send "#{username} has no happiness average yet"
        else
          for user, data of sent
            if (user == username or username == "everyone") and data.average != undefined
              #console.log user
              #console.log data
              msg.send "#{user} has a happiness average of #{data.average}"
      else
        msg.send "I haven't collected data on anybody yet"


