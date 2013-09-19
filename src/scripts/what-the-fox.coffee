# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   what the fox say?
#
# Author:
#   hartmamt

fox_quotes = [
  "Ring-ding-ding-ding-dingeringeding!
  Gering-ding-ding-ding-dingeringeding!
  Gering-ding-ding-ding-dingeringeding!",
  "Wa-pa-pa-pa-pa-pa-pow!
  Wa-pa-pa-pa-pa-pa-pow!
  Wa-pa-pa-pa-pa-pa-pow!",
  "Hatee-hatee-hatee-ho!
  Hatee-hatee-hatee-ho!
  Hatee-hatee-hatee-ho!",
  "Joff-tchoff-tchoffo-tchoffo-tchoff!
  Tchoff-tchoff-tchoffo-tchoffo-tchoff!
  Joff-tchoff-tchoffo-tchoffo-tchoff!",
  "Jacha-chacha-chacha-chow!
  Chacha-chacha-chacha-chow!
  Chacha-chacha-chacha-chow!",
  "Fraka-kaka-kaka-kaka-kow!
  Fraka-kaka-kaka-kaka-kow!
  Fraka-kaka-kaka-kaka-kow!",
  "A-hee-ahee ha-hee!
  A-hee-ahee ha-hee!
  A-hee-ahee ha-hee!",
  "A-oo-oo-oo-ooo!
  Woo-oo-oo-ooo!"
]

module.exports = (robot) ->
  robot.hear /.*(what the fox say).*/i, (msg) ->
    msg.send msg.random fox_quotes

