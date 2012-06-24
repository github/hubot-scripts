// Description:
//   xmas detector script
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot is it xmas ?  - returns whether is it christmas or not
//   hubot is it christmas ?  - returns whether is it christmas or not
//
// Author:
//   Johnny G. Halife

module.exports = function(robot) {
	robot.respond(/is it (xmas|christmas)\s?\?/i, function(msg){
		var today = new Date();

		msg.reply(today.getDate() == 25 && (today.getMonth() + 1) == 12 ? "YES" : "NO");
	});
}
