# Description:
#   Pulls a random NASA Astronomy Pic of the Day image
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TUMBLR_API_KEY
#
# Commands:
#   hubot space me - Receive a NASA Astronomy Pic of the Day image
#   hubot space bomb N - Receive up to 5 NASA Astronomy Pic of the Day images
#
# Author:
#   jessedearing, TheGravee

api_key = process.env.HUBOT_TUMBLR_API_KEY

getRandomSpaceImageUrl = (msg, rand) ->
  msg.http("http://api.tumblr.com/v2/blog/nasasapod.tumblr.com/posts?api_key=#{api_key}&offset=#{rand}&limit=1").get() (err, res, body) ->
    post = JSON.parse(body)
    msg.send(post.response.posts[0].photos[0].original_size.url)

getSpaceImage = (msg) ->
  msg.http("http://api.tumblr.com/v2/blog/nasasapod.tumblr.com/info?api_key=#{api_key}").get() (err, res, body) ->
    total_posts = JSON.parse(body).response.blog.posts
    rand = Math.floor(Math.random() * total_posts)
    getRandomSpaceImageUrl(msg, rand)

module.exports = (robot) ->
  robot.respond /space me/, (msg) ->
    getSpaceImage(msg)

  robot.respond /space bomb (\d+)/, (msg) ->
    count = msg.match[2] || 5
    for num in [count..1]
      getSpaceImage(msg)