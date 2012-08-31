# Description:
#   Show some random person from facebook - their image, name, gender and nationality.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stranger me - Meet someone new from facebook
#
# Author:
#   joelongstreet

module.exports = (robot) ->
    robot.respond /stranger me/i, (msg) ->
        msg.http("http://facehold.it/hubot")
            .get() (err, res, body) ->
                stranger = JSON.parse(body)
                msg.send "Meet #{stranger.name}, the #{stranger.nationality} #{stranger.gender}. Learn more about #{if stranger.gender == 'male' then 'him' else 'her'} at #{stranger.url}"
                msg.send stranger.image