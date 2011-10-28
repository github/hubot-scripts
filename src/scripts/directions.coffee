# Get directions between two locations
#
# get directions "<origin>" "<destination>" -- Shows directions between these locations.

parse_directions = (body) ->
  directions = JSON.parse body
  first_route = directions.routes[0]
  
  if not first_route
    return "Sorry, boss. Couldn't find directions"

  final_directions = []

  for leg in first_route.legs
    do (leg) ->
      final_directions.push "From: " + leg.start_address
      final_directions.push "To:   " + leg.end_address
  
      for step in leg.steps
        do (step) ->
          instructions = step.html_instructions.replace /<[^>]+>/g, ''
          final_directions.push instructions + " (#{step.distance.text})"

   return final_directions.join("\n")
    
module.exports = (robot) ->
  robot.respond /(get )?directions "((?:[^\\"]+|\\.)*)" "((?:[^\\"]+|\\.)*)"$/i, (msg) ->
    [origin, destination] = msg.match[2..3]

    msg
        .http("http://maps.googleapis.com/maps/api/directions/json")
        .query
            origin: origin,
            destination: destination,
            sensor: false
        .get() (err, res, body) ->
            msg.send parse_directions body
