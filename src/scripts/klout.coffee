# Description
#   Reports Klout score for a twitter handle.  If that person is part of the competitors
#   list, the players whose score is greater will be reported. Default competitors are @attachmentsme
#   
# Dependencies:
#   You'll have to put in your own klout api key. Signup for one at http://klout.com/s/developers/home
#
# Configuration:
#   The competitors list's name and id parameters can be modified to include 10 members. 
#   More than 10 will potentially cause trigger the per second rate limit with klout.
#     <name> is a twitter name
#     <id> is a klout id, not a twitter id. Use the interactive console to get this. http://developer.klout.com/io-docs 
#
# Commands:
#   klout <twitter name without @>
#
# Author:
#   l_kang


klout_api_key = "your_klout_api_key"

module.exports = (robot) -> 
    robot.respond /.*(klout) [@]?(.+)$/i, (msg) ->
        if klout_api_key == "your_klout_api_key"
            msg.send "I wont report any scores until you get your own Klout api key"
            return
            
        name = msg.match[2]

        done = checkList name, msg, (result)->
            msg.send result
        return if done

        getKloutScoreByName name, msg, (p)->
            if p.id == 0
                msg.send "Sorry, I cant figure out who @#{name} is"
            else
                msg.send "Klout for @#{p.name} is #{p.score}"

competitors = [{ 
    "name": "l_kang"
    "id": "1065822"
    "score": 0
},
{ 
    "name": "danreedx86"
    "id": "37154701691656080"
    "score": 0
},
{
    "name": "benjamincoe"
    "id": "85568398087782958"
    "score": 0
},
{
    "name": "jesse_miller"
    "id": "529139"
    "score": 0
},
{
    "name": "joshkowaleski"
    "id": "524476"
    "score": 0
},
{
    "name": "rissem"
    "id": "41376826341708013"
    "score": 0
}]

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
            tag = "#{leaderNames.join(',')} are ahead though."
        callback "@#{player.name}'s Klout is #{player.score}. #{tag}"
    true

getKloutScores = ( hashlist, index, msg, doneCallback )->
    return if hashlist.length == index
    thisPlayer = hashlist[index]
    url = "http://api.klout.com/v2/user.json/#{thisPlayer.id}/score?key=#{klout_api_key}"
    msg.http(url)
        .get() (error, response, body)->
            scoreRecord = JSON.parse( body )
            # console.log "scoreRecord: "
            # console.log scoreRecord
            thisPlayer.score = scoreRecord.score
            if hashlist.length == index+1
                doneCallback( thisPlayer )
            else
                getKloutScores( hashlist, index+1, msg, doneCallback )

getKloutScoreByName = (name, msg, callback)->
    url = "http://api.klout.com/v2/identity.json/twitter?key=#{klout_api_key}&screenName=#{name}"
    msg.http(url)
        .get() (error, response, body)->
            player = [{
                name:  name
                id:    0
                score: 0
            }]
            if error || response.statusCode != 200 || body == undefined
                callback( player[0] )
                return
            kloutIdRec = JSON.parse( body )
            player.id = kloutIdRec.id
            getKloutScores player, 0, msg, callback

        
