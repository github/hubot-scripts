# Description
#   Rdio API
#
# Configuration:
#   HUBOT_RDIO_KEY
#   HUBOT_RDIO_SECRET
#
# Commands:
#   <Rdio link> - Show information about the artist/album/track
#
# Author:
#   smgt

qs = require "querystring"
url = require "url"
crypto = require "crypto"
http = require "http"

module.exports = (robot) ->
  robot.hear /http:\/\/rd\.io\/x\/[a-zA-Z0-9\-]+\//i, (msg) ->
    rdio.request "getObjectFromUrl", {"url": msg.match[0]}, (err, data) ->
      if err
        msg.send "Rdio response: #{err}"
      else
        switch data.type
          when "t"
            track = "#{data.artist} - #{data.name}"
            album = "(#{data.album})"
            msg.send "Track: #{track} #{album}"
          when "r"
            msg.send "Artist: #{data.name}"
          when "a"
            msg.send "Album: #{data.artist} - #{data.name}"

rdio =
  signRequest: (consumerKey, consumerSecret, urlString, params) ->
    params = params || []
    consumer = [consumerKey, consumerSecret]

    method = "POST"
    timestamp = Math.round(new Date().getTime() / 1000).toString()
    nonce = Math.round(Math.random() * 1000000).toString()
    parsedUrl = url.parse(urlString, true)

    if !Array.isArray(params)
      paramsArray = []
      for key of params
        paramsArray.push [key, params[key]]
      params = paramsArray

    params.push ["oauth_version", "1.0"]
    params.push ["oauth_timestamp", timestamp]
    params.push ["oauth_nonce", nonce]
    params.push ["oauth_signature_method", "HMAC-SHA1"]
    params.push ["oauth_consumer_key", consumer[0]]

    if parsedUrl.query
      for key in parsedUrl.query
        params.push [key, parsedUrl.query[key]]

    hmacKey = consumer[1] + "&"

    params.sort()

    paramsString = params.map (param) ->
      return qs.escape(param[0]) + "=" + qs.escape(param[1])
    .join("&")

    urlBase = url.format
      protocol: parsedUrl.protocol || "http:"
      hostname: parsedUrl.hostname.toLowerCase()
      pathname: parsedUrl.pathname

    signatureBase = [
      method
      qs.escape(urlBase)
      qs.escape(paramsString)
    ].join "&"

    hmac = crypto.createHmac "sha1", hmacKey
    hmac.update signatureBase
    oauthSignature = hmac.digest "base64"

    headerParams = []
    headerParams.push ["oauth_signature", oauthSignature]

    oauthParams = [
      "oauth_version"
      "oauth_timestamp"
      "oauth_nonce"
      "oauth_signature_method"
      "oauth_signature"
      "oauth_consumer_key"
      "oauth_token"
    ]

    params.forEach (param) ->
      if (oauthParams.indexOf(param[0]) != -1)
        headerParams.push param

    header = "OAuth " + headerParams.map (param) ->
      return param[0] + '="' + param[1] + '"';
    .join ", "

    return header

  request: (method, params, callback) ->
    rdioBaseUrl = "http://api.rdio.com/1/"
    copy = {}
    if typeof params == "function"
      callback = params
      params = null

    if params
      for param of params
        copy[param] = params[param]

    copy.method = method

    auth = this.signRequest process.env.HUBOT_RDIO_KEY, process.env.HUBOT_RDIO_SECRET, rdioBaseUrl, copy
    parsedUrl = url.parse rdioBaseUrl
    content = qs.stringify copy

    req = http.request
      method: "POST"
      host: parsedUrl.host
      port: parsedUrl.port || "80"
      path: parsedUrl.pathname
      headers:
        "Authorization": auth
        "Content-Type": "application/x-www-form-urlencoded"
        "Content-Length": content.length.toString()
      (res) ->
        body = ""
        res.setEncoding "utf8"
        res.on "data", (chunk) ->
          body += chunk
        res.on "end", ->
          data = {}
          try
            data = JSON.parse body
          catch error
            data.status = 'error'
            data.message = body

          if data.status == "error"
            callback data.message
          else
            callback null, data.result

    req.on "error", (err) ->
      callback err

    req.end content
