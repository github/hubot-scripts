// Description:
//   Relays notifications coming from a Redis Pub/Sub channel.
//
// Dependencies:
//   "redis": "0.8.2"
//
// Configuration:
//   HUBOT_REDIS_NOTIFY_ROOMS - Rooms where notifications will be sent (optional, default: all rooms)
//   HUBOT_REDIS_NOTIFY_HOST - Redis host (optional, default: "127.0.0.1")
//   HUBOT_REDIS_NOTIFY_PORT - Redis port (optional, default: "6379")
//   HUBOT_REDIS_NOTIFY_PASSWORD - Redis password (optional)
//   HUBOT_REDIS_NOTIFY_CHANNEL - Redis channel (optional, default: "hubot notifications")
//
// Commands:
//   None
//
// Author:
//   bpierre

var redis = require('redis');

var rooms = process.env.HUBOT_REDIS_NOTIFY_ROOMS || null;
var redisHost = process.env.HUBOT_REDIS_NOTIFY_HOST || null;
var redisPort = process.env.HUBOT_REDIS_NOTIFY_PORT || null;
var redisPassword = process.env.HUBOT_REDIS_NOTIFY_PASSWORD || null;
var redisChannel = process.env.HUBOT_REDIS_NOTIFY_CHANNEL || 'hubot notifications';

// Ugly hack to get all hubot’s rooms,
// pending an official and cross-adapters API
function getAllRooms(robot) {
  // With the IRC adapter, rooms are located
  // in robot.adapter.bot.opt.channels
  var adapter = robot.adapter;
  if (adapter && adapter.bot && adapter.bot.opt
      && adapter.bot.opt.channels) {
    return adapter.bot.opt.channels;
  }
  // Search in env vars
  for (var i in process.env) {
    if (/^HUBOT_.+_ROOMS/i.exec(i) !== null) {
      return process.env[i].split(',');
    }
  }
}

module.exports = function(robot) {
  var client, allRooms;

  if (rooms) {
    allRooms = rooms.split(',');
  } else {
    allRooms = getAllRooms(robot);
  }

  client = redis.createClient(redisHost, redisPort);
  if (redisPassword) {
    client.auth(redisPassword);
  }

  client.on('message', function(channel, message) {
    for (var i=0; i < allRooms.length; i++) {
      robot.messageRoom(allRooms[i], message);
    }
  });

  client.subscribe(redisChannel);
};
