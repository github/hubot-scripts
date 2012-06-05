# gob it - Display a GOB

gobs = [
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/chicken-dance-2.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/Gob.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/pants.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/pennies1.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/queen_reveal.gif",
  "http://bite-prod.s3.amazonaws.com/wp-content/uploads/2012/05/scotch.gif",
  "http://farm1.static.flickr.com/223/511011836_56ae92ec1a_o.gif",
  "http://cdn.nextround.net/wp-content/uploads/2010/03/gob-bluth-gif-6.gif"
]

module.exports = (robot) ->
  robot.hear /gob it/i, (msg) ->
    msg.send msg.random gobs
