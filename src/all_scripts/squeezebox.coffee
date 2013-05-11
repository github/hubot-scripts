# Description:
#   Allows Hubot to control pandora on a squeezebox music player
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect: "0.2.0"
#
# Configuration:
#   SQUEEZE_BOX_EMAIL
#   SQUEEZE_BOX_PASSWORD
#   SQUEEZE_BOX_PLAYER_ID
#
# Commands:
#   hubot pandorame <artist, song, etc> - plays on pandora
#   hubot pause|play
#   hubot vol <positive or negative #> - changes volume
#   hubot crankit|indoor voices - volume presets
#   hubot who's playing? - lists station, artist, song
#   hubot thumbsup|thumbsdown - relay preferences to pandora
#
# Author:
#   kylefritz

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

module.exports = (robot) ->

  robot.respond /(queue ?up|pandora ?me) (.+)/i, (msg) ->
    queueup(msg, msg.match[2])

  robot.respond /pause/i, (msg) ->
    _cmd msg, ["pause"]
    msg.send "lips are sealed"

  robot.respond /play/i, (msg) ->
    _cmd msg, ["play"]
    msg.send "resuming jam"

  robot.respond /vol \+?(\-?\d+)/i, (msg) ->
    vol(msg,parseInt(msg.match[1] || "10"))
    msg.send "commencing volume adjustment"

  robot.respond /crank ?it/i, (msg) ->
    vol(msg,100)
    msg.send "oh hell yeah"

  robot.respond /indoor voices/i, (msg) ->
    vol msg,-100, () ->
      vol(msg,40)
    msg.send "what do you work at a library?"

  robot.respond /wh(o|at)'?s ?(playing|this)/i, (msg) ->
    artist(msg)

  robot.respond /\(?thumbsup\)?/i,(msg) ->
    _cmd msg, ["pandora","rate",1]
    msg.send "glad you like it"

  robot.respond /yuck|\(?thumbsdown\)?/i,(msg) ->
    _cmd msg, ["pandora","rate",0]
    msg.send "seriously! who put that on?"

_login = (msg,cb) ->
  enc=encodeURIComponent
  data="email=#{enc(process.env.SQUEEZE_BOX_EMAIL)}&password=#{enc(process.env.SQUEEZE_BOX_PASSWORD)}"
  msg.http("http://mysqueezebox.com/user/login")
    .header("content-length",data.length)
    .header("Content-Type","application/x-www-form-urlencoded")
    .post(data) (err,res,body) ->
      setString = res.headers['set-cookie'][0]
      #dirty split
      squeeze_session=setString.split('; ')[0].split('=')[1]
      cookie = "Squeezebox-player=#{encodeURIComponent(process.env.SQUEEZE_BOX_PLAYER_ID)}; sdi_squeezenetwork_session=#{squeeze_session}"
      cb(cookie)

_cmd = (msg,what,cb) ->
  data=
    "id":1,
    "method":"slim.request",
    "params":[process.env.SQUEEZE_BOX_PLAYER_ID,what]
  json=JSON.stringify(data)
  _login msg, (cookie) ->
    msg.http("http://mysqueezebox.com/jsonrpc.js")
      .header("content-type","application/json")
      .header("content-length",json.length)
      .header("cookie", cookie)
      .post(json) (err,res,body) ->
        cb(err,res,body) if cb?

queueup = (msg,what) ->
  _login msg, (cookie) ->
    msg.http("http://mysqueezebox.com/browse/Pandora/1_#{encodeURIComponent(what)}")
      .header("cookie", cookie)
      .get() (err,res,body) ->
        if body.match(/No items found./)
          msg.send "no dice. couldn't find \"#{what}\"."
        else
          hits=get_number_of_hits body
          if hits==1 or what[what.length-1]=='0'
            artist msg
          else
            msg.send "got #{hits} hits for #{what}, trying first"
            queueup msg, "#{what}.0"

artist = (msg) ->
  _cmd msg, ["status","-",1,"tags:cgABbehldiqtyrSuoKLN"], (err,res,body) ->
    r=JSON.parse(body).result
    t=r.remoteMeta
    if(t.artist)
      msg.send "\"#{t.title}\" by #{t.artist} from #{t.album} @ #{r.current_title}"
      msg.send "#{t.artwork_url}"
    else
      msg.send "playing #{r.current_title}"

vol = (msg,amt,cb) ->
  delt = if amt>0 then "+" else ""
  change="#{delt}#{amt}"
  _cmd msg, ["mixer","volume",change], cb

get_number_of_hits = (body)->
  html_handler  = new HTMLParser.DefaultHandler((()->), ignoreWhitespace: true )
  html_parser   = new HTMLParser.Parser html_handler

  html_parser.parseComplete body
  Select( html_handler.dom, '.inline.text' ).length
