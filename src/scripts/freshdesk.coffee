# Description:
#   Get Freshdesk support tickets details right into your chat room.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FRESHDESK_USER
#   HUBOT_FRESHDESK_PASSWORD
#   HUBOT_FRESHDESK_DOMAIN
#
# Commands:
#   hubot get tickets
#
# Author:
#   BharathMG


freshdesk_user = "#{process.env.HUBOT_FRESHDESK_USER}"
freshdesk_password = "#{process.env.HUBOT_FRESHDESK_PASSWORD}"
freshdesk_url = "#{process.env.HUBOT_FRESHDESK_DOMAIN}"
auth = new Buffer("#{freshdesk_user}:#{freshdesk_password}").toString('base64')

open_tickets = "helpdesk/tickets.json"



freshdesk_request = (msg,action,callback) ->
  msg.http("#{freshdesk_url}/#{action}")
    .headers(Authorization: "Basic #{auth}", Accept: "application/json")
      .get() (err, res, body) ->
        if err
          msg.send "Error :: #{err}"
          return

        content = JSON.parse(body)
        callback content

module.exports = (robot) ->
  robot.respond /get (all )?tickets$/i, (msg) ->
      freshdesk_request msg, open_tickets, (ticket_results) ->
        for ticket in ticket_results
          msg.send "Status : #{ticket.status_name} with subject #{ticket.subject}, id #{ticket.display_id} and url #{freshdesk_url}/helpdesk/tickets/#{ticket.display_id}"  


        

