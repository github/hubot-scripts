# Description:
#   Abolish all fear from your chat room. Hubot will calm those in peril with a
#   recitation of the Litany Against Fear.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   fear|afraid - Recite the Litany Against Fear
#
# Author:
#   wgibbs

litany = "I must not fear.\n
Fear is the mind-killer.\n
Fear is the little-death that brings total obliteration.\n
I will face my fear.\n
I will permit it to pass over me and through me.\n
And when it has gone past I will turn the inner eye to see its path.\n
Where the fear has gone there will be nothing.\n
Only I will remain."

module.exports = (robot) ->
  robot.hear /(afraid|fear)/i, (msg) ->
    msg.send litany
