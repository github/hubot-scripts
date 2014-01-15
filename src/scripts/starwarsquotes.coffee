# Description:
#   There's nothing like a random Star Wars quote to give you hope
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot use the force - Get a random quote from one of the six Star Wars films.
#   hubot give me hope {charactername} - Get a random Star Wars quote from that character
#
#
# Author:
#   brownsm


module.exports = (robot) ->
    # waits for the string "use the force" to occur
    robot.respond /use the force/i, (msg) ->
        # Configures the url of a remote server
        msg.http('http://starwarsapi.herokuapp.com/random.json')
            # and makes an http get call
            .get() (error, response, body) ->
                results = JSON.parse body
                line = ""
                if error 
                    line = "An error occured. That's no moon! It's a space station."
                else 
                    movieline = results[0].character.displayname + ": '" + results[0].line + "' -- " + results[0].episode.fullname
                    if results[0].error == ""
                        line = movieline
                    else
                        line = results[0].error + movieline

                msg.send line

    robot.respond /give me hope\s*(.*)?$/i, (msg) ->
        # Configures the url of a remote server
        ch = msg.match[1]
        msg.http('http://starwarsapi.herokuapp.com/random.json?character='+ escape(ch))
            # and makes an http get call
            .get() (error, response, body) ->
                results = JSON.parse body
                line = ""
                if error
                    line = "An error occured. That's no moon! It's a space station."
                else
                    movieline = results[0].character.displayname + ": '" + results[0].line + "' -- " + results[0].episode.fullname
                    if results[0].error == ""
                        line = movieline
                    else
                        line = results[0].error + movieline

                msg.send line
