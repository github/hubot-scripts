// Description:
//   Extends gratitude towards whoever was mentioned
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   thanks NAME - Extends gratitude towards whoever was mentioned
//
// Author:
//   junkafarian


var main = function(robot) {
  robot.hear(/thanks (.*)/i, function(msg) {
    var name = msg.match[1],
        vowels = ['a', 'e', 'i', 'o', 'u'],
        first_vowel = name.length,
        current_vowel,
        current_index;

    for (var i = 0; i < vowels.length; i++) {
      current_vowel = vowels[i];
      current_index = name.indexOf(current_vowel);
      if (current_index !== -1 && current_index < first_vowel) {
        first_vowel = current_index;
      }
    }

    if (first_vowel < vowels.length) {
      name = 'th' + name.substring(first_vowel);
      msg.send(name);
    }
  });
};

module.exports = main;
