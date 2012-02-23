# Find out what food trucks are at Truck Stop SF today
# See http://truckstopsf.com
#
# Examples:
#   truckstopsf - get just the names of the food trucks today
#   truckstopsf details|deets - get food truck names and details
#   truckstopsf! - get food truck names and details
#
module.exports = (robot) ->
  robot.respond /truckstopsf\s?(!|details|deets)?/i, (res) ->
    d = new Date()
    utc = d.getTime() + (d.getTimezoneOffset() * 60000)
    pstDate = new Date(utc + (3600000*-8));
    today = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][pstDate.getDay()]

    if today is 'Sunday' or today is 'Saturday'
      res.send "Sorry, the trucks aren't there on weekend"
    else
      res.http("http://www.truckstopsf.com/").get() (err, _, body) ->
        return res.send "Sorry, the trucks are out of gas or something." if err

        if body.match("There are no events")
          return res.send "Seems there may be no trucks today - check http://www.truckstopsf.com/"
          
        show_details = res.match[1]?
        
        matches = if show_details
          body.match("<h3>#{today}<\/h3>[^]+?<p><strong>(.+)<\/strong> - (.+)<\/p>[^]+?<p><strong>(.+)<\/strong> - (.+)<\/p>[^]+?<p><strong>(.+)<\/strong> - (.+)<\/p>")
        else
          body.match("<h3>#{today}<\/h3>[^]+?<p><strong>(.+)<\/strong>[^]+?<p><strong>(.+)<\/strong>[^]+?<p><strong>(.+)<\/strong>")

        if matches?.length > 3
          trucks = (match.replace("&#39;", "'").replace("&amp;", "&") for match in matches.slice(1))

          if show_details
            res.send "Today's trucks:\n* #{trucks[0]}: #{trucks[1]}\n* #{trucks[2]}: #{trucks[3]}\n* #{trucks[4]}: #{trucks[5]}"
          else
            res.send "Today's trucks: #{trucks[0]}, #{trucks[1]}, and #{trucks[2]}"
        else
          res.send "Hmm, couldn't parse the trucks web page - try http://www.truckstopsf.com/"
        
