# Description:
#   Base36 encoding and decoding
#
# Dependencies:
#   None
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
  constructor: ->
    @alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
    @base = @alphabet.length

  encode: (num) ->
    throw new Error('Value passed is not an integer.') unless /^\d+$/.test num
    num = parseInt(num) unless typeof num == 'number'
    str = ''
    while num >= @base
      mod = num % @base
      str = @alphabet[mod] + str
      num = (num - mod)/@base
    @alphabet[num] + str

  decode: (str) ->
    num = 0
    for char, index in str.split(//).reverse()
      if (char_index = @alphabet.indexOf(char)) == -1
        throw new Error('Value passed is not a valid Base36 string.')
      num += char_index * Math.pow(@base, index)
    num

Base36 = new Base36Builder()
