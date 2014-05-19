
# Description:
# Ask hubot a question, and get an answer. Uses the Wolfram Alpha API
#Configuration
#Set the Wolfram Alpha App_Id as an environment variable "WOLFRAM_ID"
# Commands:
# hubot answer (question)
# Author:
# @manugarri

jsdom = require('jsdom');

WOLFRAM_API_ID = process.env.WOLFRAM_ID

parse_xml = (xml) ->
  result = jsdom.jsdom(xml)
  result.getElementsByTagName('plaintext')[0].childNodes[0].nodeValue

module.exports = (robot) ->
  robot.respond /(answer) (.*)/i, (msg) ->
    askWolframAlpha msg, (result)  ->
       msg.send result

askWolframAlpha = (msg, cb) -> 
  question = encodeURIComponent msg.match[2]
  msg.http("http://api.wolframalpha.com/v2/query?podindex=2&format=plaintext&appid=#{ WOLFRAM_API_ID }&input=#{ question }")
       .get() (err, res, body) ->
        try
          result = parse_xml body
        catch err
          result = "Sorry but I do not have an answer to that question."
        cb(result)

