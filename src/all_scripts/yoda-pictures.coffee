# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   yoda pic - Returns a random yoda picture
#
# Author:
#   vquaiato

module.exports = (robot) ->
	robot.hear /^yoda pic$/i, (msg) ->
		images = ["http://upload.wikimedia.org/wikipedia/pt/thumb/4/45/Yoda.jpg/200px-Yoda.jpg",
			"http://images.wikia.com/pt.starwars/images/c/c4/Yoda2.jpg",
			"http://images.wikia.com/starwars/images/e/e0/Yoda_SWSB.jpg",
			"http://2.bp.blogspot.com/_iL70zHv_XC8/TK2_lCOuK_I/AAAAAAAAEzA/2l65R-O2mKM/s1600/yoda5.jpg",
			"http://blogdocko.com.br/wp-content/uploads/2011/02/yoda.jpg",
			"http://pensandoavida.com/blog/wp-content/uploads/2010/10/master-yoda12.jpg",
			"http://1.bp.blogspot.com/--8Oa8ifmmNU/TmF9RLf_JEI/AAAAAAAAALg/l2mU7lTCkSk/s1600/yoda.jpg",
			"http://4.bp.blogspot.com/_iL70zHv_XC8/TK2_C3WVHDI/AAAAAAAAEyw/tlW4-z1VQZw/s1600/yoda1.jpg",
			"http://images.wikia.com/es.starwars/images/4/45/Yoda.jpg",
			"http://3.bp.blogspot.com/_uuV3k3ETpe8/TEfCCoWDtDI/AAAAAAAAAGY/i99cufINjkU/s1600/cg%2Byoda.jpg",
			"http://wikiwars.wikispaces.com/file/view/Yoda.jpg/30299272/Yoda.jpg"]
		msg.send msg.random images
		
