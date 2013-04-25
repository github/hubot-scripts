# Description:
#   Allows Hubot to speak many languages
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_MSTRANSLATE_CLIENT_ID
#   HUBOT_MSTRANSLATE_CLIENT_SECRET
#
# Commands:
#   speak me <phrase> - Detects the language 'phrase' is written in, then sends back a spoken version of that phrase
#
# Author:
#   atmos

module.exports = (robot) ->
  robot.hear /(speak)( me)? (.*)/i, (msg) ->
    term   = "\"#{msg.match[3]}\""
    clientId = process.env.HUBOT_MSTRANSLATE_CLIENT_ID
    clientSecret = process.env.HUBOT_MSTRANSLATE_CLIENT_SECRET
    langs = ["en"]

    #MS changed their token service, have to use this oauth thing see http://msdn.microsoft.com/en-us/library/hh454950.aspx
    tokenService = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
    tokenScope = "http://api.microsofttranslator.com"
    getLanguagesForSpeak = "http://api.microsofttranslator.com/V2/Ajax.svc/GetLanguagesForSpeak"
    detect = "http://api.microsofttranslator.com/V2/Ajax.svc/Detect"
    speak = "http://api.microsofttranslator.com/V2/Ajax.svc/Speak"

    unless clientId
      msg.send "MS Translate Client ID isn't set, follow steps at http://msdn.microsoft.com/en-us/library/hh454950.aspx"
      msg.send "Then, set the HUBOT_MSTRANSLATE_CLIENT_ID environment variable"
      return

    unless clientSecret
      msg.send "MS Translate Client Secret isn't set, follow steps at http://msdn.microsoft.com/en-us/library/hh454950.aspx"
      msg.send "Then, set the HUBOT_MSTRANSLATE_CLIENT_SECRET environment variable"
      return

    clientId = encodeURIComponent(clientId)
    clientSecret  = encodeURIComponent(clientSecret)

    msg.http(tokenService)
      .header('Content-Type', 'application/x-www-form-urlencoded')
      #can you do this by passing in an object literal? i tried but it didn't work...
      .post( "client_id=#{clientId}&client_secret=#{clientSecret}&scope=#{tokenScope}&grant_type=client_credentials") (err, res, body) ->
        parsedBody = JSON.parse(body)
        if err or parsedBody.error
          msg.send "Unable to get token, #{err or parsedBody.error_description}"
          return
        accessToken = "Bearer " + parsedBody.access_token 
        msg.http(getLanguagesForSpeak)
          .query({ appId: accessToken })
          .get() (err, res, body) ->
            langs = eval(body) unless err

            msg.http(detect)
              .query({appId: accessToken, text: term})
              .get() (err, res, body) ->
                if err or (langs.indexOf(eval(body)) == -1)
                  msg.send "Sorry, I can't speak #{err or eval(body)}"
                  return
                lang = eval(body)

                msg.http(speak)
                  .query({ appId: accessToken, text: term, language: lang, format: "audio/wav" })
                  .get() (err, res, body) ->
                    msg.send(eval(body)) unless err
