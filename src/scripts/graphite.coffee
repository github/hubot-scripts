# Allows Hubot to search a Graphite server for saved graphs
#
# hubot graphite search <string> - search for graph by name
# hubot graphite show <graph.name> - output graph
#
# prerequisites:
#  * have accounts on both mysqueezebox.com & pandora
#  * have the pandora app installed on squeezebox
#  * be signed into your pandora account on mysqueezebox.com
#
# set the env variables:
#  * GRAPHITE_URL (e.g. https://graphite.example.com)
#  * GRAPHITE_PORT (e.g. 8443)
#  * GRAPHITE_AUTH (e.g. user:port for Basic Auth)
#
# tested against Graphite 0.9.9 with Basic Auth enabled

module.exports = (robot) ->
  robot.hear /graphite search (\w+)/i, (msg) ->
    regex = new RegExp(msg.match[1], "gi")
    treeversal msg, (data) ->
      msg.send data.id unless data.id.search(regex) == -1
  robot.hear /graphite show (\S+)/i, (msg) ->
    treeversal msg, (data) ->
      if data.id == msg.match[1]
        construct_url msg, data.graphUrl, (url) ->
          msg.send url

construct_url = (msg, graphUrl, cb) ->
  cb(graphUrl) unless process.env.GRAPHITE_AUTH
  graphRegex = /(\bhttps?:\/\/)(\S+)(\/render\/\S+)$/
  serverRegex = /(\bhttps?:\/\/)(\S+)$/
  uri = graphUrl.match(graphRegex)[3]
  proto = process.env.GRAPHITE_URL.match(serverRegex)[1]
  server = process.env.GRAPHITE_URL.match(serverRegex)[2]
  port = ':'
  if process.env.GRAPHITE_PORT
    port += process.env.GRAPHITE_PORT
  else if process.env.GRAPHITE_URL.match(/https/)
    port += 443
  else
    port += 80
  timestamp = '#' + new Date().getTime()
  suffix = '&png'
  newUrl = proto + process.env.GRAPHITE_AUTH + '@' + server + port + uri + timestamp + suffix
  cb(newUrl)

treeversal = (msg, cb, node="") ->
  data = {}
  if node == ""
    prefix = "*"
  else
    prefix = node + ".*"
  port = ':'
  if process.env.GRAPHITE_PORT
    port += process.env.GRAPHITE_PORT
  else if process.env.GRAPHITE_URL.match(/https/)
    port += 443
  else
    port += 80
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
          cb(nodes[i]) unless nodes[i].id == "no-click"
        i++

