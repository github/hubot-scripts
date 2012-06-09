# Description:
#   Highly illogical
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   illogical - Display an example of illogicality
#
# Author:
#   arbales

vulcans = [
  "http://www.katzy.dsl.pipex.com/Smileys/illogical.gif",
  "http://icanhascheezburger.files.wordpress.com/2010/08/e95f76c6-469b-486e-9d18-b2c600ff7ab6.jpg",
  "http://fc01.deviantart.net/fs46/i/2009/191/d/6/Spock_Finds_You_Illogical_by_densethemoose.jpg",
  "http://cache.io9.com/assets/images/8/2008/11/medium_vulcan-cat-is-logical.jpg",
  "http://roflrazzi.files.wordpress.com/2011/01/funny-celebrity-pictures-karaoke.jpg",
  "http://i13.photobucket.com/albums/a292/macota/MCCOYGOBLET.jpg",
  "http://spike.mtvnimages.com/images/import/blog//1/8/7/5/1875583/200905/1242167094687.jpg",
  "http://randomoverload.com/wp-content/uploads/2010/12/fc5558bae4issors.jpg.jpg"
]

module.exports = (robot) ->
  robot.hear /.*(illogical).*/i, (msg) ->
    msg.send msg.random vulcans
