# Domain availability via DNSimple, requires you set
# DNSIMPLE_USERNAME & DNSIMPLE_PASSWORD environment variables
#
# check domain <domainname> - returns whether a domain is available
#

module.exports = (robot) ->
  robot.hear /check domain (.*)/i, (msg) ->
    domain = escape(msg.match[1])
    user = process.env.DNSIMPLE_USERNAME
    pass = process.env.DNSIMPLE_PASSWORD
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64');
    msg.http("https://dnsimple.com/domains/#{domain}/check")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send "Sorry, #{domain} is not available."
          when 404
            msg.send "Cybersquat that shit!"
          when 401
            msg.send "You need to authenticate by setting the DNSIMPLE_USERNAME & DNSIMPLE_PASSWORD environment variables"
          else
            msg.send "Unable to process your request and we're not sure why :("