# Description
#   Tells Hubot to take action on SupportFu Tickets
#
# Dependencies:
#
# Configuration:
#   SUPPORTFU_HOST     - "site.supportfu.com", where site is your company name
#   SUPPORTFU_TOKEN    - "email:password", token to authenticate user
#
# Commands:
#   hubot (supportfu|support) <ticket-no>                 - Show info for a ticket
#   hubot (supportfu|support) open|close|hold <ticket-no> - Update an ticket status
#   hubot (supportfu|support) trash|spam <ticket-no>      - Put an ticket to spam or trash
#
# Author:
#   siuying

class SupportFu
  constructor: (@host, @token, @http) ->
    @apiBase = "https://#{@token}@#{@host}/api/v1"

  findTicketByNumber: (msg, ticketNumber, handler) ->
    @request msg, 'get', "#{@apiBase}/tickets?q=number:#{ticketNumber}", (tickets) ->
      if tickets.length == 0
        msg.reply "Sorry I can't find ticket \"#{ticketNumber}\"!"
        return
      ticket = tickets[0]
      handler ticket

  updateTicket: (msg, ticketNumber, params) ->
    @findTicketByNumber msg, ticketNumber, (ticket) =>
      ticketId = ticket['id']
      unless ticketId
        msg.reply "Ticket id for ##{ticketNumber} not found!"
        return

      url = "#{@apiBase}/tickets?id=#{ticketId}"
      data = JSON.stringify(params)
      @http(url).headers({Accept: 'application/json', 'Content-Type': 'application/json'}).patch(data) (err, res, body) ->
        if err
          msg.reply "Sorry I can't update ticket, error: #{err}"
          return
        msg.reply "Ticket ##{ticketNumber} updated."

  request: (msg, method, url, handler) ->
    @http(url)[method]() (err, res, body) ->
      if err
        msg.reply "Supportfu says: \"#{err}\"!"
        return

      content = JSON.parse(body)
      if content.errors?
        msg.send "Supportfu says: #{content.errors.message}"
        return
      else if content.message?
        msg.send "Supportfu says: #{content.message}"
        return

      handler content

  ticketUrl: (ticketId) ->
    "https://#{@host}/spa/ticket/#{ticketId}"

module.exports = (robot) ->
  host      = process.env.SUPPORTFU_HOST
  token     = process.env.SUPPORTFU_TOKEN
  debug     = process.env.SUPPORTFU_DEBUG
  supportfu = new SupportFu(host, token, robot['http'])

  # support #1
  robot.respond /(supportfu|support) #?([0-9]+)/i, (msg) ->
    issue = msg.match[2]
    supportfu.findTicketByNumber msg, issue, (ticket) ->
      url     = supportfu.ticketUrl(ticket['id'])
      msg.reply "Ticket ##{issue} (#{url})\n #{ticket['subject']}\nState: #{ticket['state']}"

  # support open|close|held #1
  robot.respond /(supportfu|support) (open|close|closed|hold) #?([0-9]+)/i, (msg) ->
    state = msg.match[2]
    state = 'closed' if state == 'close'
    number = msg.match[3]
    supportfu.updateTicket msg, number, {'state': state}

  # support spam|trash 1
  robot.respond /(supportfu|support) (spam|trash) #?([0-9]+)/i, (msg) ->
    state = msg.match[2]
    number = msg.match[3]
    params = if state == "spam" then {spam: "true"} else {trash: "true"}
    supportfu.updateTicket msg, number, params