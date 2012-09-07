# Description
#   Reports Klout score for a twitter handle.  The players in the competitors list
#   whose score is greater will be reported. The last 9 unique requested names
#   are kept in the competitors list. More than that will trigger the klout api's
#   per second rate limit.
#   
# Dependencies:
#   A klout api key is needed. Signup for one at http://klout.com/s/developers/home
#
# Configuration:
#   HUBOT_KLOUT_API_KEY must be set in the environment. 
#   The competitors list is automatically created and includes the last 9 valid twitter handles. 
#
# Commands:
#   hubot klout <twitter name with or without @> - report klout score for twitter handle, and compare to competitors
#
# Author:
#   l_kang


competitors = []

klout_api_key = () ->
    return process.env.HUBOT_KLOUT_API_KEY
    
module.exports = (robot) -> 
    robot.respond /.*(klout) [@]?(.+)$/i, (msg) ->
        unless klout_api_key()
            msg.send "I wont report any scores until your environment HUBOT_KLOUT_API_KEY is set"
            return
        name = msg.match[2]

        player = p for p in competitors when p.name == name
        if player == undefined
            getKloutScoreByName name, msg, (result)->
                msg.send result
        else
            checkList name, msg, (result)->
                msg.send result

checkList = (pname, msg, callback)->
    player = p for p in competitors when p.name == pname
    return false if player == undefined
    getKloutScores competitors, 0, msg, ()->
        leaderNames = for p in competitors when p.score > player.score
            " @#{p.name}"
        if leaderNames.length == 0
            tag = "Nobody is ahead of @#{player.name}!"
        else if leaderNames.length == 1
            tag = "#{leaderNames.join(',')} is ahead though."
        else
            tag = "#{leaderNames.join(',')} are ahead though. "
        callback "@#{player.name}'s Klout is #{player.score}. #{tag}"

getKloutScores = ( hashlist, index, msg, doneCallback )->
    return if hashlist.length == index
    thisPlayer = hashlist[index]
    url = "http://api.klout.com/v2/user.json/#{thisPlayer.id}/score?key=#{klout_api_key()}"
    msg.http(url)
        .get() (error, response, body)->
            scoreRecord = JSON.parse( body )
            thisPlayer.score = scoreRecord.score
            if hashlist.length == index+1
                doneCallback( thisPlayer )
            else
                getKloutScores( hashlist, index+1, msg, doneCallback )

getKloutScoreByName = (name, msg, callback)->
    url = "http://api.klout.com/v2/identity.json/twitter?key=#{klout_api_key()}&screenName=#{name}"
    msg.http(url)
        .get() (error, response, body)->
            player = {
                name:  name
                id:    0
                score: 0
            }
            if error || response.statusCode != 200 || body == undefined
                callback( "Sorry, I cant figure out who @#{name} is" )
                return
            kloutIdRec = JSON.parse( body )
            player.id = kloutIdRec.id
            # remove player if he exists, add player to the end and trim size.
            nc = competitors[..]
            competitors = []
            competitors.push(p) for p in nc when p.name != name
            competitors.push(player)
            competitors.shift() if competitors.length > 9
            checkList name, msg, callback
            
        
