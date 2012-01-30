# trollicon - Returns a trollicon image
# by Adan Alvarado
# used resources from : https://github.com/sagargp/trollicons Adium extension

trollicons = {
  'gasp' : 'http://i.imgur.com/tYmuZ.png',
  'challenge': 'http://i.imgur.com/jbKmr.png',
  'lol' : 'http://i.imgur.com/WjI3L.png',
  'no' : 'http://i.imgur.com/loC5s.png',
  'yao' : 'http://i.imgur.com/wTAP3.png',
  'kidding' : 'http://i.imgur.com/0uCcv.png',
  'megusta' : 'http://i.imgur.com/QfeUB.png',
  'isee': 'http://i.imgur.com/M4bcv.png',
  'fuckyeah' : 'http://i.imgur.com/m7mEZ.png',
  'problem' : 'http://i.imgur.com/oLlJm.png',
  'dissapoint' : 'http://i.imgur.com/EwBi7.png',
  'nothing' : 'http://i.imgur.com/Nwos9.png',
  'pokerface' : 'http://i.imgur.com/dDjvG.png',
  'ok' : 'http://i.imgur.com/QRCoI.png'
}

module.exports = (robot)->
  robot.respond /trollicon( me)? (.*)/i, (message)->
    message.send "#{trollicons[message.match[2]]}" if message.match[2] of trollicons

