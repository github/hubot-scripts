# Description:
#  Listens for "coffee" keywords. Made by an intern for interns everywhere
#
# Author:
#   nicoritschel
#

coffee = [
  "Make your own damn coffee",
  "Starbucks is right down the street...",
  "Interns are not slaves."
]

module.exports = (robot) ->
  robot.hear /coffee/i, (msg) ->
    msg.send msg.random coffee
