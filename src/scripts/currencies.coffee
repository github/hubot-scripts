# Description:
#   allows hubot to perform currency exchange in 33 currencies. Uses open ECB data.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot convert <money> <currency code> into <currency code> - converts currency
#
# Author:
#   sighmoan

currencies = [
  "EUR",
  "USD",
  "JPY",
  "BGN",
  "CZK",
  "DKK",
  "GBP",
  "HUF",
  "LTL",
  "PLN",
  "RON",
  "SEK",
  "CHF",
  "NOK",
  "HRK",
  "RUB",
  "TRY",
  "AUD",
  "BRL",
  "CAD",
  "CNY",
  "HKD",
  "IDR",
  "ILS",
  "INR",
  "KRW",
  "MXN",
  "MYR",
  "NZD",
  "PHP",
  "SGD",
  "THB",
  "ZAR" ]

fetchRateFromXML = (code, xml) ->
  return 1 if code is 'EUR'

  regexp = new RegExp(".*#{code}' rate='([0-9.]+)'.*", 'i')
  match = regexp.exec xml
  if match is null then return "err" else return match[1]

module.exports = (robot) ->
  currency_choices = (currency for _, currency of currencies).join('|')
  currency_request = new RegExp("(convert )?([0-9.]+) (#{currency_choices}) (into |in |to )?(#{currency_choices})", 'i')

  robot.respond currency_request, (msg) ->
    amount = msg.match[2]
    if !isNaN(+amount)
      orig_code = msg.match[3].toUpperCase()
      dest_code = msg.match[5].toUpperCase()

      msg.http("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
       .header('User-Agent', 'Mozilla/5.0')
       .get() (err, res, body) -> 
         orig_exchg = fetchRateFromXML(orig_code, body)
         dest_exchg = fetchRateFromXML(dest_code, body)
 
         if orig_exchg is "err" or dest_exchg is "err"
           msg.send "Sorry, the ECB isn't playing with us."
         else
           amount_dest = (amount / orig_exchg) * dest_exchg
           msg.send "#{amount} #{orig_code} is #{amount_dest.toFixed(2)} #{dest_code}."