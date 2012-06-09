# Description:
#   Display a picture of Jeremy Lin if anyone invokes "linsanity" or
#   says "linspire". Cause Lin is Linspiring!
#
# Dependecies:
#   None
#
# Configuration:
#   None
#
# Commands:
# 
# Author:
#   zackyap

images = [
  "http://i.i.com.com/cnwk.1d/i/tim/2012/02/16/Jeremy_Lin_139046190_620x350.jpg"
  "http://a.abcnews.com/images/Business/gty_jeremy_lin_ll_120217_wg.jpg"
  "http://i.usatoday.net/sports/_photos/2012/02/19/Knicks-guard-Jeremy-Lin-wears-faith-on-wrist-RH11428S-x-large.jpg"
  "http://thegospelcoalition.org/blogs/tgc/files/2012/02/Jeremy-Lin.jpg"
  "http://www.pennystockicons.com/wp-content/plugins/rss-poster/cache/21952_jeremy-lin.gi.top.jpg"
  "http://indiancountrytodaymedianetwork.com/wp-content/uploads/2012/02/JeremyLin-615x599.jpg"
  "http://www.chinasmack.com/wp-content/uploads/2012/02/jeremy-lin-new-york-knicks-01.jpg"
  "http://www.hollywoodreporter.com/sites/default/files/2012/02/jeremy_lin_3.jpg"
  "http://www.wtsp.com/images/640/360/2/assetpool/images/120217125112_jeremy-lin.jpg"
  "http://resources0.news.com.au/images/2012/02/20/1226275/331552-jeremy-lin.jpg"
  "http://www.splicetoday.com/vault/posts/0003/2771/Five-things-you-didnt-know-about-Jeremy-Lin-T310FDNC-x-large_large.jpg?1329407309"
  "http://pacejmiller.com/wp-content/uploads/2012/02/021412_jeremy_lin_400.jpg"

]

module.exports = (robot) ->
  robot.hear /(linsanity|linspire)/i, (msg) ->
    msg.send msg.random images
