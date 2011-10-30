# Search stack overflow and provide links to the first 5 questions.
#
# sosearch me <query> - Search for the query
# or
# sosearch me <query> with tags <tag list sperated by ,> - Search for the query limit to given tags

wwwdude = require("wwwdude")

# API keys are public for Stackapps
hubot_stackapps_apikey = 'BeOjD228tEOZP6gbYoChsg'

module.exports = (robot) ->
  robot.respond /sosearch( me)? (.*)/i, (msg) ->
    re = RegExp("(.*) with tags (.*)", "i")
    opts = msg.match[2].match(re)
    if opts?
      soSearch msg, escape(opts[1]), opts[2].split(',')
    else 
      soSearch msg, escape(msg.match[2]), null

soSearch = (msg, search, tags) ->
  client = wwwdude.createClient
    headers: { 'User-Agent': 'hubot search' }
    gzip: true
    timeout: 500

  tagged = ''
  if tags?
    for tag in tags
      tagged += "#{tag.replace(/^\s+|\s+$/g,'')};"
    tagged = "&tagged=#{escape(tagged[0..tagged.length-2])}"
   
  client.get("http://api.stackoverflow.com/1.1/search?intitle=#{search}#{tagged}&key=#{hubot_stackapps_apikey}")
  .addListener 'error', (err) ->
    console.log("Error: #{err}")
    msg.reply "Error while executing search."
  .addListener 'http-error', (data, resp) ->
    console.log("Error code: #{resp.statusCode}")
    msg.reply "Error while executing search."
  .addListener 'success', (data, resp) ->
    results = JSON.parse(data)

    if results.total > 0
      qs = for question in results.questions[0..5]
        "http://www.stackoverflow.com/questions/#{question.question_id} - #{question.title}"
      if results.total-5 > 0
        qs.push "#{results.total-5} more..."
      for ans in qs
        msg.send ans
    else
      msg.reply "No questions found matching that search."
