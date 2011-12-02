// Random meme from 9gag (9gag.com)
//
// 9gag  -	returns a random meme

var memeDomain = "http://9gag.com";

module.exports = function(robot) {
	robot.hear(/9gag/i, function(msg){
		msg.http(memeDomain + "/random").get()(function(e, r, b) {
			msg.send(memeDomain + r.headers['location']);
		});
	});
};
