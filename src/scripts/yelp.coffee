# Description
#   Returns a random business/restaurant/service.
#
# Dependencies:
#   "yelp": "0.1.1"
#
# Commands:
#   hubot [suggestion|recommendation] category list
#   hubot [suggest|recommend] [random|category] [at|in|near|by] [location]

yelp = require('yelp').createClient(
  consumer_key: process.env.YELP_CONSUMER_KEY
  consumer_secret: process.env.YELP_CONSUMER_SECRET
  token: process.env.YELP_TOKEN
  token_secret: process.env.YELP_TOKEN_SECRET)

module.exports = (robot) ->
  robot.respond /(suggestion|recommendation) category list/i, (msg) ->
    url = 'http://www.yelp.com/developers/documentation/category_list'

    help_text = ['The category names are in parentheses:']
    help_text.push '      Chicken Wings (chicken_wings)'
    help_text.push '      Indian        (indpak)'
    help_text.push 'Parent categories include the child categories:'
    help_text.push '      Chinese (chinese) will include "cantonese, dimsum, shanghainese and szechuan" in the search.'
    help_text.push 'If you would like to have me give you a random result from all available categories use "random".'

    msg.send help_text.join("\n")
    setTimeout (-> msg.send url), 2000

  robot.respond /(suggest|recommend) (.+) (at|in|near|by) (.*)/i, (msg) ->
    filter = if filter == 'random' then '' else msg.match[2]
    location = msg.match[4]

    query =
      term: ''
      category_filter: filter
      location: location

    yelp.search query, (error, data)->
      unless error
        if data.businesses.length > 0
          business = data.businesses[Math.floor(Math.random() * data.businesses.length)]

          msg.send "#{business.name} at #{business.location.address} (rated: #{business.rating}/5 by #{business.review_count} people.)"
          setTimeout (-> msg.send business.url), 2000
        else
          msg.send "I couldn't find anything matching '#{filter}' in '#{location}'."

