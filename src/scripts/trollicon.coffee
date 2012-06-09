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
  'gasp'            : 'http://i.imgur.com/tYmuZ.png',
  'challenge'       : 'http://i.imgur.com/jbKmr.png',
  'lol'             : 'http://i.imgur.com/WjI3L.png',
  'no'              : 'http://i.imgur.com/loC5s.png',
  'yao'             : 'http://i.imgur.com/wTAP3.png',
  'kidding'         : 'http://i.imgur.com/0uCcv.png',
  'megusta'         : 'http://i.imgur.com/QfeUB.png',
  'isee'            : 'http://i.imgur.com/M4bcv.png',
  'fuckyeah'        : 'http://i.imgur.com/m7mEZ.png',
  'problem'         : 'http://i.imgur.com/oLlJm.png',
  'dissapoint'      : 'http://i.imgur.com/EwBi7.png',
  'nothing'         : 'http://i.imgur.com/Nwos9.png',
  'pokerface'       : 'http://i.imgur.com/dDjvG.png',
  'ok'              : 'http://i.imgur.com/QRCoI.png',
  'sadtroll'        : 'http://i.imgur.com/gYsxd.png',
  'yuno'            : 'http://i.imgur.com/sZMnV.png',
  'true'            : 'http://i.imgur.com/oealL.png',
  'freddie'         : 'http://i.imgur.com/zszUl.png',
  'forever'         : 'http://i.imgur.com/5MBi2.png',
  'jackie'          : 'http://i.imgur.com/63oaA.png',
  'fu'              : 'http://i.imgur.com/YHYTg.png',
  'rage'            : 'http://i.imgur.com/itXDM.png',
  'areyoukiddingme' : 'http://i.imgur.com/0uCcv.png',
  'nothingtodo'     : 'http://i.imgur.com/Nwos9.png',
  'moonshot'        : 'http://i.imgur.com/E8Dq3.png',
  'cerealguy'       : 'http://i.imgur.com/sD2jS.png',
  'gtfo'            : 'http://i.imgur.com/kSxyw.png',
  'youdontsay'      : 'http://i.imgur.com/xq9Ix.png',
  'motherofgod'     : 'http://i.imgur.com/CxL3b.png',
  'likeasir'        : 'http://i.imgur.com/CqBdw.png'
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
