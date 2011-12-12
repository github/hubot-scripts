module.exports = (robot) ->
  robot.hear /^(sweet|dude)!/i, (msg) ->
    console.log msg.match
    switch msg.match[1].toLowerCase()
      when "sweet" then msg.send "Dude!"
      when "dude" then msg.send "Sweet!"
