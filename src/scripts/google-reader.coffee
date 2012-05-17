# Subscribe to a feed in Google Reader, requires you set
# GOOGLE_USERNAME & GOOGLE_PASSWORD environment variables
#
# subscribe <domainname> - returns whether you've subscribed succesfully
#

module.exports = (robot) ->
  robot.hear /subscribe (.*)/i, (msg) ->
    domain = msg.match[1]
    getAuth msg, (auth) ->
      getToken msg, auth, (token) ->
        readerSubscribe msg, auth, token, domain

getAuth = (msg, cb) ->
  user = process.env.GOOGLE_USERNAME
  pass = process.env.GOOGLE_PASSWORD
  msg.http("https://www.google.com/accounts/ClientLogin")
    .query
      "service": "reader"
      "Email": user
      "Passwd": pass
    .get() (err, res, body) ->
      switch res.statusCode
        when 200
          cb body.match(/Auth=(.*)/)[1]
        when 403
          msg.send "You need to authenticate by setting the GOOGLE_USERNAME & GOOGLE_PASSWORD environment variables"
        else
          msg.send "Unable to get auth token, request returned with the status code: #{res.statusCode}"

getToken = (msg, auth, cb) ->
  msg.http('http://www.google.com/reader/api/0/token')
    .headers
      "Content-type": "application/x-www-form-urlencoded"
      "Authorization": "GoogleLogin auth=#{auth}"
    .get() (err, res, body) ->
      cb body
      
readerSubscribe = (msg, auth, token, domain) ->
  msg.http('http://www.google.com/reader/api/0/subscription/quickadd?client=scroll')
    .query
      "quickadd": domain
      "ac": 'subscribe'
      "T": token
    .headers
      "Content-type": "application/x-www-form-urlencoded; charset=UTF-8"
      "Content-Length": '0'
      "Authorization": "GoogleLogin auth=#{auth}"
    .post() (err, res, body) ->
      switch res.statusCode
        when 200
          msg.send "You are now subscribing to #{domain}"
        else
          msg.send "Unable to subscribe, request returned with the status code: #{res.statusCode}"
