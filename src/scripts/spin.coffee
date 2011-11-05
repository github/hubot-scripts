# Spin given common spintax formatted text
#
# - supports nested sets
# - supports multiline input for robot
#
# spin me <query> - Returns a spun version of the input.
#
# Example: spin me This is {my nested {spintax|spuntext} formatted string|your nested {spintax|spuntext} formatted string} test.
# 
# TODO: different syntaxes like '{', '|', '}' OR '[spin]', '~', '[/spin]'
#
split_str = '|'
replace_regexp_str = /[{}]/gi
match_regexp_str = /{[^{}]+?}/gi

spin = (txt) ->
	if txt
		txt = capture(txt) while txt.match(match_regexp_str)
	txt

capture = (txt) ->
	match = txt.match(match_regexp_str)
	if (match[0])
		words = match[0].split(split_str)
		replace = words[Math.floor(Math.random()*words.length)].replace(replace_regexp_str, '')
		txt = txt.replace(match[0], replace)
	txt

module.exports = (robot) ->
  robot.respond /spin me ([\s\S]*)/i, (msg) ->
    output = spin(msg.match[0])
    msg.send output