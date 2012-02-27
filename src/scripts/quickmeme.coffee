# Allow Hubot to show the image from a quickmeme link, as dragging from their site is a pain.
#
# http://www.quickmeme.com/meme/* - Detects the url and displays the image

module.exports = (robot) ->
  robot.hear /https?:\/\/www\.quickmeme\.com\/\w+\/(\w+)\//i, (msg) ->
    return if msg.match[2]  # Ignore already embedded images.
    
    id = msg.match[1]
    
    msg.send "http://i.qkme.me/" + id + ".jpg"