# Description:
#   allows hubot to track the cash and burn rate and displays a summary
#   of the current cash state. Also stores historical values in the
#   hubot brain so that they can be referred to later.
#
#   The s3-brain is HIGHLY recommended for keeping track of historical
#   cash values and not losing everything when hubot restarts.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CASH_CURRENCY_SYMBOL - the currency symbol for displaying money. Default: $
#   HUBOT_CASH_THOUSANDS_SEPARATOR - the symbol used for splitting thousands. Default: ,
#
# Commands:
#   hubot cash <left|on hand>: <amount> - set the cash on hand
#   hubot cash <burn rate|burn>: <amount> - set the burn rate
#   hubot cash <update|state|stats> - show the cash situation
#
# Notes:
#
# Author:
#   jhubert

class OutputFormatter
  months: [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

  constructor: ->
    return

  toDollars: (number, currency_symbol = (process.env.HUBOT_CASH_CURRENCY_SYMBOL or '$'), thousands_separator = (process.env.HUBOT_CASH_THOUSANDS_SEPARATOR or ',')) ->
    n = parseInt(number, 10)
    sign = if n < 0 then "-" else ""
    i = parseInt(n = Math.abs(n).toFixed(0)) + ''
    j = if (j = i.length) > 3 then j % 3 else 0
    x = if j then i.substr(0, j) + thousands_separator else ''
    y = i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands_separator)
    sign + currency_symbol + x + y

  toNiceDate: (date) ->
    date = new Date(String(date))
    @months[date.getMonth()] + ' ' + date.getDate() + ', ' + date.getFullYear()

  getMonthName: (date) ->
    date = new Date(String(date))
    @months[date.getMonth()]

class Cash
  constructor: (@robot) ->
    @cache =
      on_hand: []
      burn_rate: []

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.cash
        @cache = @robot.brain.data.cash

    return

  clean_number: (n) ->
    return n if typeof(n) == 'number'
    return parseInt(n.replace(/[^\d]/g, ''), 10)

  set_on_hand: (amount) ->
    amount = @clean_number(amount)
    @cache.on_hand.push
      date: new Date()
      amount: amount

    @robot.brain.data.cash = @cache
    amount

  set_burn_rate: (amount) ->
    amount = @clean_number(amount)
    @cache.burn_rate.push
      date: new Date()
      rate: amount

    @robot.brain.data.cash = @cache
    amount

  data: -> @cache

module.exports = (robot) ->

  cash = new Cash robot
  optf = new OutputFormatter()

  robot.respond /cash (left|on hand):? (.+)$/i, (msg) ->
    amount = cash.set_on_hand msg.match[3]
    msg.send "Ok, cash on hand is #{optf.toDollars(amount)}"

  robot.respond /cash burn( rate)?:? (.+)$/i, (msg) ->
    amount = cash.set_burn_rate msg.match[3]
    msg.send "Ok, our burn rate is #{optf.toDollars(amount)} per month"

  robot.respond /cash (stats|state|update)/i, (msg) ->
    data = cash.data()

    if data.on_hand.length > 0
      current_cash = data.on_hand[data.on_hand.length - 1]
      current_burn = data.burn_rate[data.burn_rate.length - 1]

      if !current_burn
        current_burn =
          rate: 1
          date: new Date()

      # Calculate how many months left. Use floor to be conservative
      months = Math.floor(current_cash.amount / current_burn.rate)

      # Get the month that we would run out of money at this rate
      end_date = new Date()
      end_date.setMonth(end_date.getMonth() + months)

      output = ''
      output += "Ok, we have #{optf.toDollars(current_cash.amount)} on hand as of #{optf.toNiceDate(current_cash.date)}"

      # If we have history, add a comparison to the last cash status
      if data.on_hand.length > 1
        last_cash = data.on_hand[data.on_hand.length - 2]
        diff = current_cash.amount - last_cash.amount
        if diff > 0
          diff_type = 'more'
        else
          diff_type = 'less'

        output += ", which is #{optf.toDollars(Math.abs(diff))} #{diff_type} than on #{optf.toNiceDate(last_cash.date)}. "
      else
        output += "."

      output += "\nAt our current burn rate (#{optf.toDollars(current_burn.rate)} / month), we have #{months} months left. That gets us to #{optf.getMonthName(end_date)} #{end_date.getFullYear()}."

      msg.send output
    else
      msg.send "There is no cash information available"
