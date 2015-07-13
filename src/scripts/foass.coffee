# Description:
#   Basic interface for FOAAS.com
#
# Commands
#   fu <object> - tells <object> to f off with random response from FOASS
#   fu - express displeasure with random response from FOASS
#
# Dependencies:
#   None
#
# Author:
#   zacechola


module.exports = (robot) ->
  robot.hear /^fu(?:\s)(?=([\w ]+))/i, (msg) ->
    options = [
      'off',
      'you',
      'donut',
      'shakespeare',
      'linus',
      'king',
      'chainsaw',
      'outside',
      'madison',
      'nugget',
      'yoda'
    ]

    from = msg.message.user.name

    to = msg.match[1]

    if to
      options.push(to)
      random_fu = msg.random options
      if random_fu is to
        # if our random fu matched to, call /to/from
        url = "http://foaas.com/#{random_fu}/#{from}/"
      else
        # else use default /option/to/from
        url = "http://foaas.com/#{random_fu}/#{to}/#{from}/"

    else
      # or if we have no parameter for to, use these options
      options = [
        'this',
        'that',
        'everything',
        'everyone',
        'pink',
        'life',
        'thanks',
        'flying',
        'fascinating',
        'cool',
        'what',
        'because'
      ]
      random_fu = msg.random options
      # call /option/to
      url = "http://foaas.com/#{random_fu}/#{from}/"

    msg.http(url)
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        try
          json = JSON.parse body
          msg.send "#{json.message}\n#{json.subtitle}"
        catch error
          msg.send "Fuck this error!"
