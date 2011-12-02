# Grabs movie scores from Rotten Tomatoes
# 
# rotten me <movie>
# 
# Examples:
# rotten me inception
# rotten me the good, the bad, and the ugly
module.exports = (robot) ->
  robot.respond /rotten me (.*)$/i, (msg) ->
    api_key = process.env.HUBOT_ROTTEN_TOMATOES_API_KEY
    
    unless api_key
      msg.send 'The environment variable $HUBOT_ROTTEN_TOMATOES_API_KEY needs to be set.'
      return
    
    title = msg.match[1]
    msg.http('http://api.rottentomatoes.com/api/public/v1.0/movies.json')
       .query
         apikey: api_key
         q: title
         page_limit: 1
       .get() (err, res, body) ->
         movie = JSON.parse(body)['movies'][0]
         
         unless movie?
           msg.send "Couldn't find that movie, sorry."
           return
         
         msg.send "#{movie['title']} (#{movie['year']})\n" +
                  "#{movie['runtime']} min, #{movie['mpaa_rating']}\n\n" +
                  "Critics:\t" + "#{movie['ratings']['critics_score']}%" + "\t\"#{movie['ratings']['critics_rating']}\"\n" +
                  "Audience:\t" + "#{movie['ratings']['audience_score']}%" + "\t\"#{movie['ratings']['audience_rating']}\"\n\n" +
                  "#{movie['critics_consensus']}"
