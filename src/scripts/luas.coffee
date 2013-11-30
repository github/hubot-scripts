# luas - get the next inbound and outbound times for a luas at a particular stop
#
# Description:
#   luas times from Hubot
#   Based on work by Neil Cremins (https://github.com/ncremins/luas-api)
#
# Dependencies:
#  "urlencode": "0.0.1"
#
# Configuration:
#
# Commands:
#   hubot luas outbound <stop>
#   hubot luas inbound <stop>

urlencode = require('urlencode');

stops = {
  "st-stephens-green": urlencode("St. Stephen's Green"),
  "harcourt": "Harcourt",
  "charlemont": "Charlemont",
  "ranelagh": "Ranelagh",
  "beechwood": "Beechwood",
  "cowper": "Cowper",
  "milltown": "Milltown",
  "windy-arbour": urlencode("Windy Arbour"),
  "dundrum": "Dundrum",
  "balally": "Balally",
  "kilmacud": "Kilmacud",
  "stillorgan": "Stillorgan",
  "sandyford": "Sandyford",
  "central-park": urlencode("Central Park"),
  "glencairn": "Glencairn",
  "the-gallops": urlencode("The Gallops"),
  "leopardstown-valley": urlencode("Leopardstown Valley"),
  "ballyogan-wood": urlencode("Ballyogan Wood"),
  "carrickmines": "Carrickmines",
  "laughanstown": "Laughanstown",
  "cherrywood": "Cherrywood",
  "brides-glen": urlencode("Brides Glen"),
  "the-point": urlencode("The Point"),
  "spencer-dock": urlencode("Spencer Dock"),
  "mayor-square-nci": urlencode("Mayor Square - NCI"),
  "georges-dock": urlencode("George's Dock"),
  "busaras": "Bus%E1ras",
  "connolly": "Connolly",
  "abbey-street": urlencode("Abbey Street"),
  "jervis": "Jervis",
  "the-four-courts": urlencode("Four Courts"),
  "smithfield": "Smithfield",
  "museum": "Museum",
  "heuston": "Heuston",
  "jamess": urlencode("James's"),
  "fatima": "Fatima",
  "rialto": "Rialto",
  "suir-road": urlencode("Suir Road"),
  "goldenbridge": "Goldenbridge",
  "drimnagh": "Drimnagh",
  "blackhorse": "Blackhorse",
  "bluebell": "Bluebell",
  "kylemore": "Kylemore",
  "red-cow": urlencode("Red Cow"),
  "kingswood": "Kingswood",
  "belgard": "Belgard",
  "cookstown": "Cookstown",
  "hospital": "Hospital",
  "tallaght": "Tallaght",
  "fettercairn": "Fettercairn",
  "cheeverstown": "Cheeverstown",
  "citywest-campus": urlencode("Citywest Campus"),
  "fortunestown": "Fortunestown",
  "saggart": "Saggart"
}

directions = {
  "inbound": "Inbound",
  "outbound": "Outbound"
}

module.exports = (robot) ->

  robot.respond /luas (inbound|outbound) (\S.*)/i, (msg) ->
    direction = msg.match[1]
    #direction = directions[direction]
    stop = msg.match[2]
    stopName = stop.replace(/\s/g, "-")
    stopName = stopName.toLowerCase()
    
    urlName = stops[stopName]
        
    url = "http://www.luas.ie/luaspid.html?get=#{urlName}"
    yqlQuery = "SELECT * FROM html WHERE url='#{url}'"
    yqlQueryUrl = "http://query.yahooapis.com/v1/public/yql?q=#{urlencode(yqlQuery)}&format=json"

    msg.http(yqlQueryUrl)
      .get() (err, res, body) ->
        if res.statusCode == 200
          finalTimes = ""
          data = JSON.parse body
          times = data['query']['results']['body']['div']
          if direction == "inbound"
            time_data = times[0]['div']
          else if direction == "outbound"
            time_data = times[1]['div']
          for time in time_data
            if time['class'] == "location"
              if finalTimes == ""
                finalTimes = "#{time['p']}: "
              else 
                finalTimes = "#{finalTimes} #{time['p']}: "
            if time['class'] == "time"
                finalTimes = "#{finalTimes} #{time['p']}: "
          msg.reply "The next luas times #{direction} from #{stop} are #{finalTimes}"
        else
          msg.reply "Nope, that didn't work #{res.statusCode}"
