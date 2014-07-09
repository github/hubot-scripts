# Description:
#   Allows Hubot to pull down images from calmingmanatee.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot manatee - outputs a random manatee
#
# Author:
#   Danny Lockard


module.exports = (robot) ->
        robot.respond /manatee/i, (msg) ->
                msg
                        .http( 'http://calmingmanatee.com' )
                        .headers('User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6')
                        .get() (err, res, body) ->
                                if err
                                        msg.send "Something went wrong #{err}"
                                        return

                                url = res.headers.location
                                manatee_no = url.substring(url.lastIndexOf("/") + 1)
                                
                                msg.send "http://calmingmanatee.com/img/manatee#{manatee_no}.jpg"
