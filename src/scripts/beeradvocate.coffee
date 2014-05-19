# Description:
#   An alternate to the existing beer script, this will scrape beer advocate for the most recent accessed beer.
#   It returns the name of the beer, a picture of the beer and a link to the beer. Hubot is now full of
#   different options for beer scripts. Removing the ? (optional) after (a|advocate) will force the command
#   to be 'beer advocate me' and thereby allow this script to coexist with other beer scripts peacefully.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot beer advocate me - returns the latest beer discussed on beer advocate with picture
#
# Author:
#   whyjustin

module.exports = (robot) ->
    robot.logger.warning "The beeradvocate script is broken and will not work (github/hubot-scripts#1436)."

    robot.respond /beer (a|advocate)( me)?/i, (msg) ->
        msg.send "I'm sorry but the beer advocate script is broken and will not work."
        # msg.http("http://beeradvocate.com/beer/")
        #     .get() (err, res, body) ->
        #         if (res.statusCode == 200)
        #             reg = /<h6><a href="\/beer\/profile\/(.+?)\/(.+?)\/?">(.+?)<\/a><\/h6>/i
        #             results = body.match(reg)
        #             if (results != null && results.length > 3)
        #                 msg.send results[3]
        #                 msg.send 'http://beeradvocate.com/beer/profile/' + results[1] + '/' + results[2]
        #                 msg.send 'http://beeradvocate.com/im/thumb.php?im=beers/' + results[2] + '.jpg'
