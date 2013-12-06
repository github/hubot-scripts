# Description
#   Allows Hubot to interact with Douban's (http://douban.com) time-tracking.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot douban book <query>  - search for the Douban book
#   hubot douban movie <query> - search for the Douban movie
#   hubot douban music <query> - search for the Douban music
#
# Notes:
#   Enjoy,
#
# Author:
#   liluo

per_page_limit = 20

module.exports = (robot) ->
  robot.respond /(douban) (book|movie|music)? (.*)/i, (msg) ->
    Douban msg, msg.match[2], msg.match[3]


Douban = (msg, category, query) ->
  msg.http("http://api.douban.com/v2/#{category}/search")
    .query(q: query)
    .get() (err, res, body) ->
      res = JSON.parse body
      if res.total is 0
        msg.send "No results found for #{query}"
      else
        limit = if res.total > per_page_limit then per_page_limit else res.total
        msg.send "Douban found #{res.total} #{category} results, show top#{limit}:"
      switch category
        when 'book'
          msg.send "<#{b.title}>(#{b.pubdate}), #{b.rating.average}, see: #{b.alt}" for b in res.books
        when 'movie'
          msg.send "<#{m.title}>(#{m.year}), #{m.rating.average}, see: #{m.alt}" for m in res.subjects
        when 'music'
          msg.send "<#{m.title}>(#{m.attrs.pubdate}), #{m.rating.average}, see: #{m.alt}" for m in res.musics
