# Description:
#   Send gtalk messages to channels via hubot
#
# Dependencies:
#   "node-xmpp": "0.3.2"
#
# Configuration
#   GTALK_ID
#   GTALK_PASSWORD
#   GTALK_ONLINE_ANNOUNCE
#   GTALK_PRESENCE
#   GTALK_SERVER
#   GTALK_PORT
#   GTALK_ROOM
#
# Commands:
#   None
#
# Author:
#   gstark

module.exports = (robot) ->
  jid             = process.env.GTALK_ID
  password        = process.env.GTALK_PASSWORD
  online_announce = process.env.GTALK_ONLINE_ANNOUNCE
  presence        = process.env.GTALK_PRESENCE || "Echoing to campfire"
  server          = process.env.GTALK_SERVER   || "talk.google.com"
  port            = process.env.GTALK_PORT     || 5222
  room            = process.env.GTALK_ROOM

  xmpp = require 'node-xmpp'

  xmpp_client = new xmpp.Client({jid: jid, password: password, host: server, port: port });

  message_handler = (stanza) ->
    if stanza.is('message') and stanza.attrs.type != 'error'
      message_body_element = stanza.getChild('body');
      if message_body_element
        robot.send { room: room }, "From: " + stanza.attrs.from + " " + message_body_element.getText()

  online_handler = ->
    xmpp_client.send(new xmpp.Element('presence', {}).c('show').t('chat').up().c('status').t(presence));
    if (online_announce)
      robot.send { room: room }, online_announce

  error_handler = (error) ->
    robot.send { room: room }, "Caught an error " + error

  xmpp_client.on('online', online_handler)
  xmpp_client.on('stanza', message_handler)
  xmpp_client.on('error',  error_handler)
