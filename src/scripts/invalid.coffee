# Description:
#   Display a random 'Your Argument is Invalid' image
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   invalid arg - supply an important counter-point to questionable arguments
#
# Author:
#   alexdean

invalids = [
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/007/517/my_hat_is_made_of_eggs.jpg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/019/719/NO5E65R2PRHVF7WAVBJNK7YHIYXLJEEJ.jpeg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/007/520/my_house_is_a_lego_mans_head.jpg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/007/502/this_baloney_is_smiling.jpg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/007/509/hits_children.jpg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/052/093/ihaveacrabhatof5_1_.jpg",
  "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/002/763/invalid.jpg",
  "http://yourargumentisinvalid.com/sites/default/files/imagecache/node/roflbot_23.jpg",
  "http://yourargumentisinvalid.com/sites/default/files/imagecache/node/revise.jpg",
  "http://yourargumentisinvalid.com/sites/default/files/imagecache/node/1238107641936.jpg",
  "http://yourargumentisinvalid.com/sites/default/files/imagecache/node/vader_mercy.jpg",
  "http://yourargumentisinvalid.com/sites/default/files/imagecache/node/dog.jpg",
  "http://imgbit.com/images/8b039724071243028981.jpg",
  "http://i11.photobucket.com/albums/a178/brandywine421/RPG-RAPTOR-SHARK-YOUR-ARGUMENT-IS-INVALID.jpg",
  "http://cdn.smosh.com/sites/default/files/bloguploads/argument-invalid-8.jpg",
  "http://forums.omgpop.com/attachments/photos/894d1293248050-your-argument-invalid-dexter01-jpg",
  "http://cdn.smosh.com/sites/default/files/bloguploads/argument-invalid-16.jpg",
  "http://epicfreebies.com/wp-content/uploads/2010/12/Your_Argument_is_invalid_bat.jpg",
  "http://i472.photobucket.com/albums/rr90/perfect668/my-hat-is-bread-your-argument-is-invalid.jpg",
  "http://images.icanhascheezburger.com/completestore/2009/3/31/128829834074968890.jpg",
  "http://images.icanhascheezburger.com/completestore/2009/1/29/128777402283840827.jpg"
]

module.exports = (robot) ->
  robot.hear /invalid ?arg/i, (msg) ->
    msg.send msg.random invalids
