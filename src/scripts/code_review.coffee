module.exports = (robot) ->
    robot.respond /ping/i, (res) ->
        res.send 'pong'
