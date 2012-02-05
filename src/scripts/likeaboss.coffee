# LIKE A BOSS
#

images = [
  "http://s3.amazonaws.com/kym-assets/photos/images/original/000/114/151/14185212UtNF3Va6.gif?1302832919",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/110/885/boss.jpg",
  "http://verydemotivational.files.wordpress.com/2011/06/demotivational-posters-like-a-boss.jpg",
  "http://assets.head-fi.org/b/b3/b3ba6b88_funny-facebook-fails-like-a-boss3.jpg",
  "http://img.anongallery.org/img/6/0/like-a-boss.jpg",
  "http://www.18seven.com/wp-content/uploads/IMG_1745.jpg",
  "http://www.demotivers.com/uploads/2011_02/02/7733_1292_500_Like-A-Boss.jpg",
  "http://images.cheezburger.com/completestore/2011/2/20/a4ea536d-4b21-4517-b498-a3491437d224.jpg",
  "http://funcorner.eu/wp-content/uploads/2011/03/like_a_boss.jpg",
  "http://www.japemonster.com/wp-content/uploads/2011/08/demotivational-posters-like-a-boss.jpg",
  ]

module.exports = (robot) ->
  robot.hear /like a boss/i, (msg) ->
    msg.send msg.random images