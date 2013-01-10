# Description:
#   Decides where you should go
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot remember <location> as a <group> location - Remembers the location for the group
#   hubot forget <location> as a <group> location - Forgets the location from the group
#   hubot forget all locations for <group> - Forgets all the locations for the group
#   hubot where can we go for <group>? - Returns a list of places that exist for the group
#   hubot where should we go for <group>? - Returns a randomly selected location for the group
#
# Author:
#   lukesmith

class Locations
  constructor: (@robot) ->
    @robot.brain.data.locations = {}

  add: (groupname, name) ->
    if @robot.brain.data.locations[groupname] is undefined
      @robot.brain.data.locations[groupname] = []

    for location in @robot.brain.data.locations[groupname]
        if location.toLowerCase() is name.toLowerCase()
          return

    @robot.brain.data.locations[groupname].push name

  remove: (groupname, name) ->
    group = @robot.brain.data.locations[groupname] or []
    @robot.brain.data.locations[groupname] = (location for location in group when location.toLowerCase() isnt name.toLowerCase())

  removeAll: (groupname) ->
    delete @robot.brain.data.locations[groupname]

  group: (name) ->
    return @robot.brain.data.locations[name] or []


module.exports = (robot) ->
  locations = new Locations robot

  robot.respond /remember (.*) as a (.*) location/i, (msg) ->
    locationname = msg.match[1]
    locationgroup = msg.match[2]
    locations.add locationgroup, locationname

    if locationname.toLowerCase() is "nandos"
      msg.send "Nom peri peri. My fav."

  robot.respond /forget (.*) as a (.*) location/i, (msg) ->
    locationname = msg.match[1]
    locationgroup = msg.match[2]
    locations.remove locationgroup, locationname

  robot.respond /forget all locations for (.*)/i, (msg) ->
    locationgroup = msg.match[1]
    locations.removeAll locationgroup

  robot.respond /where can we go for (.*)\?$/i, (msg) ->
    locationgroup = msg.match[1]
    grouplocations = locations.group(locationgroup)

    if grouplocations.length > 0
      for location in grouplocations
        msg.send location
    else
      msg.send "I don't know anywhere to go for #{locationgroup}"

  robot.respond /where (should|shall) we go for (.*)\?$/i, (msg) ->
    locationgroup = msg.match[2]
    grouplocations = locations.group(locationgroup)

    if grouplocations.length is 0
      msg.send "I dont know anywhere to go for #{locationgroup}"
    else
      location = msg.random grouplocations

      msg.send "I think you should go to #{location}"
