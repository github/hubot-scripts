# Rodent Motivation
#
# ship it - Display a motivation squirrel
#

squirrels = [
  "http://img.skitch.com/20100714-d6q52xajfh4cimxr3888yb77ru.jpg",
  "https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png"
]

module.exports = (robot) ->
  robot.hear /ship it/i, (msg) ->
    msg.send msg.random squirrels
