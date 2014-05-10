# Description
#   Adds some Ingress commands to Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot AP until|to <N> - tells you the AP required for N level
#   hubot AP scale - prints the AP requirements for each level
#
# Notes:
#   Stay Enlightened!
#
# Author:
#   therealklanni

apToLv = [0, 0, 10000, 30000, 70000, 150000, 300000, 600000, 1200000]

module.exports = (robot) ->

	robot.respond /AP\s+(?:to|(?:un)?til)\s+L?(\d{1,2})/i, (msg) ->
		lv = msg.match[1]
		ap = apToLv[lv]
		msg.send "You need #{ap} AP to reach L#{lv}" if ap

	robot.respond /AP scale/i, (msg) ->
		msg.send " AP  =  LV\n"+
				 "       0  =  L1\n"+
				 "   10000  =  L2\n"+
				 "   30000  =  L3\n"+
				 "   70000  =  L4\n"+
				 "  150000  =  L5\n"+
				 "  300000  =  L6\n"+
				 "  600000  =  L7\n"+
				 " 1200000  =  L8\n"
