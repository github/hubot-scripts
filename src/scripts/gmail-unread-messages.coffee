# Description:
#  Gets recent message from Gmail using their atom inbox feed
#
# Dependencies:
#  Cheerio
#
# Configuration:
#  Env vars for gmail access
#    GMAIL_USER
#    GMAIL_PASS
#
# Commands:
#  hubot gmail inbox
#  hubot gmail (label)
#
# Notes:
#  Uses the gmail inbox feed - https://developers.google.com/gmail/gmail_inbox_feed
#  to pull back recent messages in inbox, or with a specific label
#
# Author:
#  tgig
#
cheerio = require 'cheerio'

module.exports = (robot) ->

  getGmailUrl = (label) ->
    rootUrl = 'https://mail.google.com/mail/feed/atom'
    if label?
      rootUrl += '/' + label

    rootUrl

  retrieveMessages = (msg, url) ->

    user = process.env.GMAIL_USER
    pass = process.env.GMAIL_PASS

    #make sure vars are passed in
    if !user? or !pass?
      return msg.send 'Please set the gmail login information into environment vars'

    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64')

    msg.http(url)
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            outputMessages(msg, body)
          when 404
            msg.send "Something went wrong... 404 error"
          when 401
            msg.send "Authentication failed"
          else
            msg.send "Something went awry, and I'm not sure why :( Status code = " + res.statusCode

  outputMessages = (msg, body) ->
    out = ''
    $ = cheerio.load(body, { xmlMode: true })
    $('entry').each ->
      $this = $(this)
      out += '*' + $this.find('title').text() + '* from ' + $this.find('name').text() + ' _(' + $this.find('email').text() + ')_\n' +
        '> ' + $this.find('summary').text() + '\n' +
        '> ' + $this.find('link').attr('href') + '\n\n'

    msg.send out


  robot.respond /gmail inbox/i, (msg) ->

    url = getGmailUrl()
    retrieveMessages(msg, url)

  robot.respond /gmail label (.*)/i, (msg) ->

    label = escape(msg.match[1]) if msg.match[1]?
    url = getGmailUrl label
    retrieveMessages(msg, url)


