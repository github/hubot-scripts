# Description:
#   Subscribes the current room the results of a twitter search
#
# Commands:
#   hubot twitter subscribe <search terms> - Any tweets matching <search terms> will be posted by hubot
#   hubot twitter subscriptions - Will list the rooms current subscriptions
#   hubot twitter unsubscribe <terms> - Will unsubscribe from <terms>
#   hubot twitter mute [<minutes>] - Mute subscriptions for the current room, with an optional `minutes` for how long to mute
#   hubot twitter unmute - Unmute subscriptions for the current room
#   hubot twitter test <text> - Check if <text> would match this room's terms
#
# Notes:
#   For testing, login to twitter, and look for a trending topic to subscribe to

{inspect} = require 'util'

module.exports = (robot) ->
    robot.brain.on 'loaded', =>
        robot.brain.data.twitter ?= {}
        robot.brain.data.muted_twitter_rooms ?= {}

        startStreaming()

    @current_stream = undefined

    startStreaming = =>
        terms = (k for k of robot.brain.data.twitter)
        robot.twitter.stream 'statuses/filter', {track: terms}, (stream) =>
            @current_stream = stream

            stream.on 'data', (tweet) =>
                alertUsers tweet

            stream.on 'destroy', =>
                @current_stream = undefined

    stopStreaming = =>
        @current_stream.destroy() if @current_stream?

    restartStreaming = =>
        stopStreaming()
        startStreaming()

    alertUsers = (tweet) =>
        url = "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
        for terms, rooms of robot.brain.data.twitter when termsMatch(terms, tweet.text)
            sendMessage(room, url) for room in rooms

    termsMatch = (terms, tweet) =>
      # twitter's Streaming API doesn't match the search API, so make sure that matches are bounded to a word
      #
      # example:
      #        '@github down' would match '@githubstatus download'
      for term in terms.split(/\s/)
        if term.substring(0, 1) is "@"
          term = term.substring 1, term.length
        boundedRegexp = new RegExp("(^|\\W)@?#{term}(\\W|$)", "i")

        return false unless tweet.match(boundedRegexp)

      true

    sendMessage = (room_id,strings...) ->
        unless muted(room_id)
            robot.send({room: room_id},strings...)

    findRoom = (msg) ->
        msg.message.user.room

    findRooms = (terms) ->
        robot.brain.data.twitter[terms] || []

    roomTerms = (room) ->
        ( terms for terms of robot.brain.data.twitter when room in findRooms(terms) )

    muteRoom = (room) ->
        robot.brain.data.muted_twitter_rooms[room] = "muted"

    unmuteRoom = (room, msg=null) ->
        delete robot.brain.data.muted_twitter_rooms[room]
        msg.reply "Twitter subscriptions have been automatically re-activated." if msg

    muted = (room) ->
        room of robot.brain.data.muted_twitter_rooms

    robot.respond /twitter subscribe\s+(.*)/i, (msg) ->
        terms = msg.match[1]
        room = findRoom msg
        robot.brain.data.twitter[terms] ?= []

        # don't want duplicate subscriptions
        robot.brain.data.twitter[terms].push(room) unless room in findRooms(terms)

        msg.reply "This room will now receive tweets matching \"#{terms}\""

        restartStreaming()

    robot.respond /twitter subscriptions/i, (msg) ->
        room = findRoom msg
        msg.reply "This room is subscribed to:\n" + roomTerms(room).join("\n")

    robot.respond /twitter test (.*)/i, (msg) ->
      tweet = msg.match[1]

      matches = {}
      for terms in roomTerms findRoom msg
        matches[terms] = termsMatch(terms, tweet)

      msg.send ("#{terms}: #{match}" for terms, match of matches).join("\n")

    robot.respond /twitter mute\s?(.*)?/i, (msg) ->
        room = findRoom msg
        muteRoom room

        # Unmute this room automatically after the designated timeout, or a default (1 hour)
        minutes = if msg.match[1] then msg.match[1] else 60
        timeout = minutes * 60 * 1000 # milliseconds
        setTimeout (-> unmuteRoom(room, msg)), timeout

        unmuteTime = timeout / 60000
        txt = if unmuteTime == 1 then "minute" else "minutes"
        msg.reply "All twitter subscriptions now muted for this room. Will unmute in #{unmuteTime} #{txt}."

    robot.respond /twitter unmute/i, (msg) ->
        room = findRoom msg
        unmuteRoom room
        msg.reply "All twitter subscriptions unmuted for this room."

    robot.respond /twitter unsubscribe\s+(.*)/i, (msg) ->
        terms = msg.match[1]
        room  = findRoom msg
        if terms in roomTerms(room)
            robot.brain.data.twitter[terms] = robot.brain.data.twitter[terms].filter (room2) -> room2 isnt room
            msg.reply "Unsubscribing from tweets matching \"#{terms}\""

    robot.respond /twitter$/i, (msg) ->
        msg.reply   """
                    manages this room's subscriptions to twitter searches
                    /twitter subscribe <search terms>   -- subscribes this room to <search terms>
                    /twitter subscriptions              -- lists current subscriptions
                    /twitter unsubscribe <search terms> -- unsubscribes...
                    /twitter mute [<minutes>]           -- mute subscriptions for the current room (for optional minutes)
                    /twitter unmute                     -- unmute subscriptions for the current room
                    """

    robot.router.get '/twitter/subscriptions', (req, res) ->
      res.send robot.brain.data.twitter
