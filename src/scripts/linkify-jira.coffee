module.exports = (robot) ->
    robot.hear /(?:\W|^)((HD|NEW|FOO)-\d+)(\+)?(?:(?=\W)|$)/, (msg) ->

        # Link to the associated bug
        issueId = msg.match[1]
        updatedMsg = msg.message.text.replace("#{issueId}", "[#{issueId}](https://salsify.atlassian.net/browse/{issueId}"

       # Call edit.  (bot will have to have the permission to do this)
        robot.adapter.callMethod('updateMessage',
            _id: msg.message.id
            rid: msg.message.room
            msg: updatedMsg
        ).catch (err) ->
           console.error err
