# Description:
#   Get last result from football team
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FOOTBALL_ACCOUNT_KEY -> http://api.football-data.org/register
#
# Commands:
#   hubot get me last result <team> - Displays last result of football team
#   hubot get me next match <team> - Displays date of next match
#
# Notes:
#   More teams at http://api.football-data.org/alpha/teams/{id}
#
# Author:
#   ccramiro

teams =
  # Bundesliga
  koln: 1
  blv: 3 # Bayer Leverkusen
  bvb: 4 # Borussia Dortmund
  bmn: 5, bfc: 5 # Bayern Muenchen
  s04: 6 # Schalke 04
  wob: 11 # Wolfsburg
  bmg: 18 # Bor Moenchengladbach
  dus: 24 # Fortune Duesseldorf
  # Premier League
  afc: 57, arsenal: 57 # Arsenal
  avfc: 58 # Aston Villa
  cfc: 61 # Chelsea
  efc: 62 # Everton
  fulham: 63 
  liv: 64, lfc: 64 # Liverpool
  manc: 65, mcfc: 65 # Manchester City
  mufc: 66, manu: 66 # Manchester United
  thfc: 73 # Tottenham
  # Primera Division
  bil: 77, ath: 77 # Athletic Bilbao
  atm: 78 # Atletico Madrid
  fcb: 81 # Barcelona
  fcg: 82 # Getafe
  mal: 84 # Málaga
  rma: 86, mad: 86 # Real Madrid
  rss: 92 # Real Sociedad
  vcf: 94 # Villareal
  val: 95 # Valencia


footballApiKey = process.env.HUBOT_FOOTBALL_ACCOUNT_KEY
unless footballApiKey
  throw "You must enter your HUBOT_FOOTBALL_ACCOUNT_KEY in your environment variables"

module.exports = (robot) ->
  robot.respond /(get )?(me )?(last )?result (.*)/i, (msg) ->
    team = escape( msg.match[4] )
    url = 'http://api.football-data.org/alpha/teams/' + teams[team] + '/fixtures'
    msg.http( url )
      .headers( 'X-Auth-Token': footballApiKey, Accept: 'application/json' )
      .get() (err, res, body) ->
        json = JSON.parse(body)
        first = json.fixtures
        unless first
          msg.send( team + '? No idea what is that, sorry man' )
          return
        for key,value of first
          if value.status == 'TIMED'
            break
          else
            last = value
        msg.send( last.homeTeamName + ' ' + last.result.goalsHomeTeam + ' - ' + last.result.goalsAwayTeam + ' ' + last.awayTeamName )

  robot.respond /(get )?(me )?(next )?match (.*)/i, (msg) ->
    team = escape( msg.match[4] )
    url = 'http://api.football-data.org/alpha/teams/' + teams[team] + '/fixtures'
    msg.http( url )
      .headers( 'X-Auth-Token': footballApiKey, Accept: 'application/json' )
      .get() (err, res, body) ->
        json = JSON.parse(body)
        first = json.fixtures
        unless first
          msg.send( team + '? No idea what is that, sorry man' )
          return
        for key,value of first
          last = value
          if value.status == 'TIMED'
            break
        msg.send( last.homeTeamName + ' - ' + last.awayTeamName + ' will be on ' + last.date )
