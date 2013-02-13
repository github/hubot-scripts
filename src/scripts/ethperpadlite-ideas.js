// Description:
//   List and show ideas from an Etherpad Lite document: https://github.com/ether/etherpad-lite
//
// Dependencies:
//   None
//
// Configuration:
//   HUBOT_EL_IDEAS_URL  - The Etherpad Lite main URL, e.g. "http://my-etherpad.net/"
//   HUBOT_EL_IDEAS_KEY  - The Etherpad Lite API key (see https://github.com/ether/etherpad-lite/wiki/HTTP-API)
//   HUBOT_EL_IDEAS_PAD  - The Etherpad Lite pad ID, e.g. "my-pad"
//   HUBOT_EL_IDEAS_SEPARATOR  - (optional) A regex to find lines separating ideas, default: "^\s?(?:- )+\-?$"
//
// Commands:
//   hubot list ideas  - List 10 latest ideas
//   hubot list <count> ideas  - List <count> latest ideas
//   hubot list ideas with <filter>  - List all ideas matching <filter>
//   hubot show idea <idea_number>  - Show an idea
//   hubot show idea  - Show the last idea
//   hubot count ideas  - Show the ideas count
//
// Notes:
//   The pad needs to be structured by separators (defaults to "- - - - -").
//
// Author:
//   bpierre

var ERROR_MSG = 'Sorry, something is broken.';
var ERROR_ENV = 'HUBOT_EL_IDEAS_URL, HUBOT_EL_IDEAS_KEY and/or HUBOT_EL_IDEAS_PAD are not set.';

function parseIdeas(rawText, cb) {
  var data, text, ideas, separator;

  try {
    data = JSON.parse(rawText);
  } catch(err) {
    return cb(ERROR_MSG, err);
  }

  if (data.code !== 0 || !data.data || !data.data.text) {
    return cb(ERROR_MSG);
  }

  separator = process.env.HUBOT_EL_IDEAS_SEPARATOR;
  if (!separator) {
    separator = '^\s?(?:- )+\-?$';
  }

  text = data.data.text;
  ideas = text.split(new RegExp(separator, 'gm'));

  // Intro
  if (ideas) {
    ideas.splice(0, 1);
  }

  // Remove extra line breaks
  for (var i = ideas.length - 1; i >= 0; i--){
    ideas[i] = ideas[i].trim();
  }

  return cb(null, ideas);
}

function getIdeasList(ideas, cb) {
  var result = 'Select an idea with “hubot show idea <number>”:\n';
  var ideaNum;
  for (var i=0; i < ideas.length; i++) {
    ideaNum = (i + 1) + '';
    if (ideaNum.length == 1) ideaNum = '0' + ideaNum;
    result += '['+ ideaNum +'] ' + ideas[i].split('\n')[0] + '\n'; // First line
  }
  cb(null, result);
}

function getPadUrl() {
  var url = process.env.HUBOT_EL_IDEAS_URL;
  var key = process.env.HUBOT_EL_IDEAS_KEY;
  var pad = process.env.HUBOT_EL_IDEAS_PAD;
  if (!pad || !key || !pad) {
    return null;
  }
  if (url.charAt(url.length-1) !== '/') {
    url += '/';
  }
  return url + 'api/1/getText?apikey=' + key + '&padID=' + pad;
}

module.exports = function(robot) {

  function getIdeas(msg, cb) {
    var padUrl = getPadUrl();
    if (!padUrl) return cb(ERROR_ENV);
    msg.http(padUrl).get()(function(err, res, body){
      if (err || res.statusCode !== 200) return cb(ERROR_MSG);
      return parseIdeas(body, cb);
    });
  }

  robot.respond(/list\s+(all\s+|[0-9]+\s+)?ideas$/i, function(msg){
    var match = msg.match, count, textCount;

    textCount = match[1]? match[1].trim() : null;
    count = parseInt(textCount, 10);
    if (!count || count < 1) {
      count = 10;
    }

    getIdeas(msg, function(err, ideas){
      if (err) return msg.send(err);
      if (textCount !== 'all') {
        ideas.splice(count);
      }
      getIdeasList(ideas, function(err, text){
        msg.send(text);
      });
    });
  });

  robot.respond(/list\s+ideas\s+with\s+(.+$)/i, function(msg){
    var match = msg.match, filter;

    filter = match[1].trim();

    if (filter) {
      getIdeas(msg, function(err, ideas){
        if (err) return msg.send(err);
        getIdeasList(ideas, function(err, text){
          var list = text.split('\n');
          var newList = [];
          var re = new RegExp('^\[[0-9]+\].+(' + filter + ')', 'i');
          for (var i=0; i < list.length; i++) {
            if (re.test(list[i])) {
              newList.push(list[i]);
            }
          }
          msg.send(newList.join('\n'));
        });
      });
    }

  });

  robot.respond(/show\s+idea(\s+[0-9]+)?/i, function(msg){
    var match = msg.match, ideaNum;

    ideaNum = match[1]? match[1].trim() : null;
    ideaNum = parseInt(ideaNum, 10);
    if (!ideaNum || ideaNum < 1) {
      ideaNum = 1;
    }

    getIdeas(msg, function(err, ideas){
      if (err) return msg.send(err);
      if (ideas[ideaNum-1]) {
        msg.send(ideas[ideaNum-1]);
      } else {
        msg.send('The idea #'+ ideaNum +' does not exists');
      }
    });
  });

  robot.respond(/count\s+ideas/i, function(msg){
    getIdeas(msg, function(err, ideas){
      if (err) return msg.send(err);
      msg.send('Total ideas: ' + ideas.length + '.');
    });
  });
};
