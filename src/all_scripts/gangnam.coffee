# Description:
#   Produces a random gangnam style gif
#
# Dependencies:
#   None
# Configuration:
#   None
#
# Commands:
#   hubot oppa gangnam style - Return random gif from gifbin.com
#
# Author:
#   EnriqueVidal

gifs = [
  "http://i1.kym-cdn.com/photos/images/original/000/370/936/cb3.gif",
  "http://i3.kym-cdn.com/photos/images/original/000/363/835/32a.gif",
  "http://i3.kym-cdn.com/photos/images/original/000/388/760/3f3.gif",
  "http://i2.kym-cdn.com/photos/images/original/000/386/610/52d.gif",
  "https://a248.e.akamai.net/camo.github.com/fd39c2be2c139705edba5c52738a7c111be9ad37/687474703a2f2f7777772e726566696e65646775792e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031322f31302f67616e676e616d2d7374796c652d737461722d776172732d6769662e676966",
  "https://a248.e.akamai.net/camo.github.com/0a7ede4e91eabd1d5e0a86901efb984136765410/687474703a2f2f696d67342e6a6f7972656163746f722e636f6d2f706963732f706f73742f6769662d737461722d776172732d67616e676e616d2d7374796c652d68616e2d736f6c6f2d3337303636342e676966",
  "https://a248.e.akamai.net/camo.github.com/d82d76a32a0d667c8f2f6d7bf0d9e0b1abe75399/687474703a2f2f7261636b2e302e6d736863646e2e636f6d2f6d656469612f5a676b794d4445794c7a45774c7a45344c7a4577587a4d31587a4134587a51794d6c396d6157786c2f6130376264663034"
  ]

module.exports = (robot)->
  robot.hear /gangnam style/i, (message)-> #changed gifbin
    message.send message.random gifs
