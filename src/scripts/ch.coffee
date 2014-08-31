# c&h
#
# Description:
#   For the love of Calvin & Hobbes
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   c&h - get a Calvin & Hobbes strip

module.exports = (robot) ->

  robot.respond /c&h/i, (msg) ->
    month = Math.floor(Math.random() * 12) + 1
    date = -1
    if month in [1, 3, 5, 7, 8, 10, 12]
      date = Math.floor(Math.random() * 31) + 1
    else if month is 2
      date = Math.floor(Math.random() * 28) + 1
    else
      date = Math.floor(Math.random() * 30) + 1
    max = 2013
    min = 1986
    year = Math.floor(Math.random() * (max - min) + min)
    expr = year + "/" + month + "/" + date
    url = "http://www.gocomics.com/calvinandhobbes/#{expr}#.U_9_jWR5Ny4"
    msg.http(url)
      .get() (err, res, body) ->
        image = body.match(/class="strip" src="(.*)" width="600"/)[1]
        msg.send "#{image}#.png"

