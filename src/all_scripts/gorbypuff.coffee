# Description:
#   Gorbypuff Thunderstone
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   gorby - Display a picture of everyone's favorite flat-faced cat
#
# Author:
#   bradly

gorbies = [
  "http://24.media.tumblr.com/ded6b610059bac9203432ae1999fb439/tumblr_mix1ntHwN21rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/4eaabf5111c8444e68208adaa22c1c3a/tumblr_mewmgwxzZA1rt6kj7o1_1280.jpg",
  "http://24.media.tumblr.com/tumblr_me3ubx13ck1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_md5v15WAWI1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_mcbxaz9w7T1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_mbqotcRr4j1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_m99wdgHcNN1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_m94zjtC4sy1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_m8cju4aFeS1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m7a3unqPjr1rt6kj7o1_1280.jpg",
  "http://25.media.tumblr.com/tumblr_m6lev83Gak1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m6leq7NrsY1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m5vy9hfcTs1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m5g0bmkl601rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m5g0ab3EiH1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m51suk3wfS1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m50tx5IWhJ1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m4q48mVFXj1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m4hxmurzlL1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m4hxioPUln1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m4gqg94kSA1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m4c9ncT0LM1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m44m5g6m001rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m3v8keZVhR1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m3k8rvS6Uq1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m3k88eKJQf1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m3elppeyqa1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m3ekqyJ1iy1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m35xkkGbKO1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m305ndXRNH1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m2v55jdLgV1rt6kj7o1_500.png",
  "http://25.media.tumblr.com/tumblr_m2ro01h07O1rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m2olbl9Uw61rt6kj7o1_1280.png",
  "http://25.media.tumblr.com/tumblr_m2n4grjjN51rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m2j8mhAuMm1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m2i8utX5Qv1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m2i85ws1561rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m288synRIj1rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m21kfe7zir1rt6kj7o1_400.png",
  "http://25.media.tumblr.com/tumblr_m21hprOGO71rt6kj7o1_1280.png",
  "http://24.media.tumblr.com/tumblr_m21gc84uY21rt6kj7o1_1280.png"
]

module.exports = (robot) ->
  robot.hear /gorby|puff|thunderhorse/i, (msg) ->
    msg.send msg.random gorbies

