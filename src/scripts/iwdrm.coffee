# Description:
#   Pulls a movie gif from the best tumblog
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TUMBLR_API_KEY - A Tumblr OAuth Consumer Key will work fine
#
# Commands:
#   hubot movie me - Displays a moving still from IWDRM
#
# Author:
#   iangreenleaf

module.exports = (robot) ->
  robot.respond /(movie|iwdrm)( me)?( .*)/i, (msg) ->
    tumblr_request = (offset, success) ->
      params = { api_key: process.env.HUBOT_TUMBLR_API_KEY, limit: 1, offset: offset }
      msg.http('http://api.tumblr.com/v2/blog/iwdrm.tumblr.com/posts/photo')
        .query(params)
        .get() (err, res, body) ->
          if err
            robot.logger.error err
          else if res.statusCode != 200
            robot.logger.error "Received status code #{res.statusCode}."
          else
            success JSON.parse(body)
    clean_quotes = (text) ->
      for entity,replacement of { "&#822[01];": '"', "&#8217;": "'", "&#8230;": "--" }
        text = text.replace RegExp(entity, "g"), replacement
      text
    tumblr_request 0, (data) ->
      total_posts = data.response.total_posts
      offset = Math.round((total_posts - 1) * Math.random())
      tumblr_request offset, (data) ->
        post = data.response.posts.pop()
        msg.send post.photos.pop().original_size.url
        quote = clean_quotes /<i>(.*?)<\/i>/.exec(post.caption)[1]
        title = /<a [^>]*imdb.com[^>]*>(.*?)<\/a>/.exec(post.caption)[1]
        msg.send "#{quote} #{title}"
