# Description:
#   A bomb of pics!
#
# Commands:
#   hubot query bomb N - get N images

module.exports = (robot) ->

  robot.respond /(.*) bomb( (\d+))?/i, (msg) ->
    query = msg.match[1] || ""
    query = query.replace /^\s+|\s+$/g
    return if query.length == 0 || query == 'pug'

    count = msg.match[3] || 5
    if count > 8
      msg.send "Sorry, I can't get you that many #{query}s."
      return

    imageBomb msg, query, count, (urls) ->
      msg.send url for url in urls

imageBomb = (msg, query, count, cb) ->
  q = v: '1.0', rsz: count, q: query, safe: 'active'
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        urls = ("#{image.unescapedUrl}#.png" for image in images)
        cb shuffle urls

shuffle = (a) ->
  for i in [a.length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [a[i], a[j]] = [a[j], a[i]]
  a
