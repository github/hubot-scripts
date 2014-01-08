# Description:
#   Search and show your train time in Japan
#
# Dependencies:
#   "moment", "~= 1.7.2"
#
# Configuration:
#   None
#
# Commands:
#   hubot train <from> <to> now  - Get the latest JP train time.
#   hubot train <from> <to> <hour>:<minutes>  - Get the latest JP train time to arrive at <hour>:<minutes>.
#   hubot train <from> <to> <minutes> later  - Get the latest JP train time to get on <minutes> later.
#   hubot <number> trains <from> <to> now - Get JP train times.
#   hubot <number> trains <from> <to> <hour:minutes>  - Get JP train times to arrive at <hour:minutes>.
#   hubot <number> trains <from> <to> <minutes> later  - Get JP train times to get on <hour:minutes>.
#
# Author:
#   3100

Moment = require "moment"

module.exports = (robot) ->
  createUrl = (from, to) ->
    "http://www.jorudan.co.jp/norikae/cgi/nori.cgi?Sok=1&eki1=#{from}&eki2=#{to}&type=t"

  createDepartureUrl = (from, to, laterMinutes) ->
    createUrl(from, to) + "&" + departureOption(laterMinutes)

  createArrivalUrl = (from, to, hour, minutes) ->
    createUrl(from, to) + "&" + arrivalOption(hour, minutes)

  arrivalOption = (hour, minutes) ->
    today = Moment()
    dym = today.format("YYYYMM")
    ddd = today.format("DD")
    dhh = hour
    dmn = minutes
    chaku = 1
    option = "Dym=#{dym}&Ddd=#{ddd}&Dhh=#{dhh}&Dmn=#{dmn}&Cway=#{chaku}"
    return option

  departureOption = (minutes) ->
    today = Moment().add('m', minutes)
    dym = today.format("YYYYMM")
    ddd = today.format("DD")
    dhh = today.format("H")
    dmn = today.format("m")
    chaku = 0
    option = "Dym=#{dym}&Ddd=#{ddd}&Dhh=#{dhh}&Dmn=#{dmn}&Cway=#{chaku}"
    return option

  getText = (body, max) ->
    count = parseInt(max) + 3
    results = []
    lines = body.split "\n"
    for line in lines
      if line.indexOf("hr") >= 0
        count -= 1
        if count == 0
          return results.join "\n"
      else if line.indexOf("<") == -1
        results.push line
    return results.join "\n"

  getTrains = (msg, url, max) ->
    console.log url
    msg.http(url).get() (err, res, body) ->
      results = getText body, max
      if results[0] != ""
        msg.send results
      else
        msg.send "something went wrong."

  robot.respond /train (\S+) (\S+) now/i, (msg) ->
    max = 1
    url = createUrl msg.match[1], msg.match[2]
    getTrains msg, url, max

  robot.respond /train (\S+) (\S+) (\d{1,2})\:(\d{1,2})/i, (msg) ->
    max = 1
    url = createArrivalUrl msg.match[1], msg.match[2], msg.match[3], msg.match[4]
    getTrains msg, url, max

  robot.respond /train (\S+) (\S+) (\d{1,2}) later/i, (msg) ->
    max = 1
    url = createDepartureUrl msg.match[1], msg.match[2], msg.match[3]
    getTrains msg, url, max

  robot.respond /(\d+) trains (\S+) (\S+) now/i, (msg) ->
    max = msg.match[1]
    url = createUrl msg.match[2], msg.match[3]
    getTrains msg, url, max

  robot.respond /(\d+) trains (.*?) (.*?) (\d{1,2})\:(\d{1,2})/i, (msg) ->
    max = msg.match[1]
    url = createArrivalUrl msg.match[2], msg.match[3], msg.match[4], msg.match[5]
    getTrains msg, url, max

  robot.respond /(\d+) trains (.*?) (.*?) (\d{1,2}) later/i, (msg) ->
    max = msg.match[1]
    url = createDepartureUrl msg.match[2], msg.match[3], msg.match[4]
    getTrains msg, url, max

