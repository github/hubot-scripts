# Description:
#   None
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot tvshow me <show> - Show info about <show>
#
# Author:
#   victorbutler

xml2js = require "xml2js"
module.exports = (robot) ->
  robot.respond /tvshow(?: me)? (.*)/i, (msg) ->
    query = encodeURIComponent(msg.match[1])
    msg.http("http://services.tvrage.com/feeds/full_search.php?show=#{query}")
      .get() (err, res, body) ->
        if res.statusCode is 200 and !err?
          parser = new xml2js.Parser()
          parser.parseString body, (err, result) ->
            if result.Results and (result = result.Results).show?
              if result.show.length?
                show = result.show[0]
              else
                show = result.show
              if show.status == "Canceled/Ended"
                response = "#{show.name} aired for #{show.seasons} season"
                response += "s" if show.seasons > 1
                response += " from #{show.started} till #{show.ended}"
                response += " on #{show.network['#']}" if show.network? and show.network['#']
                response += " #{show.link}"
                msg.reply response
              else
                # get more info
                msg.http("http://services.tvrage.com/feeds/episode_list.php?sid=#{show.showid}")
                  .get() (err, res, details) ->
                    if res.statusCode is 200 and !err?
                      parser = new xml2js.Parser()
                      parser.parseString details, (err, showdetails) ->
                        showdetails = showdetails.Show
                        now = new Date();
                        ecb = (season_arr) ->
                          for episode in season_arr.episode
                            edate = new Date()
                            edate.setTime(Date.parse(episode.airdate+' '+show.airtime))
                            if edate.getTime() > now.getTime()
                              episode.season = season_arr.$.no
                              return episode

                        if showdetails.Episodelist[0].Season.length?
                          unaired = ecb season for season in showdetails.Episodelist[0].Season
                        else
                          unaired = ecb showdetails.Episodelist[0].Season

                        if unaired
                          response = "#{show.name} is a #{show.status} which started airing #{show.started}. The next show, titled \"#{unaired.title}\" (S#{unaired.season}E#{unaired.seasonnum}) is scheduled for #{unaired.airdate}"
                          response += " #{show.day}" if show.day?
                          response += " at #{show.airtime}" if show.airtime?
                          response += " on #{show.network['#']}" if show.network? and show.network['#']
                          response += " #{unaired.link}"
                          msg.reply response
                        else
                          response = "#{show.name} is a #{show.status} with #{show.seasons} (or more) season"
                          response += "s" if show.seasons > 1
                          response += " beginning #{show.started}"
                          response += " at #{show.airtime}" if show.airtime?
                          response += " on #{show.network['#']}" if show.network? and show.network['#']
                          response += " #{show.link}"
                          msg.reply response
                    else
                      msg.reply "Sorry, there was an error looking up your show"
            else
              msg.reply "I couldn't find TV show " + msg.match[1]
        else
            msg.reply "Sorry, there was an error looking up your show"
