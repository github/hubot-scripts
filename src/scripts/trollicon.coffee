# Description:
#   Return trollicon images
#   used resources from : https://github.com/sagargp/trollicons Adium extension
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :<trollicon>: - outputs <trollicon> image
#   :isee: what you did there, and :megusta: - is a valid example of multiple trollicons
#
# Author:
#   Adan Alvarado and Enrique Vidal

trollicons = {
  'gasp'            : 'https://i.imgur.com/tYmuZ.png',
  'challenge'       : 'https://i.imgur.com/jbKmr.png',
  'lol'             : 'https://i.imgur.com/WjI3L.png',
  'no'              : 'https://i.imgur.com/loC5s.png',
  'yao'             : 'https://i.imgur.com/wTAP3.png',
  'kidding'         : 'https://i.imgur.com/0uCcv.png',
  'megusta'         : 'https://i.imgur.com/QfeUB.png',
  'isee'            : 'https://i.imgur.com/M4bcv.png',
  'fuckyeah'        : 'https://i.imgur.com/m7mEZ.png',
  'problem'         : 'https://i.imgur.com/oLlJm.png',
  'dissapoint'      : 'https://i.imgur.com/EwBi7.png',
  'nothing'         : 'https://i.imgur.com/Nwos9.png',
  'pokerface'       : 'https://i.imgur.com/dDjvG.png',
  'ok'              : 'https://i.imgur.com/QRCoI.png',
  'sadtroll'        : 'https://i.imgur.com/gYsxd.png',
  'yuno'            : 'https://i.imgur.com/sZMnV.png',
  'true'            : 'https://i.imgur.com/oealL.png',
  'freddie'         : 'https://i.imgur.com/zszUl.png',
  'forever'         : 'https://i.imgur.com/5MBi2.png',
  'jackie'          : 'https://i.imgur.com/63oaA.png',
  'fu'              : 'https://i.imgur.com/YHYTg.png',
  'rage'            : 'https://i.imgur.com/itXDM.png',
  'areyoukiddingme' : 'https://i.imgur.com/0uCcv.png',
  'nothingtodo'     : 'https://i.imgur.com/Nwos9.png',
  'moonshot'        : 'https://i.imgur.com/E8Dq3.png',
  'cerealguy'       : 'https://i.imgur.com/sD2jS.png',
  'gtfo'            : 'https://i.imgur.com/kSxyw.png',
  'youdontsay'      : 'https://i.imgur.com/xq9Ix.png',
  'motherofgod'     : 'https://i.imgur.com/CxL3b.png',
  'likeasir'        : 'https://i.imgur.com/CqBdw.png'
}

module.exports = (robot)->
  robot.hear /:(\w+):/g, (message)->
    build_response message

build_response = (message)->
  orig_response = message.message.text
  response      = orig_response

  return if message.match.length == 0

  for icon in message.match
    expr  = new RegExp( icon, 'g' )
    image = trollicons[ icon.replace( /:/g, '' ) ]

    response = response.replace( expr, image ) if image != undefined

  message.send response if response != undefined and response != orig_response
