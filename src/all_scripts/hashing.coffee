# Description:
#   Various hashing algorithms.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot md5|sha|sha1|sha256|sha512|rmd160 me <string> - Generate hash of <string>
#
# Author:
#   jimeh

crypto = require 'crypto'

module.exports = (robot) ->
  robot.respond /md5( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'md5')

  robot.respond /SHA( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha')

  robot.respond /SHA1( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha1')

  robot.respond /SHA256( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha256')

  robot.respond /SHA512( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha512')

  robot.respond /RMD160( me)? (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'rmd160')

# hex digest helper
hexDigest = (str, algo) ->
  crypto.createHash(algo).update(str, 'utf8').digest('hex')
