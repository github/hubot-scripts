# Is it iced coffee weather?
# ===========================
#
# It's very important to know the cutoff date for switching from hot coffee to iced coffee. This script does just that.
#
# Usage
# -----
#
# hubot is it iced coffee weather? - Display whether or not it's a good time for iced coffee
#
# Setup
# -----
#
# You need to set the following environment variables:
#
#  HUBOT_ICED_COFFEE_WEATHER_ID="id from isiticedcoffeeweather.com"
#
# How to find this:
#
# * Go to http://isiticedcoffeeweather.com/
# * Allow it to detect your location, or enter it yourself
# * Look at the URL, ie http://isiticedcoffeeweather.com/XXXXXXXX
#   * XXXXXXXX is the id
#
# And you need the following dependency in package.json:
#
#    "cheerio": "0.7.0"
#
# TODO / WISHLIST
# ---------------
#
# * user-specific location
# * move parsing location to an API endpoint

cheerio = require('cheerio')

iced_coffee_weather_id = process.env.HUBOT_ICED_COFFEE_WEATHER_ID

module.exports = (robot) ->
  robot.respond /is it iced (coffee|latte) weather/i, (msg) ->
    if ! iced_coffee_weather_id 
      msg.send "I don't know where you are, so I can't say. Make sure to set HUBOT_ICED_COFFEE_WEATHER_ID"
      return

    url = "http://isiticedcoffeeweather.com/#{iced_coffee_weather_id}"
    msg
      .http(url)
      .header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6')
      .get() (err, res, body) ->
        if err
          msg.send "Something went wrong #{err}"
          return
        msg.send "my sources say #{getIcedCoffe body} #{url}"

getIcedCoffe = (body, callback) ->
 $ = cheerio.load(body)
 $('body h2').text()
