# Queries Bing and returns a random image from the top 50 images found using Bing API.
# Why use this over Google? I can return more than 8 images...MOAR VARIETY!
# Also, I like hearing "You use BING?!?"
# Sign up for the Account Key here: https://datamarket.azure.com/account/keys
# API usage found here: http://msdn.microsoft.com/en-us/library/dd251056.aspx
# Feel free to ping me if you need help
#
# bing image <query>   - Queries Bing Images for <query> & returns a random result from top 50

bingAccountKey = process.env.HUBOT_BING_ACCOUNT_KEY
unless bingAccountKey
  throw "You must set HUBOT_BING_ACCOUNT_KEY in your environment vairables"

module.exports = (robot) ->
  robot.hear /^bing( image)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], (url) ->
      msg.send url

imageMe = (msg, query, cb) ->
  msg.http('https://api.datamarket.azure.com/Bing/Search/Image')
    .header("Authorization", "Basic " + new Buffer("#{bingAccountKey}:#{bingAccountKey}").toString('base64'))
    .query(Query: "'" + query + "'", $format: "json", $top: 50)
    .get() (err, res, body) ->
      try
        images = JSON.parse(body).d.results
        image = msg.random images
        cb image.MediaUrl
      catch error
        cb body
