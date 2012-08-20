# Description:
#   Grabs movie scores from Rotten Tomatoes
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_ROTTEN_TOMATOES_API_KEY
#
# Commands:
#   hubot rotten [me] <movie>
#   hubot what's in theaters?
#   hubot what's coming out in theaters?
#   hubot what's coming out on (dvd|bluray)? - there is not a distinction between dvd and bluray
#
# Author:
#   mportiz08

class Rotten
  constructor: (@robot) ->
    @api_url = "http://api.rottentomatoes.com/api/public/v1.0"
    @api_key = process.env.HUBOT_ROTTEN_TOMATOES_API_KEY

  _links: (match, callback) =>
    return callback @__links[match] if @__links
    @send "#{@api_url}/lists.json", {},
      (err, res, body) =>
        @__links = JSON.parse(body)['links']
        callback @__links[match]

  _movie_links: (match, callback) =>
    return callback @__movie_links[match] if @__movie_links
    @_links 'movies',
      (link) =>
        @send link, {},
          (err, res, body) =>
            @__movie_links = JSON.parse(body)['links']
            callback @__movie_links[match]

  _dvd_links: (match, callback) =>
    return callback @__dvd_links[match] if @__dvd_links
    @_links 'dvds',
      (link) =>
        @send link, {},
          (err, res, body) =>
            @__dvd_links = JSON.parse(body)['links']
            callback @__dvd_links[match]

  in_theaters: (callback) =>
    @_movie_links 'in_theaters',
      (match) =>
        @send match,
          page_limit: 20
          country: 'us'
          (err, res, body) ->
            movies = JSON.parse(body)['movies']

            unless err? or movies?
              return callback("Couldn't find anything, sorry.")

            callback null, (new RottenMovie(movie) for movie in movies)

  upcoming: (type, callback) =>
    link_list = switch type
      when 'movies'
        @_movie_links
      when 'dvds'
        @_dvd_links
      else
        @_movie_links

    link_list 'upcoming',
      (match) =>
        @send match,
          page_limit: 20
          country: 'us'
          (err, res, body) ->
            movies = JSON.parse(body)['movies']
           
            unless err? or movies?
              return callback("Couldn't find anything, sorry.")

            callback null, (new RottenMovie(movie) for movie in movies)

  search: (query, callback) =>
    @send "#{@api_url}/movies.json",
      q: query
      page_limit: 1
      (err, res, body) ->
        movie = JSON.parse(body)['movies'][0]
           
        unless err? or movie?
          return callback("Couldn't find anything, sorry.")

        callback null, new RottenMovie(movie)

    return

  send: (url, options, callback) =>
    options.apikey = @api_key
    @robot.http(url).query(options).get()(callback)

class RottenMovie
  constructor: (@info) ->

  toDetailedString: ->
    "#{@info['title']} (#{@info['year']})\n" +
    "#{@info['runtime']} min, #{@info['mpaa_rating']}\n\n" +
    "Critics:\t" + "#{@info['ratings']['critics_score']}%" +
      "\t\"#{@info['ratings']['critics_rating']}\"\n" +
    "Audience:\t" + "#{@info['ratings']['audience_score']}%" +
      "\t\"#{@info['ratings']['audience_rating']}\"\n\n" +
    "#{@info['critics_consensus']}"

  toReleaseString: ->
    "#{@info['title']}, #{@info['release_dates']['dvd'] || @info['release_dates']['theater']} (#{@info['ratings']['audience_score']}%)"

  toString: ->
    "#{@info['title']} (#{@info['ratings']['audience_score']}%)"

module.exports = (robot) ->
  rotten = new Rotten robot

  robot.respond /rotten (me )?(.*)$/i, (message) ->
    message.send "Well, let's see..."
    rotten.search message.match[2], (err, movie) ->
      unless err?
        message.send movie.toDetailedString()
      else
        message.send err

  robot.respond /what(\')?s in theaters(\?)?$/i, (message) ->
    message.send "Well, let's see..."
    rotten.in_theaters (err, movies) ->
      unless err?
        message.send (movie.toString() for movie in movies).join("\n")
      else
        message.send err

  robot.respond /what(\')?s coming out ((on (dvd|blu(-)?ray))|(in theaters))(\?)?$/i, (message) ->
    message.send "Well, let's see..."
    type = if message.match[2] is 'in theaters' then 'movies' else 'dvds'
    rotten.upcoming type, (err, movies) ->
      unless err?
        message.send (movie.toReleaseString() for movie in movies).join("\n")
      else
        message.send err