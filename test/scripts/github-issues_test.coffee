assert = require 'assert'
_      = require("underscore")

is_defined = (x)  -> x?
one_of     = (xs) -> xs[Math.floor Math.random() * xs.length]
maybe      = (x)  -> one_of [x, undefined]

# Get criteria for random ask string.
random_criteria = ->
  me: (maybe 'me'),
  limit: (maybe one_of [1..100]),
  assignee: (maybe one_of ["my", "@fred", "julia_roberts"]),
  label: (maybe one_of ["ui", "show-stopper"]),
  repo: (maybe one_of ["github/hubot", "hubot-scripts", "janky"]),
  query: (maybe one_of ["firefox", "Internet Explorer"])

# Create the string for the robot to receive from criteria. We create this
# string from randomized criteria, then parse the string and compare the
# results to the randomized criteria to test the `parse_criteria` function.
criteria_to_message = ({me, limit, assignee, label, repo, query}) -> [
  'show', me,
  limit, 'of' if limit? and assignee?,
  (if assignee? and assignee isnt "my" then "#{assignee}'s" else assignee),
  label,
  'issues',
  'for' if repo?, repo,
  'about' if query?, query
].filter(is_defined).join ' '

# Test for the parse_criteria function.
#
# The function to test must be passed because it cannot be exported due to
# Hubot's export expectations.
module.exports.test = (parse_criteria) ->
  # QuickCheck-inspired randomized test cases.
  _.times 100, ->
    criteria_expected = random_criteria()
    assert.deepEqual criteria_expected, (parse_criteria criteria_to_message criteria_expected)
