# Description:
#   Base58 encoding and decoding
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot base58 encode|decode <query> - Base58 encode or decode <query>
#
# Author:
#   jimeh

module.exports = (robot) ->
  robot.respond /base58 encode( me)? (.*)/i, (msg) ->
    try
      msg.send Base58.encode(msg.match[2])
    catch e
      throw e unless e.message == 'Value passed is not an integer.'
      msg.send "Base58 encoding only works with Integer values."

  robot.respond /base58 decode( me)? (.*)/i, (msg) ->
    try
      msg.send Base58.decode(msg.match[2])
    catch e
      throw e unless e.message == 'Value passed is not a valid Base58 string.'
      msg.send "Not a valid base58 encoded string."

class Base58Builder
  constructor: ->
    @alphabet = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
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
        throw new Error('Value passed is not a valid Base58 string.')
      num += char_index * Math.pow(@base, index)
    num

Base58 = new Base58Builder()
