# Description:
#   Allows Hubot to summon the mighty Zalgo
#
# Dependencies:
#   None
#
# Configuration:
#   None 
#
# Commands:
#   hubot zalgo <phrase> - Conjurs your words in the name of Zalgo!  He comes... 
#
# Author:
#   DeaconDesperado

rand = (max) ->
  Math.floor Math.random() * max

rand_zalgo = (array) ->
  ind = Math.floor(Math.random() * array.length)
  array[ind]

is_zalgo_char = (c) ->
  i = undefined
  i = 0
  while i < zalgo_down.length
    return true  if c is zalgo_down[i]
    i++
  i = 0
  while i < zalgo_mid.length
    return true  if c is zalgo_mid[i]
    i++
  false

zalgo = (txt, level = 0) ->
  newtxt = ""
  i = 0

  while i < txt.length
    continue  if is_zalgo_char(txt.substr(i, 1))
    num_up = undefined
    num_mid = undefined
    num_down = undefined
    
    newtxt += txt.substr(i, 1)
    
    if level is 0
      num_up = rand(8)
      num_mid = rand(2)
      num_down = rand(8)
    else if level > 0
      num_up = rand(16) / 2 + 1
      num_mid = rand(6) / 2
      num_down = rand(16) / 2 + 1
    j = 0

    while j < num_mid
      newtxt += rand_zalgo(zalgo_mid)
      j++
    q = 0

    while q < num_down
      newtxt += rand_zalgo(zalgo_down)
      q++
    i++
  newtxt
zalgo_down = [
  "̖"
  "̗"
  "̘"
  "̙"
  "̜"
  "̝"
  "̞"
  "̟"
  "̠"
  "̤"
  "̥"
  "̦"
  "̩"
  "̪"
  "̫"
  "̬"
  "̭"
  "̮"
  "̯"
  "̰"
  "̱"
  "̲"
  "̳"
  "̹"
  "̺"
  "̻"
  "̼"
  "ͅ"
  "͇"
  "͈"
  "͉"
  "͍"
  "͎"
  "͓"
  "͔"
  "͕"
  "͖"
  "͙"
  "͚"
  "̣"
]
zalgo_mid = [
  "̕"
  "̛"
  "̀"
  "́"
  "͘"
  "̡"
  "̢"
  "̧"
  "̨"
  "̴"
  "̵"
  "̶"
  "͏"
  "͜"
  "͝"
  "͞"
  "͟"
  "͠"
  "͢"
  "̸"
  "̷"
  "͡"
  "҉"
]

module.exports = (robot) ->
  robot.respond /(zalgo )(.*)/i, (msg) ->
    respond = zalgo msg.match[2]
    msg.send respond
