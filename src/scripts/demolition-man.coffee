# Watch your language!

module.exports = (robot) ->

  words = [
    'arse',
    'ass',
    'bastard',
    'bugger',
    'bollocks',
    'bullshit',
    'cock',
    'cunt',
    'damn',
    'dick',
    'douche',
    'fag',
    'fuck',
    'fucked',
    'piss',
    'shit',
    'wank'
  ]
  regex = new RegExp('(?:^|\\s)(' + words.join('|') + ')(?:\\s|\\.|\\?|!|$)', 'i');

  robot.hear regex, (msg) ->
    msg.send 'You have been fined one credit for a violation of the verbal morality statute.'
