# 
# whatis <term> - search the term on urbandictionary.com, return the

jsdom = require('jsdom').jsdom

module.exports = (robot) ->
  robot.respond /whatis (.+)$/i, (msg) ->
    msg
      .http('http://www.urbandictionary.com/define.php?term=' + msg.match[1])
      .get() (err, res, body) ->
        window = (jsdom body, null, {
          features : {
            FetchExternalResources : false
            ProcessExternalResources : false
            MutationEvents : false
            QuerySelector : false
          }
        }).createWindow()

        $ = require('jquery').create(window)

        definitions = []
        $(".definition").each (idx, item) ->
          definitions.push $(item).text()

        if definitions.length == 0
          msg.send "No definition found."
        else
          msg.send (msg.random definitions)

