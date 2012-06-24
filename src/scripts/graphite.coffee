# Description:
#   Allows Hubot to search a Graphite server for saved graphs
#
# Dependencies:
#   None
#
# Configuration
#   GRAPHITE_URL (e.g. https://graphite.example.com)
#   GRAPHITE_PORT (e.g. 8443)
#   GRAPHITE_AUTH (e.g. user:password for Basic Auth)
#
# Commands:
#   hubot graphite search <string> - search for graph by name
#   hubot graphite show <graph.name> - output graph
#
# Author:
#   obfuscurity

module.exports = (robot) ->
  robot.hear /graphite search (\w+)/i, (msg) ->
    treeversal msg, (data) ->
      output = ""
      output += metric.id + "\n" for metric in data
      msg.send output
  robot.hear /graphite show (\S+)/i, (msg) ->
    treeversal msg, (data) ->
      construct_url msg, data[0].graphUrl, (url) ->
        msg.send url

construct_url = (msg, graphUrl, cb) ->
  cb(graphUrl) unless process.env.GRAPHITE_AUTH
  graphRegex = /(\bhttps?:\/\/)(\S+)(\/render\/\S+)$/
  serverRegex = /(\bhttps?:\/\/)(\S+)$/
  uri = graphUrl.match(graphRegex)[3]
  proto = process.env.GRAPHITE_URL.match(serverRegex)[1]
  server = process.env.GRAPHITE_URL.match(serverRegex)[2]
  port = construct_port()
  timestamp = '#' + new Date().getTime()
  suffix = '&png'
  newUrl = proto + process.env.GRAPHITE_AUTH + '@' + server + port + uri + timestamp + suffix
  cb(newUrl)

treeversal = (msg, cb, node="") ->
  data = []
  if node == ""
    prefix = "*"
  else
    prefix = node + ".*"
  port = construct_port()
  uri = "/browser/usergraph/?query=#{prefix}&format=treejson&contexts=1&path=#{node}&user=#{node}&node=#{node}"
  auth = 'Basic ' + new Buffer(process.env.GRAPHITE_AUTH).toString('base64') if process.env.GRAPHITE_AUTH
  msg
    .http(process.env.GRAPHITE_URL + port + uri)
    .headers(Authorization: auth if auth, Accept: "application/json", 'Content-type': 'application/json')
    .get() (err, res, body) ->
      unless res.statusCode is 200
        console.log(res)
      nodes = JSON.parse body
      i = 0
      while (i < nodes.length)
        if nodes[i].leaf == 0
          treeversal(msg, cb, nodes[i].id)
        else
          regex = new RegExp(msg.match[1], "gi")
          unless nodes[i].id.search(regex) == -1
            unless nodes[i].id == "no-click"
              data[data.length] = nodes[i]
        i++
      cb(data) if data.length > 0

construct_port = () ->
  port = ':'
  if process.env.GRAPHITE_PORT
    port += process.env.GRAPHITE_PORT
  else if process.env.GRAPHITE_URL.match(/https/)
    port += 443
  else
    port += 80
  port
