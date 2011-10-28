# Cowsay.
#
# cowsay <dead|greedy|paranoid|tired|wired|youthful> <statement> - Returns a cow that says what you want.

eyes = {
  'default'  : 'oo',
  'dead'     : 'XX',
  'greedy'   : '$$',
  'paranoid' : '@@',
  'tired'    : '--',
  'wired'    : 'OO',
  'youthful' : '..'
}

module.exports = (robot) ->
  robot.respond /cowsay( me)?( (dead|greedy|paranoid|tired|wired|youthful))? (.*)/i, (msg) ->
    msg.send cowsayMe(msg.match[3], msg.match[4])

cowsayMe = (eyeChoice='default', phrase) ->
  maxLineLength   = 20
  length          = phrase.length
  bubble          = ''
  lines           = []
  cow             = '\t\\   ^__^\n\t \\  (EYES)\\_______\n\t    (__)\\       )\\/\\\n\t\t||----w |\n\t\t||     ||'

  cow = cow.replace('EYES', eyes[eyeChoice])

  if phrase.length > maxLineLength
    words = phrase.split ' '
    line  = ''

    for word in words
      if line.length > 0 && (line.length + word.length) > maxLineLength
        lines.push line
        line = ''

      if line.length == 0
        line = word
      else
        line = line + ' ' + word

    lines.push line
  else
    lines.push phrase

  longestLineLength = 0

  for line in lines
    if line.length > longestLineLength
      longestLineLength = line.length
   
  for i in [0..longestLineLength+4] by 1
    bubble += '_'

  bubble += '\n'

  for line in lines
    bubble += '| ' + line
    for j in [0..longestLineLength-line] by -1
      bubble += ' '

    bubble += ' |\n'

  for i in [0..longestLineLength+4] by 1
    bubble += '-'

  return bubble + '\n' + cow
