# Description:
#   Tells the status of GHE
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GHE_URL
#   HUBOT_GHE_USERNAME
#   HUBOT_GHE_PASSWORD
#
# Commands:
#   hubot ghe (status|info) <info> - gives some information about large repositories
#
# Authors:
#   pnsk

module.exports = (robot) ->
  robot.respond /ghe (status|info)? ?(.*)$/i, (msg) ->
    url = process.env.HUBOT_GHE_URL
    user = process.env.HUBOT_GHE_USERNAME
    pass = process.env.HUBOT_GHE_PASSWORD
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString("base64")

    unless user
      msg.send "user isn't set."

    unless pass
      msg.send "pass isn't set."

    unless auth
      msg.send "auth isn't set."

    info_term = msg.match[2]
    if info_term is "license"
      ghe_license msg,auth,url
    if info_term is "largerepo"
      ghe_largerepo msg,auth,url
    else
      msg.send "I don't know about #{info_term}"

ghe_license = (msg, auth,url) ->
    msg.http("#{url}/enterprise/settings/license")
    .header("Authorization", auth)
    .get() (err, res, body) ->
        if err
             msg.send "error"
        else
           if res.statusCode is 200
               results = JSON.parse body
               msg.send "GHE has #{results.seats} seats, and #{results.seats_used} are used. License expires at #{results.expire_at}"
           else
               msg.send "statusCode: #{res.statusCode}"

ghe_largerepo = (msg, auth, url) ->
    repo_min = 2000000
    msg.http("#{url}/search/repositories?q=size:>=#{repo_min}")
    .header("Authorization", auth)
    .get() (err, res, body) ->
        if err
             msg.send "error"
        else
           if res.statusCode is 200
               results = JSON.parse body
               msg.send "more than #{repo_min}KB repos. (aww)"
               if results.total_count is 0
                 msg.send "no repos."
               else
                 results.items.sort compareSize
                 reporank = ""
                 for item, index in results.items
                   reporank = reporank + "#{index+1}:  #{item.full_name} #{item.size} \n"
                 msg.send "#{reporank}"
           else
               msg.send "statusCode: #{res.statusCode}"

compareSize = (a, b) ->
  b.size - a.size
