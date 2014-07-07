# Description:
#   Base36 encoding and decoding
#
# Dependencies:
#   "big-integer": "1.1.5"
#
# Configuration:
#   None
#
# Commands:
#   hubot base36 e(ncode)|d(ecode) <query> - Base36 encode or decode <query>
#
# Author:
#   plytro

module.exports = (robot) ->
  robot.hear /base36 e(ncode)?( me)? (.*)/i, (msg) ->
    try
      msg.send Base36.encode(msg.match[3])
    catch e
      throw e unless e.message == 'Value passed is not an integer.'
      msg.send "Base36 encoding only works with Integer values."

  robot.hear /base36 d(ecode)?( me)? (.*)/i, (msg) ->
    try
      msg.send (String) Base36.decode(msg.match[3])
    catch e
      throw e unless e.message == 'Value passed is not a valid Base36 string.'
      msg.send "Not a valid base36 encoded string."

class Base36Builder
  bigInt = require("big-integer");
  constructor: ->
    @alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
    @base = @alphabet.length

  encode: (strIn) ->
    num = bigInt(strIn)
    str = ""
    while num.greaterOrEquals(@base)
      mod = bigInt(num.mod(@base))
      str = @alphabet[mod.toString()] + str
      num = num.subtract(mod).divide(@base)
    str = @alphabet[num.toString()] + str



  decode: (str) ->
    num = bigInt("0")
    power = bigInt(@base)
    for char, index in str.split("").reverse()
      if (char_index = @alphabet.indexOf(char)) == -1
        throw new Error('Value passed is not a valid Base36 string.')
      num = num.plus(power.pow(index).multiply(char_index))
    num.toString()

Base36 = new Base36Builder()

