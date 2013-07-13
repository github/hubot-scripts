# Description:
#   Make sure that hubot shares the ruby rules.
#
# Commands:
#   hubot the ruby rules - Make hubot explain how to write practical ruby.
#
# Notes:
#   These rules were provided by Sandy Metz in the Ruby Rouges podcast:
#   http://rubyrogues.com/087-rr-book-clubpractical-object-oriented-design-in-ruby-with-sandi-metz/

rubyRules = [
  "1. Your class can be no longer than 100 lines of code.",
  "2. Your methods can be no longer than 5 lines of code.",
  "3. You can pass no more than 4 parameters and you can’t just make it one big hash.",
  "4. In your rails controller, you can only instantiate 1 object to do whatever it is that needs to be done.",
  "5. Your rails view can only know about 1 instance variable",
  "6. You can break these rules if you can explain to your pair or in your pull request why it makes sense."
]

module.exports = (robot) ->
  robot.respond /(what are )?the ruby (rules|laws)/i, (msg) ->
    msg.send rubyRules.join('\n')
