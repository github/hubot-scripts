//Description 
//	A script for integration with 7geese. Automatically publishes recent recognitions and allows users to call for most recent and total number of recognitions.
//
//Dependencies:
//	https
//
//Configuration:
//	Set your oauth_consumer_key as a environmental variable in Heroku
//	Format is heroku config:set GEESE_CONSUMER_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//
//Commands:
//	hubot 7geese total - Number of total recognitions and a link to the recognition board
//	hubot 7geese newest - Information about the most recent recognition and a link to it
//
//Notes:
//	Currently messages the #general room when there is a new recognition given
//	Planned integration of a notice for new checkins, pending new API release from 7geese
//	Please let me know of any glitches, issues
//
//Author:
//	William R. Fry, First Round Capital											   




module.exports = function(robot) {

	function totalMe(msg,cb) {	
		var consumer_key = process.env.GEESE_CONSUMER_KEY;
		var my_path = '/api/v1/recognitionbadges/?oauth_consumer_key=' + consumer_key;
		var https = require('https');
		var details = {
		    host: 'www.7geese.com',
		    port: 443,
		    path: my_path,
		    method: 'GET',
		    headers: {
		        'Content-Type': 'application/json'
	    	}
		};
	    https.get(details, function(res) {

			var bodyChunks = [];

			res.on('data', function(chunk) {

				bodyChunks.push(chunk);

			}).on('end', function() {

				var body = Buffer.concat(bodyChunks);
				var cleanedBody = JSON.parse(body);

				message = 'There have been : ' + cleanedBody.meta.total_count + " recognitions!\nCheck them out here: https://www.7geese.com/recognitioncenter/";
				
				return cb (null, message);
			});
		});
	}

	function newestMe(msg,cb) {
		var consumer_key = process.env.GEESE_CONSUMER_KEY;
		var my_path = '/api/v1/recognitionbadges/?oauth_consumer_key=' + consumer_key;
		var https = require('https');
		var details = {
		    host: 'www.7geese.com',
		    port: 443,
		    path: my_path,
		    method: 'GET',
		    headers: {
		        'Content-Type': 'application/json'
	    	}
		};
	    https.get(details, function(res) {

			var bodyChunks = [];
			
			res.on('data', function(chunk) {

				bodyChunks.push(chunk);

			}).on('end', function() {

				var body = Buffer.concat(bodyChunks);
				var cleanedBody = JSON.parse(body);
				var recognizer = cleanedBody.objects[0].sender.user.first_name + " " + cleanedBody.objects[0].sender.user.last_name;
				var recognized = cleanedBody.objects[0].recipient.user.first_name + " " + cleanedBody.objects[0].recipient.user.last_name;
				var newReconigition = cleanedBody.objects[0].message;
				
				message =  recognizer + " recognized " + recognized + " recently for " + cleanedBody.objects[0].badge.name + "!\nCheck it out here: https://www.7geese.com/recognitioncenter/#badge/" + cleanedBody.objects[0].badge.id;
				
				return cb (null, message);
			});
		});
	}

	function checkMe() {
		var consumer_key = process.env.GEESE_CONSUMER_KEY;
		var my_path = '/api/v1/recognitionbadges/?oauth_consumer_key=' + consumer_key;
		var https = require('https');
		var details = {
		    host: 'www.7geese.com',
		    port: 443,
		    path: my_path,
		    method: 'GET',
		    headers: {
		        'Content-Type': 'application/json'
	    	}
		};
		https.get(details, function(res) {

			var bodyChunks = [];

			res.on('data', function(chunk) {

				bodyChunks.push(chunk);

			}).on('end', function() {

				var body = Buffer.concat(bodyChunks);
				var cleanedBody = JSON.parse(body);
				list_of_indexes = [];

				for (var i=1; i < 3; i++) {

					var createdDate = new Date(cleanedBody.objects[i-1].created);
					var currentDate = new Date();
					var difference = currentDate - createdDate;

					if (difference < 60000){

						list_of_indexes.push(i);
						var recognizer = cleanedBody.objects[i-1].sender.user.first_name + " " + cleanedBody.objects[i-1].sender.user.last_name;
						var recognized = cleanedBody.objects[i-1].recipient.user.first_name + " " + cleanedBody.objects[i-1].recipient.user.last_name;
						var newReconigition = cleanedBody.objects[i-1].message;

						message =  "Congrats " + recognized + "! " + recognizer + " just recognized you for " + cleanedBody.objects[i-1].badge.name + "! Here\'s what " + cleanedBody.objects[i-1].sender.user.first_name + " had to say:\n" + cleanedBody.objects[i-1].message + "\nCheck it out here: https://www.7geese.com/recognitioncenter/#badge/" + cleanedBody.objects[i-1].badge.id;
						
						robot.messageRoom('#general',message);

					}
				}
			});
		});
	}

	setInterval(checkMe,60000);

	robot.respond(/7geese\s+total/i, function(msg){
		totalMe(msg, function(err,answer){
			if (err) return msg.send(err);
			msg.send(answer);
		});
	});

	robot.respond(/7geese\s+newest/i, function (msg){
		newestMe(msg, function(err,answer){
			if (err) return msg.send(err);
			msg.send(answer);
		});
	});
}