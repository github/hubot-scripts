# Description:
#   How Do I ___? Because Hubot knows more than you.
#   Based on howdoi (https://github.com/gleitz/howdoi)
#
# Dependencies:
#   "scraper": "0.0.9"
#
# Configuration:
#   None
#
# Commands:
#   hubot howdoi <do thing> - Searches Stack Overflow for a way of doing thing.
#
# Author:
#   pettazz 

scraper = require 'scraper'

module.exports = (robot) ->
    robot.respond /(howdoi|how do i)(.*)/i, (message) ->
        search = message.match[2]
        
        options = {
            'uri': "https://www.google.com/search?q=site:stackoverflow.com%20#{search}",
            'headers': {
                'Accept-Language': 'en-us,en;q=0.5',
                'Accept-Charset': 'utf-8',
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17'
            }
        }

        scraper options, (err, jQuery) ->
            message.send err  if err
            if jQuery('*:contains("did not match any documents.")').length > 0
                message.send "Sorry, I don't know anything about that.\n"
            else
                first_sresult = jQuery(".r a:first").attr('href')
                options.uri = first_sresult
                message.send options.uri
                scraper options, (err, jQuery) ->
                    message.send err  if err
                    if jQuery('div#answers').hasClass('no-answers')
                        result = "Sorry, I can't find any answers about that.\n"
                    else
                        answer = jQuery("div#answers div.answer:first div.post-text")
                        answer_code = jQuery(answer).find('pre code')
                        if answer_code.length > 0
                            result = answer_code.text()
                        else
                            result = jQuery(answer).text()

                    message.send result
