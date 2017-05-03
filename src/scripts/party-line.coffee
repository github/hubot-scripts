# Description:
#   Set up an XMPP party line. Any messages the hubot gets
#   will be relayed to all contacts on the XMPP client's
#   primary roster (contact list).
#
#   Currently relies on a fork of hubot-xmpp that supports
#   rosters. Hopefully this will get merged into master soon.
#
# Dependencies:
#   "hubot": "2.7.2"
#   "node-xmpp": "0.15.0"
#   "hubot-xmpp": "git://github.com/farski/hubot-xmpp.git/xmpp-roster-support"
#
# Configuration:
#   (Required by hubot-xmpp)
#   HUBOT_XMPP_USERNAME
#   HUBOT_XMPP_PASSWORD
#   HUBOT_XMPP_ROOMS
#
# Commands:
#   None
#   This is intened to relay *all* messages to *all* contacts.
#
# Authors:
#   PRX, Chris Kalafarski
#

Xmpp = require 'node-xmpp'

module.exports = (robot) ->
  robot.catchAll (msg) ->
    from = new Xmpp.JID(msg.message.room)
    text = "#{from.user}: #{msg.message.text}"

    for jid in robot.xmppRoster
      if from.user != jid.user
        params =
          to: jid.toString()
          type: 'chat'

        message = new Xmpp.Element('message', params).c('body').t(text)
        robot.adapter.client.send message
