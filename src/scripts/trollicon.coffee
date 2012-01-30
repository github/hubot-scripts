# trollicon - Returns a trollicon image
# by Adan Alvarado

trollicons = {
  'gasp' : 'http://i.imgur.com/tYmuZ.png',
  'challenge': 'http://i.imgur.com/jbKmr.png',
  'lol' : 'http://i.imgur.com/WjI3L.png',
  'no' : 'http://i.imgur.com/loC5s.png',
  'yao' : 'http://i.imgur.com/wTAP3.png',
  'kidding' : 'http://i.imgur.com/0uCcv.png',
  'megusta' : 'http://i.imgur.com/QfeUB.png',
  'isee': 'http://i.imgur.com/M4bcv.png',
  'fuckyeah' : 'http://i.imgur.com/m7mEZ.png'
}

module.exports = (robot)->
  robot.respond /trollicon( me)? (.*)/i, (message)->
    message.send "#{trollicons[message.match[2]]}" if message.match[2] of trollicons

