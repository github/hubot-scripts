# Description:
#   See the schedule of Caltrain
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_CALTRAIN_HOME_STATION
#
# Commands:
#   hubot next (cal)train to <station> - get the next train to <station>
#   hubot (cal)train to <station> - get all trains to <station>
#   hubot next (cal)train from <station> to <station> - get the next train from <station> to <station>
#   hubot (cal)trains from <station> to <station> - get train from <station> to <station>
#
# Author:
#   yangsu


STATIONS = [
  name: 'San Francisco'
  milepost: 0.2
  latitude: 37.77568
  longitude: -122.39572
,
  name: '22nd Street'
  milepost: 1.9
  latitude: 37.75735
  longitude: -122.39302
,
  name: 'Bayshore'
  milepost: 5.2
  latitude: 37.70813
  longitude: -122.40202
,
  name: 'So. San Francisco'
  milepost: 9.3
  latitude: 37.65560
  longitude: -122.40504
,
  name: 'San Bruno'
  milepost: 11.6
  latitude: 37.62138
  longitude: -122.40663
,
  name: 'Millbrae'
  milepost: 13.7
  latitude: 37.60052
  longitude: -122.38756
,
  name: 'Broadway'
  milepost: 15.2
  latitude: 37.58723
  longitude: -122.36276
,
  name: 'Burlingame'
  milepost: 16.3
  latitude: 37.57970
  longitude: -122.34519
,
  name: 'San Mateo'
  milepost: 17.9
  latitude: 37.56878
  longitude: -122.32475
,
  name: 'Hayward Park'
  milepost: 19.1
  latitude: 37.55386
  longitude: -122.30987
,
  name: 'Hillsdale'
  milepost: 20.3
  latitude: 37.53895
  longitude: -122.29855
,
  name: 'Belmont'
  milepost: 21.9
  latitude: 37.52143
  longitude: -122.27679
,
  name: 'San Carlos'
  milepost: 23.2
  latitude: 37.50857
  longitude: -122.26055
,
  name: 'Redwood City'
  milepost: 25.4
  latitude: 37.48642
  longitude: -122.23206
,
  name: 'Atherton'
  milepost: 27.8
  latitude: 37.46456
  longitude: -122.19823
,
  name: 'Menlo Park'
  milepost: 28.9
  latitude: 37.45499
  longitude: -122.18314
,
  name: 'Palo Alto'
  milepost: 30.1
  latitude: 37.44407
  longitude: -122.16516
,
  name: 'California Ave'
  milepost: 31.8
  latitude: 37.42934
  longitude: -122.14172
,
  name: 'San Antonio'
  milepost: 34.1
  latitude: 37.40775
  longitude: -122.10811
,
  name: 'Mountain View'
  milepost: 36.1
  latitude: 37.39454
  longitude: -122.07644
,
  name: 'Sunnyvale'
  milepost: 38.8
  latitude: 37.37873
  longitude: -122.03231
,
  name: 'Lawrence'
  milepost: 40.8
  latitude: 37.37041
  longitude: -121.99746
,
  name: 'Santa Clara'
  milepost: 44.7
  latitude: 37.35343
  longitude: -121.93653
,
  name: 'College Park'
  milepost: 46.3
  latitude: 37.34253
  longitude: -121.91513
,
  name: 'San Jose'
  milepost: 47.5
  latitude: 37.33030
  longitude: -121.90314
,
  name: 'Tamien'
  milepost: 49.1
  latitude: 37.31163
  longitude: -121.88390
,
  name: 'Capitol'
  milepost: 52.4
  latitude: 37.28406
  longitude: -121.84197
,
  name: 'Blossom Hill'
  milepost: 55.7
  latitude: 37.25241
  longitude: -121.79765
,
  name: 'Morgan Hill'
  milepost: 67.5
  latitude: 37.12921
  longitude: -121.65019
,
  name: 'San Martin'
  milepost: 71.2
  latitude: 37.08590
  longitude: -121.61047
,
  name: 'Gilroy'
  milepost: 77.4
  latitude: 37.00421
  longitude: -121.56653
]

SCHEDULES = {}

SCHEDULES['weekday'] =
  101: [['San Jose', '04:30'], ['Santa Clara', '04:35'], ['Lawrence', '04:40'], ['Sunnyvale', '04:44'], ['Mountain View', '04:49'], ['San Antonio', '04:53'], ['California Ave', '04:57'], ['Palo Alto', '05:01'], ['Menlo Park', '05:04'], ['Redwood City', '05:09'], ['San Carlos', '05:13'], ['Belmont', '05:16'], ['Hillsdale', '05:19'], ['Hayward Park', '05:22'], ['San Mateo', '05:25'], ['Burlingame', '05:28'], ['Millbrae', '05:33'], ['San Bruno', '05:37'], ['So. San Francisco', '05:41'], ['Bayshore', '05:47'], ['22nd Street', '05:52'], ['San Francisco', '06:01']]
  103: [['Tamien', '04:58'], ['San Jose', '05:05'], ['Santa Clara', '05:10'], ['Lawrence', '05:15'], ['Sunnyvale', '05:19'], ['Mountain View', '05:24'], ['San Antonio', '05:28'], ['California Ave', '05:32'], ['Palo Alto', '05:36'], ['Menlo Park', '05:39'], ['Redwood City', '05:44'], ['San Carlos', '05:48'], ['Belmont', '05:51'], ['Hillsdale', '05:54'], ['Hayward Park', '05:57'], ['San Mateo', '06:00'], ['Burlingame', '06:03'], ['Millbrae', '06:08'], ['San Bruno', '06:12'], ['So. San Francisco', '06:16'], ['Bayshore', '06:22'], ['22nd Street', '06:27'], ['San Francisco', '06:36']]
  305: [['San Jose', '05:45'], ['Mountain View', '05:57'], ['Palo Alto', '06:05'], ['Hillsdale', '06:16'], ['Millbrae', '06:24'], ['San Francisco', '06:42']]
  207: [['Tamien', '05:50'], ['San Jose', '05:57'], ['Santa Clara', '06:02'], ['Lawrence', '06:12'], ['Sunnyvale', '06:18'], ['Mountain View', '06:23'], ['San Antonio', '06:27'], ['California Ave', '06:31'], ['Palo Alto', '06:36'], ['Menlo Park', '06:39'], ['Redwood City', '06:45'], ['Hillsdale', '06:51'], ['Millbrae', '06:59'], ['So. San Francisco', '07:05'], ['San Francisco', '07:19']]
  309: [['Tamien', '05:56'], ['San Jose', '06:03'], ['Sunnyvale', '06:13'], ['Palo Alto', '06:23'], ['Redwood City', '06:30'], ['San Mateo', '06:39'], ['Millbrae', '06:45'], ['San Francisco', '07:02']]
  211: [['San Jose', '06:20'], ['Santa Clara', '06:25'], ['Sunnyvale', '06:32'], ['Mountain View', '06:37'], ['Menlo Park', '06:45'], ['Redwood City', '06:51'], ['San Carlos', '06:55'], ['Belmont', '06:58'], ['Hillsdale', '07:02'], ['Hayward Park', '07:05'], ['San Mateo', '07:08'], ['Burlingame', '07:11'], ['Millbrae', '07:17'], ['San Bruno', '07:21'], ['So. San Francisco', '07:25'], ['Bayshore', '07:33'], ['22nd Street', '07:40'], ['San Francisco', '07:48']]
  313: [['San Jose', '06:45'], ['Mountain View', '06:57'], ['Palo Alto', '07:05'], ['Hillsdale', '07:16'], ['Millbrae', '07:24'], ['San Francisco', '07:42']]
  215: [['San Jose', '06:50'], ['Sunnyvale', '07:00'], ['Mountain View', '07:05'], ['California Ave', '07:11'], ['Palo Alto', '07:16'], ['San Carlos', '07:24'], ['Hillsdale', '07:28'], ['San Mateo', '07:32'], ['Burlingame', '07:35'], ['San Bruno', '07:42'], ['San Francisco', '07:57']]
  217: [['Gilroy', '06:07'], ['San Martin', '06:16'], ['Morgan Hill', '06:22'], ['Blossom Hill', '06:35'], ['Capitol', '06:41'], ['Tamien', '06:49'], ['San Jose', '06:57'], ['Santa Clara', '07:02'], ['Lawrence', '07:12'], ['Sunnyvale', '07:18'], ['Mountain View', '07:23'], ['San Antonio', '07:27'], ['California Ave', '07:31'], ['Palo Alto', '07:36'], ['Menlo Park', '07:39'], ['Redwood City', '07:45'], ['Hillsdale', '07:51'], ['Millbrae', '07:59'], ['So. San Francisco', '08:05'], ['San Francisco', '08:19']]
  319: [['Tamien', '06:56'], ['San Jose', '07:03'], ['Sunnyvale', '07:13'], ['Palo Alto', '07:23'], ['Redwood City', '07:30'], ['San Mateo', '07:39'], ['Millbrae', '07:45'], ['San Francisco', '08:02']]
  221: [['Gilroy', '06:28'], ['San Martin', '06:37'], ['Morgan Hill', '06:43'], ['Blossom Hill', '06:56'], ['Capitol', '07:02'], ['Tamien', '07:10'], ['San Jose', '07:18'], ['Santa Clara', '07:23'], ['Lawrence', '07:28'], ['Sunnyvale', '07:32'], ['Mountain View', '07:37'], ['Menlo Park', '07:45'], ['Redwood City', '07:51'], ['San Carlos', '07:55'], ['Belmont', '07:58'], ['Hillsdale', '08:02'], ['Hayward Park', '08:05'], ['San Mateo', '08:08'], ['Burlingame', '08:11'], ['Millbrae', '08:17'], ['San Bruno', '08:21'], ['So. San Francisco', '08:25'], ['Bayshore', '08:33'], ['22nd Street', '08:40'], ['San Francisco', '08:48']]
  323: [['San Jose', '07:45'], ['Mountain View', '07:57'], ['Palo Alto', '08:05'], ['Hillsdale', '08:16'], ['Millbrae', '08:24'], ['San Francisco', '08:42']]
  225: [['San Jose', '07:50'], ['Sunnyvale', '08:00'], ['Mountain View', '08:05'], ['California Ave', '08:11'], ['Palo Alto', '08:16'], ['San Carlos', '08:24'], ['Hillsdale', '08:28'], ['San Mateo', '08:32'], ['Burlingame', '08:35'], ['San Bruno', '08:42'], ['San Francisco', '08:57']]
  227: [['Gilroy', '07:05'], ['San Martin', '07:14'], ['Morgan Hill', '07:20'], ['Blossom Hill', '07:33'], ['Capitol', '07:39'], ['Tamien', '07:47'], ['San Jose', '07:55'], ['College Park', '07:58'], ['Santa Clara', '08:02'], ['Lawrence', '08:12'], ['Sunnyvale', '08:18'], ['Mountain View', '08:23'], ['San Antonio', '08:27'], ['California Ave', '08:31'], ['Palo Alto', '08:36'], ['Menlo Park', '08:39'], ['Redwood City', '08:45'], ['Hillsdale', '08:51'], ['Millbrae', '08:59'], ['So. San Francisco', '09:05'], ['San Francisco', '09:19']]
  329: [['Tamien', '07:56'], ['San Jose', '08:03'], ['Sunnyvale', '08:13'], ['Palo Alto', '08:23'], ['Redwood City', '08:30'], ['San Mateo', '08:39'], ['Millbrae', '08:45'], ['San Francisco', '09:02']]
  231: [['San Jose', '08:20'], ['Santa Clara', '08:25'], ['Sunnyvale', '08:32'], ['Mountain View', '08:37'], ['Menlo Park', '08:45'], ['Redwood City', '08:51'], ['San Carlos', '08:55'], ['Belmont', '08:58'], ['Hillsdale', '09:02'], ['Hayward Park', '09:05'], ['San Mateo', '09:08'], ['Burlingame', '09:11'], ['Millbrae', '09:17'], ['San Bruno', '09:21'], ['So. San Francisco', '09:25'], ['Bayshore', '09:31'], ['22nd Street', '09:37'], ['San Francisco', '09:45']]
  233: [['Tamien', '08:33'], ['San Jose', '08:40'], ['Santa Clara', '08:45'], ['Lawrence', '08:50'], ['Sunnyvale', '08:54'], ['Mountain View', '08:59'], ['San Antonio', '09:03'], ['California Ave', '09:07'], ['Palo Alto', '09:11'], ['Menlo Park', '09:14'], ['Redwood City', '09:19'], ['San Carlos', '09:23'], ['Belmont', '09:26'], ['Hillsdale', '09:29'], ['San Mateo', '09:33'], ['Burlingame', '09:36'], ['Millbrae', '09:41'], ['San Bruno', '09:45'], ['San Francisco', '10:02']]
  135: [['San Jose', '09:10'], ['Santa Clara', '09:15'], ['Lawrence', '09:20'], ['Sunnyvale', '09:24'], ['Mountain View', '09:29'], ['San Antonio', '09:33'], ['California Ave', '09:37'], ['Palo Alto', '09:41'], ['Menlo Park', '09:44'], ['Redwood City', '09:49'], ['San Carlos', '09:53'], ['Belmont', '09:56'], ['Hillsdale', '09:59'], ['Hayward Park', '10:02'], ['San Mateo', '10:05'], ['Burlingame', '10:08'], ['Millbrae', '10:13'], ['San Bruno', '10:17'], ['So. San Francisco', '10:21'], ['Bayshore', '10:27'], ['22nd Street', '10:32'], ['San Francisco', '10:41']]
  237: [['Tamien', '09:33'], ['San Jose', '09:40'], ['Santa Clara', '09:45'], ['Lawrence', '09:50'], ['Sunnyvale', '09:54'], ['Mountain View', '09:59'], ['San Antonio', '10:03'], ['California Ave', '10:07'], ['Palo Alto', '10:11'], ['Menlo Park', '10:14'], ['Redwood City', '10:19'], ['San Carlos', '10:23'], ['Belmont', '10:26'], ['Hillsdale', '10:29'], ['San Mateo', '10:33'], ['Burlingame', '10:36'], ['Millbrae', '10:41'], ['San Bruno', '10:45'], ['San Francisco', '11:02']]
  139: [['San Jose', '10:10'], ['Santa Clara', '10:15'], ['Lawrence', '10:20'], ['Sunnyvale', '10:24'], ['Mountain View', '10:29'], ['San Antonio', '10:33'], ['California Ave', '10:37'], ['Palo Alto', '10:41'], ['Menlo Park', '10:44'], ['Redwood City', '10:49'], ['San Carlos', '10:53'], ['Belmont', '10:56'], ['Hillsdale', '10:59'], ['Hayward Park', '11:02'], ['San Mateo', '11:05'], ['Burlingame', '11:08'], ['Millbrae', '11:13'], ['San Bruno', '11:17'], ['So. San Francisco', '11:21'], ['Bayshore', '11:27'], ['22nd Street', '11:32'], ['San Francisco', '11:41']]
  143: [['San Jose', '11:10'], ['Santa Clara', '11:15'], ['Lawrence', '11:20'], ['Sunnyvale', '11:24'], ['Mountain View', '11:29'], ['San Antonio', '11:33'], ['California Ave', '11:37'], ['Palo Alto', '11:41'], ['Menlo Park', '11:44'], ['Redwood City', '11:49'], ['San Carlos', '11:53'], ['Belmont', '11:56'], ['Hillsdale', '11:59'], ['Hayward Park', '12:02'], ['San Mateo', '12:05'], ['Burlingame', '12:08'], ['Millbrae', '12:13'], ['San Bruno', '12:17'], ['So. San Francisco', '12:21'], ['Bayshore', '12:27'], ['22nd Street', '12:32'], ['San Francisco', '12:41']]
  147: [['San Jose', '12:10'], ['Santa Clara', '12:15'], ['Lawrence', '12:20'], ['Sunnyvale', '12:24'], ['Mountain View', '12:29'], ['San Antonio', '12:33'], ['California Ave', '12:37'], ['Palo Alto', '12:41'], ['Menlo Park', '12:44'], ['Redwood City', '12:49'], ['San Carlos', '12:53'], ['Belmont', '12:56'], ['Hillsdale', '12:59'], ['Hayward Park', '13:02'], ['San Mateo', '13:05'], ['Burlingame', '13:08'], ['Millbrae', '13:13'], ['San Bruno', '13:17'], ['So. San Francisco', '13:21'], ['Bayshore', '13:27'], ['22nd Street', '13:32'], ['San Francisco', '13:41']]
  151: [['San Jose', '13:10'], ['Santa Clara', '13:15'], ['Lawrence', '13:20'], ['Sunnyvale', '13:24'], ['Mountain View', '13:29'], ['San Antonio', '13:33'], ['California Ave', '13:37'], ['Palo Alto', '13:41'], ['Menlo Park', '13:44'], ['Redwood City', '13:49'], ['San Carlos', '13:53'], ['Belmont', '13:56'], ['Hillsdale', '13:59'], ['Hayward Park', '14:02'], ['San Mateo', '14:05'], ['Burlingame', '14:08'], ['Millbrae', '14:13'], ['San Bruno', '14:17'], ['So. San Francisco', '14:21'], ['Bayshore', '14:27'], ['22nd Street', '14:32'], ['San Francisco', '14:41']]
  155: [['San Jose', '14:10'], ['Santa Clara', '14:15'], ['Lawrence', '14:20'], ['Sunnyvale', '14:24'], ['Mountain View', '14:29'], ['San Antonio', '14:33'], ['California Ave', '14:37'], ['Palo Alto', '14:41'], ['Menlo Park', '14:44'], ['Redwood City', '14:49'], ['San Carlos', '14:53'], ['Belmont', '14:56'], ['Hillsdale', '14:59'], ['Hayward Park', '15:02'], ['San Mateo', '15:05'], ['Burlingame', '15:08'], ['Millbrae', '15:13'], ['San Bruno', '15:17'], ['So. San Francisco', '15:21'], ['Bayshore', '15:27'], ['22nd Street', '15:32'], ['San Francisco', '15:41']]
  257: [['Tamien', '14:33'], ['San Jose', '14:40'], ['Santa Clara', '14:45'], ['Lawrence', '14:50'], ['Sunnyvale', '14:54'], ['Mountain View', '14:59'], ['San Antonio', '15:03'], ['California Ave', '15:07'], ['Palo Alto', '15:11'], ['Menlo Park', '15:14'], ['Redwood City', '15:19'], ['San Carlos', '15:23'], ['Belmont', '15:26'], ['Hillsdale', '15:29'], ['San Mateo', '15:33'], ['Burlingame', '15:36'], ['Millbrae', '15:41'], ['San Bruno', '15:45'], ['San Francisco', '16:02']]
  159: [['San Jose', '15:05'], ['College Park', '15:08'], ['Santa Clara', '15:12'], ['Lawrence', '15:17'], ['Sunnyvale', '15:21'], ['Mountain View', '15:26'], ['San Antonio', '15:30'], ['California Ave', '15:34'], ['Palo Alto', '15:38'], ['Menlo Park', '15:41'], ['Redwood City', '15:46'], ['San Carlos', '15:50'], ['Belmont', '15:53'], ['Hillsdale', '15:56'], ['Hayward Park', '15:59'], ['San Mateo', '16:02'], ['Burlingame', '16:05'], ['Millbrae', '16:10'], ['San Bruno', '16:14'], ['So. San Francisco', '16:18'], ['Bayshore', '16:24'], ['22nd Street', '16:29'], ['San Francisco', '16:38']]
  261: [['Tamien', '15:37'], ['San Jose', '15:44'], ['Santa Clara', '15:49'], ['Lawrence', '15:54'], ['Sunnyvale', '15:58'], ['Mountain View', '16:03'], ['San Antonio', '16:07'], ['California Ave', '16:11'], ['Palo Alto', '16:16'], ['Menlo Park', '16:19'], ['Redwood City', '16:25'], ['San Carlos', '16:29'], ['San Mateo', '16:36'], ['Millbrae', '16:43'], ['22nd Street', '16:55'], ['San Francisco', '17:03']]
  263: [['Tamien', '15:58'], ['San Jose', '16:05'], ['Santa Clara', '16:10'], ['Palo Alto', '16:24'], ['Redwood City', '16:31'], ['San Carlos', '16:35'], ['Belmont', '16:38'], ['Hillsdale', '16:42'], ['Hayward Park', '16:45'], ['San Mateo', '16:48'], ['Burlingame', '16:51'], ['Millbrae', '16:57'], ['San Bruno', '17:01'], ['So. San Francisco', '17:05'], ['Bayshore', '17:13'], ['22nd Street', '17:21'], ['San Francisco', '17:29']]
  365: [['San Jose', '16:23'], ['Mountain View', '16:35'], ['Palo Alto', '16:43'], ['Menlo Park', '16:46'], ['Redwood City', '16:52'], ['Millbrae', '17:05'], ['22nd Street', '17:17'], ['San Francisco', '17:24']]
  267: [['San Jose', '16:31'], ['Lawrence', '16:39'], ['Mountain View', '16:46'], ['Palo Alto', '16:54'], ['Menlo Park', '16:57'], ['San Carlos', '17:04'], ['Hillsdale', '17:08'], ['San Mateo', '17:12'], ['Burlingame', '17:15'], ['San Bruno', '17:22'], ['San Francisco', '17:39']]
  269: [['Tamien', '16:32'], ['San Jose', '16:39'], ['Santa Clara', '16:44'], ['Lawrence', '16:52'], ['Sunnyvale', '16:58'], ['Mountain View', '17:03'], ['San Antonio', '17:07'], ['California Ave', '17:11'], ['Palo Alto', '17:16'], ['Menlo Park', '17:19'], ['Redwood City', '17:25'], ['San Carlos', '17:29'], ['San Mateo', '17:36'], ['Millbrae', '17:43'], ['22nd Street', '17:55'], ['San Francisco', '18:02']]
  371: [['San Jose', '16:45'], ['Mountain View', '16:58'], ['Palo Alto', '17:06'], ['Hillsdale', '17:17'], ['Millbrae', '17:25'], ['22nd Street', '17:37'], ['San Francisco', '17:44']]
  273: [['Tamien', '16:58'], ['San Jose', '17:05'], ['Santa Clara', '17:10'], ['Palo Alto', '17:24'], ['Redwood City', '17:31'], ['San Carlos', '17:35'], ['Belmont', '17:38'], ['Hillsdale', '17:42'], ['Hayward Park', '17:45'], ['San Mateo', '17:48'], ['Burlingame', '17:51'], ['Millbrae', '17:57'], ['San Bruno', '18:01'], ['So. San Francisco', '18:05'], ['Bayshore', '18:13'], ['22nd Street', '18:21'], ['San Francisco', '18:29']]
  375: [['San Jose', '17:23'], ['Mountain View', '17:35'], ['Palo Alto', '17:43'], ['Menlo Park', '17:46'], ['Redwood City', '17:52'], ['Millbrae', '18:05'], ['22nd Street', '18:17'], ['San Francisco', '18:24']]
  277: [['San Jose', '17:31'], ['Lawrence', '17:39'], ['Mountain View', '17:46'], ['Palo Alto', '17:54'], ['Menlo Park', '17:57'], ['San Carlos', '18:04'], ['Hillsdale', '18:08'], ['San Mateo', '18:12'], ['Burlingame', '18:15'], ['San Bruno', '18:22'], ['San Francisco', '18:39']]
  279: [['Tamien', '17:32'], ['San Jose', '17:39'], ['Santa Clara', '17:44'], ['Lawrence', '17:52'], ['Sunnyvale', '17:58'], ['Mountain View', '18:03'], ['San Antonio', '18:07'], ['California Ave', '18:11'], ['Palo Alto', '18:16'], ['Menlo Park', '18:19'], ['Redwood City', '18:25'], ['San Carlos', '18:29'], ['San Mateo', '18:36'], ['Millbrae', '18:43'], ['22nd Street', '18:55'], ['San Francisco', '19:02']]
  381: [['San Jose', '17:45'], ['Mountain View', '17:58'], ['Palo Alto', '18:06'], ['Hillsdale', '18:17'], ['Millbrae', '18:25'], ['22nd Street', '18:37'], ['San Francisco', '18:44']]
  283: [['Tamien', '17:58'], ['San Jose', '18:05'], ['Santa Clara', '18:10'], ['Palo Alto', '18:24'], ['Redwood City', '18:31'], ['San Carlos', '18:35'], ['Belmont', '18:38'], ['Hillsdale', '18:42'], ['Hayward Park', '18:45'], ['San Mateo', '18:48'], ['Burlingame', '18:51'], ['Millbrae', '18:57'], ['San Bruno', '19:01'], ['So. San Francisco', '19:05'], ['Bayshore', '19:13'], ['22nd Street', '19:21'], ['San Francisco', '19:29']]
  385: [['San Jose', '18:23'], ['Mountain View', '18:35'], ['Palo Alto', '18:43'], ['Menlo Park', '18:46'], ['Redwood City', '18:52'], ['Millbrae', '19:05'], ['22nd Street', '19:17'], ['San Francisco', '19:24']]
  287: [['Tamien', '18:24'], ['San Jose', '18:31'], ['Lawrence', '18:39'], ['Mountain View', '18:46'], ['Palo Alto', '18:54'], ['Menlo Park', '18:57'], ['San Carlos', '19:04'], ['Hillsdale', '19:08'], ['San Mateo', '19:12'], ['Burlingame', '19:15'], ['San Bruno', '19:22'], ['San Francisco', '19:39']]
  289: [['San Jose', '18:45'], ['Lawrence', '18:53'], ['Mountain View', '19:00'], ['California Ave', '19:06'], ['Palo Alto', '19:10'], ['Menlo Park', '19:13'], ['Redwood City', '19:19'], ['San Carlos', '19:23'], ['Hillsdale', '19:28'], ['San Mateo', '19:32'], ['Burlingame', '19:35'], ['Millbrae', '19:41'], ['22nd Street', '19:53'], ['San Francisco', '20:00']]
  191: [['San Jose', '18:50'], ['Santa Clara', '18:55'], ['Lawrence', '19:00'], ['Sunnyvale', '19:04'], ['Mountain View', '19:09'], ['San Antonio', '19:13'], ['California Ave', '19:17'], ['Palo Alto', '19:21'], ['Menlo Park', '19:24'], ['Redwood City', '19:29'], ['San Carlos', '19:33'], ['Belmont', '19:36'], ['Hillsdale', '19:39'], ['Hayward Park', '19:42'], ['San Mateo', '19:45'], ['Burlingame', '19:48'], ['Millbrae', '19:53'], ['San Bruno', '19:57'], ['So. San Francisco', '20:01'], ['Bayshore', '20:07'], ['22nd Street', '20:12'], ['San Francisco', '20:21']]
  193: [['San Jose', '19:30'], ['Santa Clara', '19:35'], ['Lawrence', '19:40'], ['Sunnyvale', '19:44'], ['Mountain View', '19:49'], ['San Antonio', '19:53'], ['California Ave', '19:57'], ['Palo Alto', '20:01'], ['Menlo Park', '20:04'], ['Redwood City', '20:09'], ['San Carlos', '20:13'], ['Belmont', '20:16'], ['Hillsdale', '20:19'], ['Hayward Park', '20:22'], ['San Mateo', '20:25'], ['Burlingame', '20:28'], ['Millbrae', '20:33'], ['San Bruno', '20:37'], ['So. San Francisco', '20:41'], ['Bayshore', '20:47'], ['22nd Street', '20:52'], ['San Francisco', '21:01']]
  195: [['Tamien', '20:23'], ['San Jose', '20:30'], ['Santa Clara', '20:35'], ['Lawrence', '20:40'], ['Sunnyvale', '20:44'], ['Mountain View', '20:49'], ['San Antonio', '20:53'], ['California Ave', '20:57'], ['Palo Alto', '21:01'], ['Menlo Park', '21:04'], ['Redwood City', '21:09'], ['San Carlos', '21:13'], ['Belmont', '21:16'], ['Hillsdale', '21:19'], ['Hayward Park', '21:22'], ['San Mateo', '21:25'], ['Burlingame', '21:28'], ['Millbrae', '21:33'], ['San Bruno', '21:37'], ['So. San Francisco', '21:41'], ['Bayshore', '21:47'], ['22nd Street', '21:52'], ['San Francisco', '22:01']]
  197: [['Tamien', '21:23'], ['San Jose', '21:30'], ['Santa Clara', '21:35'], ['Lawrence', '21:40'], ['Sunnyvale', '21:44'], ['Mountain View', '21:49'], ['San Antonio', '21:53'], ['California Ave', '21:57'], ['Palo Alto', '22:01'], ['Menlo Park', '22:04'], ['Redwood City', '22:09'], ['San Carlos', '22:13'], ['Belmont', '22:16'], ['Hillsdale', '22:19'], ['Hayward Park', '22:22'], ['San Mateo', '22:25'], ['Burlingame', '22:28'], ['Millbrae', '22:33'], ['San Bruno', '22:37'], ['So. San Francisco', '22:41'], ['Bayshore', '22:47'], ['22nd Street', '22:52'], ['San Francisco', '23:01']]
  199: [['San Jose', '22:30'], ['Santa Clara', '22:35'], ['Lawrence', '22:40'], ['Sunnyvale', '22:44'], ['Mountain View', '22:49'], ['San Antonio', '22:53'], ['California Ave', '22:57'], ['Palo Alto', '23:01'], ['Menlo Park', '23:04'], ['Redwood City', '23:09'], ['San Carlos', '23:13'], ['Belmont', '23:16'], ['Hillsdale', '23:19'], ['Hayward Park', '23:22'], ['San Mateo', '23:25'], ['Burlingame', '23:28'], ['Millbrae', '23:33'], ['San Bruno', '23:37'], ['So. San Francisco', '23:41'], ['Bayshore', '23:47'], ['22nd Street', '23:52'], ['San Francisco', '24:01']]
  102: [['San Francisco', '04:55'], ['22nd Street', '05:00'], ['Bayshore', '05:05'], ['So. San Francisco', '05:11'], ['San Bruno', '05:15'], ['Millbrae', '05:19'], ['Burlingame', '05:23'], ['San Mateo', '05:26'], ['Hayward Park', '05:29'], ['Hillsdale', '05:32'], ['Belmont', '05:35'], ['San Carlos', '05:38'], ['Redwood City', '05:43'], ['Menlo Park', '05:48'], ['Palo Alto', '05:51'], ['California Ave', '05:55'], ['San Antonio', '05:59'], ['Mountain View', '06:03'], ['Sunnyvale', '06:08'], ['Lawrence', '06:12'], ['Santa Clara', '06:17'], ['San Jose', '06:26']]
  104: [['San Francisco', '05:25'], ['22nd Street', '05:30'], ['Bayshore', '05:35'], ['So. San Francisco', '05:41'], ['San Bruno', '05:45'], ['Millbrae', '05:49'], ['Burlingame', '05:53'], ['San Mateo', '05:56'], ['Hayward Park', '05:59'], ['Hillsdale', '06:02'], ['Belmont', '06:05'], ['San Carlos', '06:08'], ['Redwood City', '06:13'], ['Menlo Park', '06:18'], ['Palo Alto', '06:21'], ['California Ave', '06:25'], ['San Antonio', '06:29'], ['Mountain View', '06:33'], ['Sunnyvale', '06:38'], ['Lawrence', '06:42'], ['Santa Clara', '06:47'], ['San Jose', '06:56'], ['Tamien', '07:03']]
  206: [['San Francisco', '06:11'], ['22nd Street', '06:16'], ['Millbrae', '06:29'], ['Burlingame', '06:33'], ['San Mateo', '06:36'], ['Hillsdale', '06:40'], ['San Carlos', '06:44'], ['Redwood City', '06:49'], ['Menlo Park', '06:54'], ['Palo Alto', '06:57'], ['California Ave', '07:01'], ['Mountain View', '07:07'], ['Lawrence', '07:12'], ['San Jose', '07:24']]
  208: [['San Francisco', '06:24'], ['22nd Street', '06:29'], ['Bayshore', '06:34'], ['So. San Francisco', '06:40'], ['San Bruno', '06:44'], ['Millbrae', '06:48'], ['Burlingame', '06:52'], ['San Mateo', '06:55'], ['Hayward Park', '06:58'], ['Hillsdale', '07:01'], ['Belmont', '07:04'], ['San Carlos', '07:07'], ['Redwood City', '07:12'], ['Palo Alto', '07:18'], ['Santa Clara', '07:34'], ['San Jose', '07:43'], ['Tamien', '07:50']]
  210: [['San Francisco', '06:44'], ['22nd Street', '06:49'], ['Millbrae', '07:01'], ['San Mateo', '07:07'], ['San Carlos', '07:13'], ['Redwood City', '07:18'], ['Menlo Park', '07:23'], ['Palo Alto', '07:26'], ['California Ave', '07:30'], ['San Antonio', '07:34'], ['Mountain View', '07:38'], ['Sunnyvale', '07:43'], ['Lawrence', '07:49'], ['Santa Clara', '07:56'], ['College Park', '07:59'], ['San Jose', '08:06'], ['Tamien', '08:13']]
  312: [['San Francisco', '06:57'], ['22nd Street', '07:02'], ['Millbrae', '07:15'], ['Redwood City', '07:28'], ['Menlo Park', '07:33'], ['Palo Alto', '07:36'], ['Mountain View', '07:44'], ['San Jose', '07:58']]
  314: [['San Francisco', '07:14'], ['22nd Street', '07:19'], ['Millbrae', '07:32'], ['Hillsdale', '07:40'], ['Palo Alto', '07:51'], ['Mountain View', '07:58'], ['San Jose', '08:13']]
  216: [['San Francisco', '07:19'], ['San Bruno', '07:33'], ['Burlingame', '07:38'], ['San Mateo', '07:42'], ['Hillsdale', '07:46'], ['San Carlos', '07:50'], ['Menlo Park', '07:58'], ['Palo Alto', '08:01'], ['Mountain View', '08:09'], ['Lawrence', '08:16'], ['San Jose', '08:28']]
  218: [['San Francisco', '07:24'], ['22nd Street', '07:29'], ['Bayshore', '07:34'], ['So. San Francisco', '07:40'], ['San Bruno', '07:44'], ['Millbrae', '07:48'], ['Burlingame', '07:52'], ['San Mateo', '07:55'], ['Hayward Park', '07:58'], ['Hillsdale', '08:01'], ['Belmont', '08:04'], ['San Carlos', '08:07'], ['Redwood City', '08:12'], ['Palo Alto', '08:18'], ['Santa Clara', '08:34'], ['San Jose', '08:43'], ['Tamien', '08:50']]
  220: [['San Francisco', '07:44'], ['22nd Street', '07:49'], ['Millbrae', '08:01'], ['San Mateo', '08:07'], ['San Carlos', '08:13'], ['Redwood City', '08:18'], ['Menlo Park', '08:23'], ['Palo Alto', '08:26'], ['California Ave', '08:30'], ['San Antonio', '08:34'], ['Mountain View', '08:38'], ['Sunnyvale', '08:43'], ['Lawrence', '08:49'], ['Santa Clara', '08:56'], ['San Jose', '09:05'], ['Tamien', '09:12']]
  322: [['San Francisco', '07:57'], ['22nd Street', '08:02'], ['Millbrae', '08:15'], ['Redwood City', '08:28'], ['Menlo Park', '08:33'], ['Palo Alto', '08:36'], ['Mountain View', '08:44'], ['San Jose', '08:58']]
  324: [['San Francisco', '08:14'], ['22nd Street', '08:19'], ['Millbrae', '08:32'], ['Hillsdale', '08:40'], ['Palo Alto', '08:51'], ['Mountain View', '08:58'], ['San Jose', '09:13']]
  226: [['San Francisco', '08:19'], ['San Bruno', '08:33'], ['Burlingame', '08:38'], ['San Mateo', '08:42'], ['Hillsdale', '08:46'], ['San Carlos', '08:50'], ['Menlo Park', '08:58'], ['Palo Alto', '09:01'], ['Mountain View', '09:09'], ['Lawrence', '09:16'], ['San Jose', '09:28']]
  228: [['San Francisco', '08:24'], ['22nd Street', '08:29'], ['Bayshore', '08:34'], ['So. San Francisco', '08:40'], ['San Bruno', '08:44'], ['Millbrae', '08:48'], ['Burlingame', '08:52'], ['San Mateo', '08:55'], ['Hayward Park', '08:58'], ['Hillsdale', '09:01'], ['Belmont', '09:04'], ['San Carlos', '09:07'], ['Redwood City', '09:12'], ['Palo Alto', '09:18'], ['Santa Clara', '09:34'], ['San Jose', '09:43'], ['Tamien', '09:50']]
  230: [['San Francisco', '08:44'], ['22nd Street', '08:49'], ['Millbrae', '09:01'], ['San Mateo', '09:07'], ['San Carlos', '09:13'], ['Redwood City', '09:18'], ['Menlo Park', '09:23'], ['Palo Alto', '09:26'], ['California Ave', '09:30'], ['San Antonio', '09:34'], ['Mountain View', '09:38'], ['Sunnyvale', '09:43'], ['Lawrence', '09:49'], ['Santa Clara', '09:56'], ['San Jose', '10:05'], ['Tamien', '10:12']]
  332: [['San Francisco', '08:57'], ['22nd Street', '09:02'], ['Millbrae', '09:15'], ['Redwood City', '09:28'], ['Menlo Park', '09:33'], ['Palo Alto', '09:36'], ['Mountain View', '09:44'], ['San Jose', '09:58']]
  134: [['San Francisco', '09:07'], ['22nd Street', '09:12'], ['Bayshore', '09:17'], ['So. San Francisco', '09:23'], ['San Bruno', '09:27'], ['Millbrae', '09:31'], ['Burlingame', '09:35'], ['San Mateo', '09:38'], ['Hayward Park', '09:41'], ['Hillsdale', '09:44'], ['Belmont', '09:47'], ['San Carlos', '09:50'], ['Redwood City', '09:55'], ['Menlo Park', '10:00'], ['Palo Alto', '10:03'], ['California Ave', '10:07'], ['San Antonio', '10:11'], ['Mountain View', '10:15'], ['Sunnyvale', '10:20'], ['Lawrence', '10:24'], ['Santa Clara', '10:29'], ['San Jose', '10:38']]
  236: [['San Francisco', '09:37'], ['San Bruno', '09:51'], ['Millbrae', '09:55'], ['Burlingame', '09:59'], ['San Mateo', '10:02'], ['Hillsdale', '10:06'], ['Belmont', '10:09'], ['San Carlos', '10:12'], ['Redwood City', '10:17'], ['Menlo Park', '10:22'], ['Palo Alto', '10:25'], ['California Ave', '10:29'], ['San Antonio', '10:33'], ['Mountain View', '10:37'], ['Sunnyvale', '10:42'], ['Lawrence', '10:46'], ['Santa Clara', '10:51'], ['San Jose', '11:00'], ['Tamien', '11:07']]
  138: [['San Francisco', '10:07'], ['22nd Street', '10:12'], ['Bayshore', '10:17'], ['So. San Francisco', '10:23'], ['San Bruno', '10:27'], ['Millbrae', '10:31'], ['Burlingame', '10:35'], ['San Mateo', '10:38'], ['Hayward Park', '10:41'], ['Hillsdale', '10:44'], ['Belmont', '10:47'], ['San Carlos', '10:50'], ['Redwood City', '10:55'], ['Menlo Park', '11:00'], ['Palo Alto', '11:03'], ['California Ave', '11:07'], ['San Antonio', '11:11'], ['Mountain View', '11:15'], ['Sunnyvale', '11:20'], ['Lawrence', '11:24'], ['Santa Clara', '11:29'], ['San Jose', '11:38']]
  142: [['San Francisco', '11:07'], ['22nd Street', '11:12'], ['Bayshore', '11:17'], ['So. San Francisco', '11:23'], ['San Bruno', '11:27'], ['Millbrae', '11:31'], ['Burlingame', '11:35'], ['San Mateo', '11:38'], ['Hayward Park', '11:41'], ['Hillsdale', '11:44'], ['Belmont', '11:47'], ['San Carlos', '11:50'], ['Redwood City', '11:55'], ['Menlo Park', '12:00'], ['Palo Alto', '12:03'], ['California Ave', '12:07'], ['San Antonio', '12:11'], ['Mountain View', '12:15'], ['Sunnyvale', '12:20'], ['Lawrence', '12:24'], ['Santa Clara', '12:29'], ['San Jose', '12:38']]
  146: [['San Francisco', '12:07'], ['22nd Street', '12:12'], ['Bayshore', '12:17'], ['So. San Francisco', '12:23'], ['San Bruno', '12:27'], ['Millbrae', '12:31'], ['Burlingame', '12:35'], ['San Mateo', '12:38'], ['Hayward Park', '12:41'], ['Hillsdale', '12:44'], ['Belmont', '12:47'], ['San Carlos', '12:50'], ['Redwood City', '12:55'], ['Menlo Park', '13:00'], ['Palo Alto', '13:03'], ['California Ave', '13:07'], ['San Antonio', '13:11'], ['Mountain View', '13:15'], ['Sunnyvale', '13:20'], ['Lawrence', '13:24'], ['Santa Clara', '13:29'], ['San Jose', '13:38']]
  150: [['San Francisco', '13:07'], ['22nd Street', '13:12'], ['Bayshore', '13:17'], ['So. San Francisco', '13:23'], ['San Bruno', '13:27'], ['Millbrae', '13:31'], ['Burlingame', '13:35'], ['San Mateo', '13:38'], ['Hayward Park', '13:41'], ['Hillsdale', '13:44'], ['Belmont', '13:47'], ['San Carlos', '13:50'], ['Redwood City', '13:55'], ['Menlo Park', '14:00'], ['Palo Alto', '14:03'], ['California Ave', '14:07'], ['San Antonio', '14:11'], ['Mountain View', '14:15'], ['Sunnyvale', '14:20'], ['Lawrence', '14:24'], ['Santa Clara', '14:29'], ['San Jose', '14:38']]
  152: [['San Francisco', '14:07'], ['22nd Street', '14:12'], ['Bayshore', '14:17'], ['So. San Francisco', '14:23'], ['San Bruno', '14:27'], ['Millbrae', '14:31'], ['Burlingame', '14:35'], ['San Mateo', '14:38'], ['Hayward Park', '14:41'], ['Hillsdale', '14:44'], ['Belmont', '14:47'], ['San Carlos', '14:50'], ['Redwood City', '14:55'], ['Menlo Park', '15:00'], ['Palo Alto', '15:03'], ['California Ave', '15:07'], ['San Antonio', '15:11'], ['Mountain View', '15:15'], ['Sunnyvale', '15:20'], ['Lawrence', '15:24'], ['Santa Clara', '15:29'], ['San Jose', '15:38']]
  254: [['San Francisco', '14:37'], ['San Bruno', '14:51'], ['Millbrae', '14:55'], ['Burlingame', '14:59'], ['San Mateo', '15:02'], ['Hillsdale', '15:06'], ['Belmont', '15:09'], ['San Carlos', '15:12'], ['Redwood City', '15:17'], ['Menlo Park', '15:22'], ['Palo Alto', '15:25'], ['California Ave', '15:29'], ['San Antonio', '15:33'], ['Mountain View', '15:37'], ['Sunnyvale', '15:42'], ['Lawrence', '15:46'], ['Santa Clara', '15:51'], ['San Jose', '16:00'], ['Tamien', '16:07']]
  156: [['San Francisco', '15:07'], ['22nd Street', '15:12'], ['Bayshore', '15:17'], ['So. San Francisco', '15:23'], ['San Bruno', '15:27'], ['Millbrae', '15:31'], ['Burlingame', '15:35'], ['San Mateo', '15:38'], ['Hayward Park', '15:41'], ['Hillsdale', '15:44'], ['Belmont', '15:47'], ['San Carlos', '15:50'], ['Redwood City', '15:55'], ['Menlo Park', '16:00'], ['Palo Alto', '16:03'], ['California Ave', '16:07'], ['San Antonio', '16:11'], ['Mountain View', '16:15'], ['Sunnyvale', '16:20'], ['Lawrence', '16:24'], ['Santa Clara', '16:29'], ['College Park', '16:32'], ['San Jose', '16:39'], ['Tamien', '16:45'], ['Capitol', '16:52'], ['Blossom Hill', '16:58'], ['Morgan Hill', '17:11'], ['San Martin', '17:17'], ['Gilroy', '17:30']]
  258: [['San Francisco', '15:37'], ['San Bruno', '15:51'], ['Millbrae', '15:55'], ['Burlingame', '15:59'], ['San Mateo', '16:02'], ['Hillsdale', '16:06'], ['Belmont', '16:09'], ['San Carlos', '16:12'], ['Redwood City', '16:17'], ['Menlo Park', '16:22'], ['Palo Alto', '16:25'], ['California Ave', '16:29'], ['San Antonio', '16:33'], ['Mountain View', '16:37'], ['Sunnyvale', '16:42'], ['Lawrence', '16:46'], ['Santa Clara', '16:51'], ['San Jose', '17:00'], ['Tamien', '17:07']]
  360: [['San Francisco', '16:09'], ['Millbrae', '16:25'], ['Hillsdale', '16:33'], ['Palo Alto', '16:44'], ['Mountain View', '16:51'], ['San Jose', '17:06']]
  262: [['San Francisco', '16:19'], ['San Bruno', '16:33'], ['Burlingame', '16:38'], ['San Mateo', '16:42'], ['Hillsdale', '16:47'], ['San Carlos', '16:51'], ['Palo Alto', '17:01'], ['California Ave', '17:05'], ['Mountain View', '17:11'], ['Sunnyvale', '17:16'], ['San Jose', '17:27']]
  264: [['San Francisco', '16:27'], ['22nd Street', '16:32'], ['Bayshore', '16:40'], ['So. San Francisco', '16:48'], ['San Bruno', '16:52'], ['Millbrae', '16:56'], ['Burlingame', '17:00'], ['San Mateo', '17:04'], ['Hayward Park', '17:07'], ['Hillsdale', '17:11'], ['Belmont', '17:14'], ['San Carlos', '17:18'], ['Redwood City', '17:22'], ['Menlo Park', '17:28'], ['Mountain View', '17:36'], ['Sunnyvale', '17:41'], ['Santa Clara', '17:49'], ['San Jose', '17:57']]
  366: [['San Francisco', '16:33'], ['Millbrae', '16:49'], ['San Mateo', '16:57'], ['Redwood City', '17:06'], ['Palo Alto', '17:12'], ['Sunnyvale', '17:21'], ['San Jose', '17:32'], ['Tamien', '17:39']]
  268: [['San Francisco', '16:56'], ['So. San Francisco', '17:08'], ['Millbrae', '17:14'], ['Hillsdale', '17:22'], ['Redwood City', '17:28'], ['Menlo Park', '17:34'], ['Palo Alto', '17:38'], ['California Ave', '17:42'], ['San Antonio', '17:46'], ['Mountain View', '17:50'], ['Sunnyvale', '17:55'], ['Lawrence', '18:01'], ['Santa Clara', '18:08'], ['San Jose', '18:16'], ['Tamien', '18:22'], ['Capitol', '18:29'], ['Blossom Hill', '18:35'], ['Morgan Hill', '18:48'], ['San Martin', '18:54'], ['Gilroy', '19:07']]
  370: [['San Francisco', '17:14'], ['Millbrae', '17:30'], ['Hillsdale', '17:38'], ['Palo Alto', '17:49'], ['Mountain View', '17:56'], ['San Jose', '18:11']]
  272: [['San Francisco', '17:20'], ['San Bruno', '17:34'], ['Burlingame', '17:39'], ['San Mateo', '17:43'], ['Hillsdale', '17:48'], ['San Carlos', '17:52'], ['Palo Alto', '18:02'], ['California Ave', '18:06'], ['Mountain View', '18:12'], ['Sunnyvale', '18:17'], ['San Jose', '18:28']]
  274: [['San Francisco', '17:27'], ['22nd Street', '17:32'], ['Bayshore', '17:40'], ['So. San Francisco', '17:48'], ['San Bruno', '17:52'], ['Millbrae', '17:56'], ['Burlingame', '18:00'], ['San Mateo', '18:04'], ['Hayward Park', '18:07'], ['Hillsdale', '18:11'], ['Belmont', '18:14'], ['San Carlos', '18:18'], ['Redwood City', '18:22'], ['Menlo Park', '18:28'], ['Mountain View', '18:36'], ['Sunnyvale', '18:41'], ['Lawrence', '18:45'], ['Santa Clara', '18:50'], ['San Jose', '18:58'], ['Tamien', '19:04'], ['Capitol', '19:11'], ['Blossom Hill', '19:17'], ['Morgan Hill', '19:30'], ['San Martin', '19:36'], ['Gilroy', '19:49']]
  376: [['San Francisco', '17:33'], ['Millbrae', '17:49'], ['San Mateo', '17:57'], ['Redwood City', '18:06'], ['Palo Alto', '18:12'], ['Sunnyvale', '18:21'], ['San Jose', '18:32'], ['Tamien', '18:39']]
  278: [['San Francisco', '17:56'], ['So. San Francisco', '18:08'], ['Millbrae', '18:14'], ['Hillsdale', '18:22'], ['Redwood City', '18:28'], ['Menlo Park', '18:34'], ['Palo Alto', '18:38'], ['California Ave', '18:42'], ['San Antonio', '18:46'], ['Mountain View', '18:50'], ['Sunnyvale', '18:55'], ['Lawrence', '19:01'], ['Santa Clara', '19:08'], ['San Jose', '19:16'], ['Tamien', '19:23']]
  380: [['San Francisco', '18:14'], ['Millbrae', '18:30'], ['Hillsdale', '18:38'], ['Palo Alto', '18:49'], ['Mountain View', '18:56'], ['San Jose', '19:11']]
  282: [['San Francisco', '18:20'], ['San Bruno', '18:34'], ['Burlingame', '18:39'], ['San Mateo', '18:43'], ['Hillsdale', '18:48'], ['San Carlos', '18:52'], ['Palo Alto', '19:02'], ['California Ave', '19:06'], ['Mountain View', '19:12'], ['Sunnyvale', '19:17'], ['San Jose', '19:28']]
  284: [['San Francisco', '18:27'], ['22nd Street', '18:32'], ['Bayshore', '18:40'], ['So. San Francisco', '18:48'], ['San Bruno', '18:52'], ['Millbrae', '18:56'], ['Burlingame', '19:00'], ['San Mateo', '19:04'], ['Hayward Park', '19:07'], ['Hillsdale', '19:11'], ['Belmont', '19:14'], ['San Carlos', '19:18'], ['Redwood City', '19:22'], ['Menlo Park', '19:28'], ['Mountain View', '19:36'], ['Sunnyvale', '19:41'], ['Santa Clara', '19:49'], ['San Jose', '19:57']]
  386: [['San Francisco', '18:33'], ['Millbrae', '18:49'], ['San Mateo', '18:57'], ['Redwood City', '19:06'], ['Palo Alto', '19:12'], ['Sunnyvale', '19:21'], ['San Jose', '19:32'], ['Tamien', '19:39']]
  288: [['San Francisco', '18:56'], ['So. San Francisco', '19:08'], ['Millbrae', '19:14'], ['Hillsdale', '19:22'], ['Redwood City', '19:28'], ['Menlo Park', '19:34'], ['Palo Alto', '19:38'], ['California Ave', '19:42'], ['San Antonio', '19:46'], ['Mountain View', '19:50'], ['Sunnyvale', '19:55'], ['Lawrence', '19:59'], ['Santa Clara', '20:04'], ['San Jose', '20:12'], ['Tamien', '20:19']]
  190: [['San Francisco', '19:30'], ['22nd Street', '19:35'], ['Bayshore', '19:40'], ['So. San Francisco', '19:46'], ['San Bruno', '19:50'], ['Millbrae', '19:54'], ['Burlingame', '19:58'], ['San Mateo', '20:01'], ['Hayward Park', '20:04'], ['Hillsdale', '20:07'], ['Belmont', '20:10'], ['San Carlos', '20:13'], ['Redwood City', '20:18'], ['Menlo Park', '20:23'], ['Palo Alto', '20:26'], ['California Ave', '20:30'], ['San Antonio', '20:34'], ['Mountain View', '20:38'], ['Sunnyvale', '20:43'], ['Lawrence', '20:47'], ['Santa Clara', '20:52'], ['San Jose', '21:01']]
  192: [['San Francisco', '20:40'], ['22nd Street', '20:45'], ['Bayshore', '20:50'], ['So. San Francisco', '20:56'], ['San Bruno', '21:00'], ['Millbrae', '21:04'], ['Burlingame', '21:08'], ['San Mateo', '21:11'], ['Hayward Park', '21:14'], ['Hillsdale', '21:17'], ['Belmont', '21:20'], ['San Carlos', '21:23'], ['Redwood City', '21:28'], ['Menlo Park', '21:33'], ['Palo Alto', '21:36'], ['California Ave', '21:40'], ['San Antonio', '21:44'], ['Mountain View', '21:48'], ['Sunnyvale', '21:53'], ['Lawrence', '21:57'], ['Santa Clara', '22:02'], ['San Jose', '22:11'], ['Tamien', '22:18']]
  194: [['San Francisco', '21:40'], ['22nd Street', '21:45'], ['Bayshore', '21:50'], ['So. San Francisco', '21:56'], ['San Bruno', '22:00'], ['Millbrae', '22:04'], ['Burlingame', '22:08'], ['San Mateo', '22:11'], ['Hayward Park', '22:14'], ['Hillsdale', '22:17'], ['Belmont', '22:20'], ['San Carlos', '22:23'], ['Redwood City', '22:28'], ['Menlo Park', '22:33'], ['Palo Alto', '22:36'], ['California Ave', '22:40'], ['San Antonio', '22:44'], ['Mountain View', '22:48'], ['Sunnyvale', '22:53'], ['Lawrence', '22:57'], ['Santa Clara', '23:02'], ['San Jose', '23:11'], ['Tamien', '23:18']]
  196: [['San Francisco', '22:40'], ['22nd Street', '22:45'], ['Bayshore', '22:50'], ['So. San Francisco', '22:56'], ['San Bruno', '23:00'], ['Millbrae', '23:04'], ['Burlingame', '23:08'], ['San Mateo', '23:11'], ['Hayward Park', '23:14'], ['Hillsdale', '23:17'], ['Belmont', '23:20'], ['San Carlos', '23:23'], ['Redwood City', '23:28'], ['Menlo Park', '23:33'], ['Palo Alto', '23:36'], ['California Ave', '23:40'], ['San Antonio', '23:44'], ['Mountain View', '23:48'], ['Sunnyvale', '23:53'], ['Lawrence', '23:57'], ['Santa Clara', '12:02'], ['San Jose', '12:11']]
  198: [['San Francisco', '24:01'], ['22nd Street', '24:06'], ['Bayshore', '24:11'], ['So. San Francisco', '24:17'], ['San Bruno', '24:21'], ['Millbrae', '24:25'], ['Burlingame', '24:29'], ['San Mateo', '24:32'], ['Hayward Park', '24:35'], ['Hillsdale', '24:38'], ['Belmont', '24:41'], ['San Carlos', '24:44'], ['Redwood City', '24:49'], ['Menlo Park', '24:54'], ['Palo Alto', '24:57'], ['California Ave', '13:01'], ['San Antonio', '13:05'], ['Mountain View', '13:09'], ['Sunnyvale', '13:14'], ['Lawrence', '13:18'], ['Santa Clara', '13:23'], ['San Jose', '13:32']]

SCHEDULES['saturday'] =
  421: [['San Jose', '07:00'], ['Santa Clara', '07:05'], ['Lawrence', '07:10'], ['Sunnyvale', '07:14'], ['Mountain View', '07:19'], ['San Antonio', '07:23'], ['California Ave', '07:27'], ['Palo Alto', '07:31'], ['Menlo Park', '07:34'], ['Atherton', '07:37'], ['Redwood City', '07:41'], ['San Carlos', '07:45'], ['Belmont', '07:48'], ['Hillsdale', '07:51'], ['Hayward Park', '07:54'], ['San Mateo', '07:57'], ['Burlingame', '08:00'], ['Broadway', '08:03'], ['Millbrae', '08:08'], ['San Bruno', '08:12'], ['So. San Francisco', '08:17'], ['Bayshore', '08:23'], ['22nd Street', '08:28'], ['San Francisco', '08:36']]
  423: [['San Jose', '08:00'], ['Santa Clara', '08:05'], ['Lawrence', '08:10'], ['Sunnyvale', '08:14'], ['Mountain View', '08:19'], ['San Antonio', '08:23'], ['California Ave', '08:27'], ['Palo Alto', '08:31'], ['Menlo Park', '08:34'], ['Atherton', '08:37'], ['Redwood City', '08:41'], ['San Carlos', '08:45'], ['Belmont', '08:48'], ['Hillsdale', '08:51'], ['Hayward Park', '08:54'], ['San Mateo', '08:57'], ['Burlingame', '09:00'], ['Broadway', '09:03'], ['Millbrae', '09:08'], ['San Bruno', '09:12'], ['So. San Francisco', '09:17'], ['Bayshore', '09:23'], ['22nd Street', '09:28'], ['San Francisco', '09:36']]
  425: [['San Jose', '09:00'], ['Santa Clara', '09:05'], ['Lawrence', '09:10'], ['Sunnyvale', '09:14'], ['Mountain View', '09:19'], ['San Antonio', '09:23'], ['California Ave', '09:27'], ['Palo Alto', '09:31'], ['Menlo Park', '09:34'], ['Atherton', '09:37'], ['Redwood City', '09:41'], ['San Carlos', '09:45'], ['Belmont', '09:48'], ['Hillsdale', '09:51'], ['Hayward Park', '09:54'], ['San Mateo', '09:57'], ['Burlingame', '10:00'], ['Broadway', '10:03'], ['Millbrae', '10:08'], ['San Bruno', '10:12'], ['So. San Francisco', '10:17'], ['Bayshore', '10:23'], ['22nd Street', '10:28'], ['San Francisco', '10:36']]
  427: [['San Jose', '10:00'], ['Santa Clara', '10:05'], ['Lawrence', '10:10'], ['Sunnyvale', '10:14'], ['Mountain View', '10:19'], ['San Antonio', '10:23'], ['California Ave', '10:27'], ['Palo Alto', '10:31'], ['Menlo Park', '10:34'], ['Atherton', '10:37'], ['Redwood City', '10:41'], ['San Carlos', '10:45'], ['Belmont', '10:48'], ['Hillsdale', '10:51'], ['Hayward Park', '10:54'], ['San Mateo', '10:57'], ['Burlingame', '11:00'], ['Broadway', '11:03'], ['Millbrae', '11:08'], ['San Bruno', '11:12'], ['So. San Francisco', '11:17'], ['Bayshore', '11:23'], ['22nd Street', '11:28'], ['San Francisco', '11:36']]
  801: [['San Jose', '10:35'], ['Sunnyvale', '10:45'], ['Mountain View', '10:50'], ['Palo Alto', '10:58'], ['Redwood City', '11:04'], ['Hillsdale', '11:10'], ['San Mateo', '11:14'], ['Millbrae', '11:21'], ['San Francisco', '11:39']]
  429: [['San Jose', '11:00'], ['Santa Clara', '11:05'], ['Lawrence', '11:10'], ['Sunnyvale', '11:14'], ['Mountain View', '11:19'], ['San Antonio', '11:23'], ['California Ave', '11:27'], ['Palo Alto', '11:31'], ['Menlo Park', '11:34'], ['Atherton', '11:37'], ['Redwood City', '11:41'], ['San Carlos', '11:45'], ['Belmont', '11:48'], ['Hillsdale', '11:51'], ['Hayward Park', '11:54'], ['San Mateo', '11:57'], ['Burlingame', '12:00'], ['Broadway', '12:03'], ['Millbrae', '12:08'], ['San Bruno', '12:12'], ['So. San Francisco', '12:17'], ['Bayshore', '12:23'], ['22nd Street', '12:28'], ['San Francisco', '12:36']]
  431: [['San Jose', '12:00'], ['Santa Clara', '12:05'], ['Lawrence', '12:10'], ['Sunnyvale', '12:14'], ['Mountain View', '12:19'], ['San Antonio', '12:23'], ['California Ave', '12:27'], ['Palo Alto', '12:31'], ['Menlo Park', '12:34'], ['Atherton', '12:37'], ['Redwood City', '12:41'], ['San Carlos', '12:45'], ['Belmont', '12:48'], ['Hillsdale', '12:51'], ['Hayward Park', '12:54'], ['San Mateo', '12:57'], ['Burlingame', '13:00'], ['Broadway', '13:03'], ['Millbrae', '13:08'], ['San Bruno', '13:12'], ['So. San Francisco', '13:17'], ['Bayshore', '13:23'], ['22nd Street', '13:28'], ['San Francisco', '13:36']]
  433: [['San Jose', '13:00'], ['Santa Clara', '13:05'], ['Lawrence', '13:10'], ['Sunnyvale', '13:14'], ['Mountain View', '13:19'], ['San Antonio', '13:23'], ['California Ave', '13:27'], ['Palo Alto', '13:31'], ['Menlo Park', '13:34'], ['Atherton', '13:37'], ['Redwood City', '13:41'], ['San Carlos', '13:45'], ['Belmont', '13:48'], ['Hillsdale', '13:51'], ['Hayward Park', '13:54'], ['San Mateo', '13:57'], ['Burlingame', '14:00'], ['Broadway', '14:03'], ['Millbrae', '14:08'], ['San Bruno', '14:12'], ['So. San Francisco', '14:17'], ['Bayshore', '14:23'], ['22nd Street', '14:28'], ['San Francisco', '14:36']]
  435: [['San Jose', '14:00'], ['Santa Clara', '14:05'], ['Lawrence', '14:10'], ['Sunnyvale', '14:14'], ['Mountain View', '14:19'], ['San Antonio', '14:23'], ['California Ave', '14:27'], ['Palo Alto', '14:31'], ['Menlo Park', '14:34'], ['Atherton', '14:37'], ['Redwood City', '14:41'], ['San Carlos', '14:45'], ['Belmont', '14:48'], ['Hillsdale', '14:51'], ['Hayward Park', '14:54'], ['San Mateo', '14:57'], ['Burlingame', '15:00'], ['Broadway', '15:03'], ['Millbrae', '15:08'], ['San Bruno', '15:12'], ['So. San Francisco', '15:17'], ['Bayshore', '15:23'], ['22nd Street', '15:28'], ['San Francisco', '15:36']]
  437: [['San Jose', '15:00'], ['Santa Clara', '15:05'], ['Lawrence', '15:10'], ['Sunnyvale', '15:14'], ['Mountain View', '15:19'], ['San Antonio', '15:23'], ['California Ave', '15:27'], ['Palo Alto', '15:31'], ['Menlo Park', '15:34'], ['Atherton', '15:37'], ['Redwood City', '15:41'], ['San Carlos', '15:45'], ['Belmont', '15:48'], ['Hillsdale', '15:51'], ['Hayward Park', '15:54'], ['San Mateo', '15:57'], ['Burlingame', '16:00'], ['Broadway', '16:03'], ['Millbrae', '16:08'], ['San Bruno', '16:12'], ['So. San Francisco', '16:17'], ['Bayshore', '16:23'], ['22nd Street', '16:28'], ['San Francisco', '16:36']]
  439: [['San Jose', '16:00'], ['Santa Clara', '16:05'], ['Lawrence', '16:10'], ['Sunnyvale', '16:14'], ['Mountain View', '16:19'], ['San Antonio', '16:23'], ['California Ave', '16:27'], ['Palo Alto', '16:31'], ['Menlo Park', '16:34'], ['Atherton', '16:37'], ['Redwood City', '16:41'], ['San Carlos', '16:45'], ['Belmont', '16:48'], ['Hillsdale', '16:51'], ['Hayward Park', '16:54'], ['San Mateo', '16:57'], ['Burlingame', '17:00'], ['Broadway', '17:03'], ['Millbrae', '17:08'], ['San Bruno', '17:12'], ['So. San Francisco', '17:17'], ['Bayshore', '17:23'], ['22nd Street', '17:28'], ['San Francisco', '17:36']]
  441: [['San Jose', '17:00'], ['Santa Clara', '17:05'], ['Lawrence', '17:10'], ['Sunnyvale', '17:14'], ['Mountain View', '17:19'], ['San Antonio', '17:23'], ['California Ave', '17:27'], ['Palo Alto', '17:31'], ['Menlo Park', '17:34'], ['Atherton', '17:37'], ['Redwood City', '17:41'], ['San Carlos', '17:45'], ['Belmont', '17:48'], ['Hillsdale', '17:51'], ['Hayward Park', '17:54'], ['San Mateo', '17:57'], ['Burlingame', '18:00'], ['Broadway', '18:03'], ['Millbrae', '18:08'], ['San Bruno', '18:12'], ['So. San Francisco', '18:17'], ['Bayshore', '18:23'], ['22nd Street', '18:28'], ['San Francisco', '18:36']]
  803: [['San Jose', '17:35'], ['Sunnyvale', '17:45'], ['Mountain View', '17:50'], ['Palo Alto', '17:58'], ['Redwood City', '18:04'], ['Hillsdale', '18:10'], ['San Mateo', '06:14'], ['Millbrae', '18:21'], ['San Francisco', '18:39']]
  443: [['San Jose', '18:00'], ['Santa Clara', '18:05'], ['Lawrence', '18:10'], ['Sunnyvale', '18:14'], ['Mountain View', '18:19'], ['San Antonio', '18:23'], ['California Ave', '18:27'], ['Palo Alto', '18:31'], ['Menlo Park', '18:34'], ['Atherton', '18:37'], ['Redwood City', '18:41'], ['San Carlos', '18:45'], ['Belmont', '18:48'], ['Hillsdale', '18:51'], ['Hayward Park', '18:54'], ['San Mateo', '18:57'], ['Burlingame', '19:00'], ['Broadway', '19:03'], ['Millbrae', '19:08'], ['San Bruno', '19:12'], ['So. San Francisco', '19:17'], ['Bayshore', '19:23'], ['22nd Street', '19:28'], ['San Francisco', '19:36']]
  445: [['San Jose', '19:00'], ['Santa Clara', '19:05'], ['Lawrence', '19:10'], ['Sunnyvale', '19:14'], ['Mountain View', '19:19'], ['San Antonio', '19:23'], ['California Ave', '19:27'], ['Palo Alto', '19:31'], ['Menlo Park', '19:34'], ['Atherton', '19:37'], ['Redwood City', '19:41'], ['San Carlos', '19:45'], ['Belmont', '19:48'], ['Hillsdale', '19:51'], ['Hayward Park', '19:54'], ['San Mateo', '19:57'], ['Burlingame', '20:00'], ['Broadway', '20:03'], ['Millbrae', '20:08'], ['San Bruno', '20:12'], ['So. San Francisco', '20:17'], ['Bayshore', '20:23'], ['22nd Street', '20:28'], ['San Francisco', '20:36']]
  447: [['San Jose', '20:00'], ['Santa Clara', '20:05'], ['Lawrence', '20:10'], ['Sunnyvale', '20:14'], ['Mountain View', '20:19'], ['San Antonio', '20:23'], ['California Ave', '20:27'], ['Palo Alto', '20:31'], ['Menlo Park', '20:34'], ['Atherton', '20:37'], ['Redwood City', '20:41'], ['San Carlos', '20:45'], ['Belmont', '20:48'], ['Hillsdale', '20:51'], ['Hayward Park', '20:54'], ['San Mateo', '20:57'], ['Burlingame', '21:00'], ['Broadway', '21:03'], ['Millbrae', '21:08'], ['San Bruno', '21:12'], ['So. San Francisco', '21:17'], ['Bayshore', '21:23'], ['22nd Street', '21:28'], ['San Francisco', '21:36']]
  449: [['San Jose', '21:00'], ['Santa Clara', '21:05'], ['Lawrence', '21:10'], ['Sunnyvale', '21:14'], ['Mountain View', '21:19'], ['San Antonio', '21:23'], ['California Ave', '21:27'], ['Palo Alto', '21:31'], ['Menlo Park', '21:34'], ['Atherton', '21:37'], ['Redwood City', '21:41'], ['San Carlos', '21:45'], ['Belmont', '21:48'], ['Hillsdale', '21:51'], ['Hayward Park', '21:54'], ['San Mateo', '21:57'], ['Burlingame', '22:00'], ['Broadway', '22:03'], ['Millbrae', '22:08'], ['San Bruno', '22:12'], ['So. San Francisco', '22:17'], ['Bayshore', '22:23'], ['22nd Street', '22:28'], ['San Francisco', '22:36']]
  451: [['San Jose', '22:30'], ['Santa Clara', '22:35'], ['Lawrence', '22:40'], ['Sunnyvale', '22:44'], ['Mountain View', '22:49'], ['San Antonio', '22:53'], ['California Ave', '22:57'], ['Palo Alto', '23:01'], ['Menlo Park', '23:04'], ['Atherton', '23:07'], ['Redwood City', '23:11'], ['San Carlos', '23:15'], ['Belmont', '23:18'], ['Hillsdale', '23:21'], ['Hayward Park', '23:24'], ['San Mateo', '23:27'], ['Burlingame', '23:30'], ['Broadway', '23:33'], ['Millbrae', '23:38'], ['San Bruno', '23:42'], ['So. San Francisco', '23:47'], ['Bayshore', '23:53'], ['22nd Street', '23:58'], ['San Francisco', '24:06']]
  422: [['22nd Street', '08:15'], ['Bayshore', '08:20'], ['So. San Francisco', '08:25'], ['San Bruno', '08:31'], ['Millbrae', '08:35'], ['Broadway', '08:39'], ['Burlingame', '08:43'], ['San Mateo', '08:45'], ['Hayward Park', '08:49'], ['Hillsdale', '08:52'], ['Belmont', '08:55'], ['San Carlos', '08:58'], ['Redwood City', '09:01'], ['Atherton', '09:07'], ['Menlo Park', '09:11'], ['Palo Alto', '09:14'], ['California Ave', '09:17'], ['San Antonio', '09:21'], ['Mountain View', '09:25'], ['Sunnyvale', '09:29'], ['Lawrence', '09:34'], ['Santa Clara', '09:38'], ['San Jose', '09:43']]
  424: [['San Francisco', '09:15'], ['22nd Street', '09:20'], ['Bayshore', '09:25'], ['So. San Francisco', '09:31'], ['San Bruno', '09:35'], ['Millbrae', '09:39'], ['Broadway', '09:43'], ['Burlingame', '09:45'], ['San Mateo', '09:49'], ['Hayward Park', '09:52'], ['Hillsdale', '09:55'], ['Belmont', '09:58'], ['San Carlos', '10:01'], ['Redwood City', '10:07'], ['Atherton', '10:11'], ['Menlo Park', '10:14'], ['Palo Alto', '10:17'], ['California Ave', '10:21'], ['San Antonio', '10:25'], ['Mountain View', '10:29'], ['Sunnyvale', '10:34'], ['Lawrence', '10:38'], ['Santa Clara', '10:43'], ['San Jose', '10:51']]
  426: [['San Francisco', '10:15'], ['22nd Street', '10:20'], ['Bayshore', '10:25'], ['So. San Francisco', '10:31'], ['San Bruno', '10:35'], ['Millbrae', '10:39'], ['Broadway', '10:43'], ['Burlingame', '10:45'], ['San Mateo', '10:49'], ['Hayward Park', '10:52'], ['Hillsdale', '10:55'], ['Belmont', '10:58'], ['San Carlos', '11:01'], ['Redwood City', '11:07'], ['Atherton', '11:11'], ['Menlo Park', '11:14'], ['Palo Alto', '11:17'], ['California Ave', '11:21'], ['San Antonio', '11:25'], ['Mountain View', '11:29'], ['Sunnyvale', '11:34'], ['Lawrence', '11:38'], ['Santa Clara', '11:43'], ['San Jose', '11:51']]
  428: [['San Francisco', '11:15'], ['22nd Street', '11:20'], ['Bayshore', '11:25'], ['So. San Francisco', '11:31'], ['San Bruno', '11:35'], ['Millbrae', '11:39'], ['Broadway', '11:43'], ['Burlingame', '11:45'], ['San Mateo', '11:49'], ['Hayward Park', '11:52'], ['Hillsdale', '11:55'], ['Belmont', '11:58'], ['San Carlos', '12:01'], ['Redwood City', '12:07'], ['Atherton', '12:11'], ['Menlo Park', '12:14'], ['Palo Alto', '12:17'], ['California Ave', '12:21'], ['San Antonio', '12:25'], ['Mountain View', '12:29'], ['Sunnyvale', '12:34'], ['Lawrence', '12:38'], ['Santa Clara', '12:43'], ['San Jose', '12:51']]
  802: [['San Francisco', '11:59'], ['Millbrae', '12:15'], ['San Mateo', '12:21'], ['Hillsdale', '12:25'], ['Redwood City', '12:33'], ['Palo Alto', '12:39'], ['Mountain View', '12:47'], ['Sunnyvale', '12:52'], ['San Jose', '13:03']]
  430: [['San Francisco', '12:15'], ['22nd Street', '12:20'], ['Bayshore', '12:25'], ['So. San Francisco', '12:31'], ['San Bruno', '12:35'], ['Millbrae', '12:39'], ['Broadway', '12:43'], ['Burlingame', '12:45'], ['San Mateo', '12:49'], ['Hayward Park', '12:52'], ['Hillsdale', '12:55'], ['Belmont', '12:58'], ['San Carlos', '13:01'], ['Redwood City', '13:07'], ['Atherton', '13:11'], ['Menlo Park', '13:14'], ['Palo Alto', '13:17'], ['California Ave', '13:21'], ['San Antonio', '13:25'], ['Mountain View', '13:29'], ['Sunnyvale', '13:34'], ['Lawrence', '13:38'], ['Santa Clara', '13:43'], ['San Jose', '13:51']]
  432: [['San Francisco', '13:15'], ['22nd Street', '13:20'], ['Bayshore', '13:25'], ['So. San Francisco', '13:31'], ['San Bruno', '13:35'], ['Millbrae', '13:39'], ['Broadway', '13:43'], ['Burlingame', '13:45'], ['San Mateo', '13:49'], ['Hayward Park', '13:52'], ['Hillsdale', '13:55'], ['Belmont', '13:58'], ['San Carlos', '14:01'], ['Redwood City', '14:07'], ['Atherton', '14:11'], ['Menlo Park', '14:14'], ['Palo Alto', '14:17'], ['California Ave', '14:21'], ['San Antonio', '14:25'], ['Mountain View', '14:29'], ['Sunnyvale', '14:34'], ['Lawrence', '14:38'], ['Santa Clara', '14:43'], ['San Jose', '14:51']]
  434: [['San Francisco', '14:15'], ['22nd Street', '14:20'], ['Bayshore', '14:25'], ['So. San Francisco', '14:31'], ['San Bruno', '14:35'], ['Millbrae', '14:39'], ['Broadway', '14:43'], ['Burlingame', '14:45'], ['San Mateo', '14:49'], ['Hayward Park', '14:52'], ['Hillsdale', '14:55'], ['Belmont', '14:58'], ['San Carlos', '15:01'], ['Redwood City', '15:07'], ['Atherton', '15:11'], ['Menlo Park', '15:14'], ['Palo Alto', '15:17'], ['California Ave', '15:21'], ['San Antonio', '15:25'], ['Mountain View', '15:29'], ['Sunnyvale', '15:34'], ['Lawrence', '15:38'], ['Santa Clara', '15:43'], ['San Jose', '15:51']]
  436: [['San Francisco', '15:15'], ['22nd Street', '15:20'], ['Bayshore', '15:25'], ['So. San Francisco', '15:31'], ['San Bruno', '15:35'], ['Millbrae', '15:39'], ['Broadway', '15:43'], ['Burlingame', '15:45'], ['San Mateo', '15:49'], ['Hayward Park', '15:52'], ['Hillsdale', '15:55'], ['Belmont', '15:58'], ['San Carlos', '16:01'], ['Redwood City', '16:07'], ['Atherton', '16:11'], ['Menlo Park', '16:14'], ['Palo Alto', '16:17'], ['California Ave', '16:21'], ['San Antonio', '16:25'], ['Mountain View', '16:29'], ['Sunnyvale', '16:34'], ['Lawrence', '16:38'], ['Santa Clara', '16:43'], ['San Jose', '16:51']]
  438: [['San Francisco', '16:15'], ['22nd Street', '16:20'], ['Bayshore', '16:25'], ['So. San Francisco', '16:31'], ['San Bruno', '16:35'], ['Millbrae', '16:39'], ['Broadway', '16:43'], ['Burlingame', '16:45'], ['San Mateo', '16:49'], ['Hayward Park', '16:52'], ['Hillsdale', '16:55'], ['Belmont', '16:58'], ['San Carlos', '17:01'], ['Redwood City', '17:07'], ['Atherton', '17:11'], ['Menlo Park', '17:14'], ['Palo Alto', '17:17'], ['California Ave', '17:21'], ['San Antonio', '17:25'], ['Mountain View', '17:29'], ['Sunnyvale', '17:34'], ['Lawrence', '17:38'], ['Santa Clara', '17:43'], ['San Jose', '17:51']]
  440: [['San Francisco', '17:15'], ['22nd Street', '17:20'], ['Bayshore', '17:25'], ['So. San Francisco', '17:31'], ['San Bruno', '17:35'], ['Millbrae', '17:39'], ['Broadway', '17:43'], ['Burlingame', '17:45'], ['San Mateo', '17:49'], ['Hayward Park', '17:52'], ['Hillsdale', '17:55'], ['Belmont', '17:58'], ['San Carlos', '18:01'], ['Redwood City', '18:07'], ['Atherton', '18:11'], ['Menlo Park', '18:14'], ['Palo Alto', '18:17'], ['California Ave', '18:21'], ['San Antonio', '18:25'], ['Mountain View', '18:29'], ['Sunnyvale', '18:34'], ['Lawrence', '18:38'], ['Santa Clara', '18:43'], ['San Jose', '18:51']]
  442: [['San Francisco', '18:15'], ['22nd Street', '18:20'], ['Bayshore', '18:25'], ['So. San Francisco', '18:31'], ['San Bruno', '18:35'], ['Millbrae', '18:39'], ['Broadway', '18:43'], ['Burlingame', '18:45'], ['San Mateo', '18:49'], ['Hayward Park', '18:52'], ['Hillsdale', '18:55'], ['Belmont', '18:58'], ['San Carlos', '19:01'], ['Redwood City', '19:07'], ['Atherton', '19:11'], ['Menlo Park', '19:14'], ['Palo Alto', '19:17'], ['California Ave', '19:21'], ['San Antonio', '19:25'], ['Mountain View', '19:29'], ['Sunnyvale', '19:34'], ['Lawrence', '19:38'], ['Santa Clara', '19:43'], ['San Jose', '19:51']]
  804: [['San Francisco', '18:59'], ['Millbrae', '19:15'], ['San Mateo', '19:21'], ['Hillsdale', '19:25'], ['Redwood City', '19:33'], ['Palo Alto', '19:39'], ['Mountain View', '19:47'], ['Sunnyvale', '19:52'], ['San Jose', '20:03']]
  444: [['San Francisco', '19:15'], ['22nd Street', '19:20'], ['Bayshore', '19:25'], ['So. San Francisco', '19:31'], ['San Bruno', '19:35'], ['Millbrae', '19:39'], ['Broadway', '19:43'], ['Burlingame', '19:45'], ['San Mateo', '19:49'], ['Hayward Park', '19:52'], ['Hillsdale', '19:55'], ['Belmont', '19:58'], ['San Carlos', '20:01'], ['Redwood City', '20:07'], ['Atherton', '20:11'], ['Menlo Park', '20:14'], ['Palo Alto', '20:17'], ['California Ave', '20:21'], ['San Antonio', '20:25'], ['Mountain View', '20:29'], ['Sunnyvale', '20:34'], ['Lawrence', '20:38'], ['Santa Clara', '20:43'], ['San Jose', '20:51']]
  446: [['San Francisco', '20:15'], ['22nd Street', '20:20'], ['Bayshore', '20:25'], ['So. San Francisco', '20:31'], ['San Bruno', '20:35'], ['Millbrae', '20:39'], ['Broadway', '20:43'], ['Burlingame', '20:45'], ['San Mateo', '20:49'], ['Hayward Park', '20:52'], ['Hillsdale', '20:55'], ['Belmont', '20:58'], ['San Carlos', '21:01'], ['Redwood City', '21:07'], ['Atherton', '21:11'], ['Menlo Park', '21:14'], ['Palo Alto', '21:17'], ['California Ave', '21:21'], ['San Antonio', '21:25'], ['Mountain View', '21:29'], ['Sunnyvale', '21:34'], ['Lawrence', '21:38'], ['Santa Clara', '21:43'], ['San Jose', '21:51']]
  448: [['San Francisco', '21:15'], ['22nd Street', '21:20'], ['Bayshore', '21:25'], ['So. San Francisco', '21:31'], ['San Bruno', '21:35'], ['Millbrae', '21:39'], ['Broadway', '21:43'], ['Burlingame', '21:45'], ['San Mateo', '21:49'], ['Hayward Park', '21:52'], ['Hillsdale', '21:55'], ['Belmont', '21:58'], ['San Carlos', '22:01'], ['Redwood City', '22:07'], ['Atherton', '22:11'], ['Menlo Park', '22:14'], ['Palo Alto', '22:17'], ['California Ave', '22:21'], ['San Antonio', '22:25'], ['Mountain View', '22:29'], ['Sunnyvale', '22:34'], ['Lawrence', '22:38'], ['Santa Clara', '22:43'], ['San Jose', '22:51']]
  450: [['San Francisco', '22:15'], ['22nd Street', '22:20'], ['Bayshore', '22:25'], ['So. San Francisco', '22:31'], ['San Bruno', '22:35'], ['Millbrae', '22:39'], ['Broadway', '22:43'], ['Burlingame', '22:45'], ['San Mateo', '22:49'], ['Hayward Park', '22:52'], ['Hillsdale', '22:55'], ['Belmont', '22:58'], ['San Carlos', '23:01'], ['Redwood City', '23:07'], ['Atherton', '23:11'], ['Menlo Park', '23:14'], ['Palo Alto', '23:17'], ['California Ave', '23:21'], ['San Antonio', '23:25'], ['Mountain View', '23:29'], ['Sunnyvale', '23:34'], ['Lawrence', '23:38'], ['Santa Clara', '23:43'], ['San Jose', '23:51']]
  454: [['San Francisco', '24:01'], ['22nd Street', '24:06'], ['Bayshore', '24:11'], ['So. San Francisco', '24:17'], ['San Bruno', '24:21'], ['Millbrae', '24:25'], ['Broadway', '24:29'], ['Burlingame', '24:31'], ['San Mateo', '24:35'], ['Hayward Park', '24:38'], ['Hillsdale', '24:41'], ['Belmont', '24:44'], ['San Carlos', '24:47'], ['Redwood City', '24:53'], ['Atherton', '24:57'], ['Menlo Park', '25:00'], ['Palo Alto', '25:03'], ['California Ave', '25:07'], ['San Antonio', '25:11'], ['Mountain View', '25:15'], ['Sunnyvale', '25:20'], ['Lawrence', '25:24'], ['Santa Clara', '25:29'], ['San Jose', '25:37']]

SCHEDULES['sunday'] =
  423: [['San Jose', '08:00'], ['Santa Clara', '08:05'], ['Lawrence', '08:10'], ['Sunnyvale', '08:14'], ['Mountain View', '08:19'], ['San Antonio', '08:23'], ['California Ave', '08:27'], ['Palo Alto', '08:31'], ['Menlo Park', '08:34'], ['Atherton', '08:37'], ['Redwood City', '08:41'], ['San Carlos', '08:45'], ['Belmont', '08:48'], ['Hillsdale', '08:51'], ['Hayward Park', '08:54'], ['San Mateo', '08:57'], ['Burlingame', '09:00'], ['Broadway', '09:03'], ['Millbrae', '09:08'], ['San Bruno', '09:12'], ['So. San Francisco', '09:17'], ['Bayshore', '09:23'], ['22nd Street', '09:28'], ['San Francisco', '09:36']]
  425: [['San Jose', '09:00'], ['Santa Clara', '09:05'], ['Lawrence', '09:10'], ['Sunnyvale', '09:14'], ['Mountain View', '09:19'], ['San Antonio', '09:23'], ['California Ave', '09:27'], ['Palo Alto', '09:31'], ['Menlo Park', '09:34'], ['Atherton', '09:37'], ['Redwood City', '09:41'], ['San Carlos', '09:45'], ['Belmont', '09:48'], ['Hillsdale', '09:51'], ['Hayward Park', '09:54'], ['San Mateo', '09:57'], ['Burlingame', '10:00'], ['Broadway', '10:03'], ['Millbrae', '10:08'], ['San Bruno', '10:12'], ['So. San Francisco', '10:17'], ['Bayshore', '10:23'], ['22nd Street', '10:28'], ['San Francisco', '10:36']]
  427: [['San Jose', '10:00'], ['Santa Clara', '10:05'], ['Lawrence', '10:10'], ['Sunnyvale', '10:14'], ['Mountain View', '10:19'], ['San Antonio', '10:23'], ['California Ave', '10:27'], ['Palo Alto', '10:31'], ['Menlo Park', '10:34'], ['Atherton', '10:37'], ['Redwood City', '10:41'], ['San Carlos', '10:45'], ['Belmont', '10:48'], ['Hillsdale', '10:51'], ['Hayward Park', '10:54'], ['San Mateo', '10:57'], ['Burlingame', '11:00'], ['Broadway', '11:03'], ['Millbrae', '11:08'], ['San Bruno', '11:12'], ['So. San Francisco', '11:17'], ['Bayshore', '11:23'], ['22nd Street', '11:28'], ['San Francisco', '11:36']]
  801: [['San Jose', '10:35'], ['Sunnyvale', '10:45'], ['Mountain View', '10:50'], ['Palo Alto', '10:58'], ['Redwood City', '11:04'], ['Hillsdale', '11:10'], ['San Mateo', '11:14'], ['Millbrae', '11:21'], ['San Francisco', '11:39']]
  429: [['San Jose', '11:00'], ['Santa Clara', '11:05'], ['Lawrence', '11:10'], ['Sunnyvale', '11:14'], ['Mountain View', '11:19'], ['San Antonio', '11:23'], ['California Ave', '11:27'], ['Palo Alto', '11:31'], ['Menlo Park', '11:34'], ['Atherton', '11:37'], ['Redwood City', '11:41'], ['San Carlos', '11:45'], ['Belmont', '11:48'], ['Hillsdale', '11:51'], ['Hayward Park', '11:54'], ['San Mateo', '11:57'], ['Burlingame', '12:00'], ['Broadway', '12:03'], ['Millbrae', '12:08'], ['San Bruno', '12:12'], ['So. San Francisco', '12:17'], ['Bayshore', '12:23'], ['22nd Street', '12:28'], ['San Francisco', '12:36']]
  431: [['San Jose', '12:00'], ['Santa Clara', '12:05'], ['Lawrence', '12:10'], ['Sunnyvale', '12:14'], ['Mountain View', '12:19'], ['San Antonio', '12:23'], ['California Ave', '12:27'], ['Palo Alto', '12:31'], ['Menlo Park', '12:34'], ['Atherton', '12:37'], ['Redwood City', '12:41'], ['San Carlos', '12:45'], ['Belmont', '12:48'], ['Hillsdale', '12:51'], ['Hayward Park', '12:54'], ['San Mateo', '12:57'], ['Burlingame', '13:00'], ['Broadway', '13:03'], ['Millbrae', '13:08'], ['San Bruno', '13:12'], ['So. San Francisco', '13:17'], ['Bayshore', '13:23'], ['22nd Street', '13:28'], ['San Francisco', '13:36']]
  433: [['San Jose', '13:00'], ['Santa Clara', '13:05'], ['Lawrence', '13:10'], ['Sunnyvale', '13:14'], ['Mountain View', '13:19'], ['San Antonio', '13:23'], ['California Ave', '13:27'], ['Palo Alto', '13:31'], ['Menlo Park', '13:34'], ['Atherton', '13:37'], ['Redwood City', '13:41'], ['San Carlos', '13:45'], ['Belmont', '13:48'], ['Hillsdale', '13:51'], ['Hayward Park', '13:54'], ['San Mateo', '13:57'], ['Burlingame', '14:00'], ['Broadway', '14:03'], ['Millbrae', '14:08'], ['San Bruno', '14:12'], ['So. San Francisco', '14:17'], ['Bayshore', '14:23'], ['22nd Street', '14:28'], ['San Francisco', '14:36']]
  435: [['San Jose', '14:00'], ['Santa Clara', '14:05'], ['Lawrence', '14:10'], ['Sunnyvale', '14:14'], ['Mountain View', '14:19'], ['San Antonio', '14:23'], ['California Ave', '14:27'], ['Palo Alto', '14:31'], ['Menlo Park', '14:34'], ['Atherton', '14:37'], ['Redwood City', '14:41'], ['San Carlos', '14:45'], ['Belmont', '14:48'], ['Hillsdale', '14:51'], ['Hayward Park', '14:54'], ['San Mateo', '14:57'], ['Burlingame', '15:00'], ['Broadway', '15:03'], ['Millbrae', '15:08'], ['San Bruno', '15:12'], ['So. San Francisco', '15:17'], ['Bayshore', '15:23'], ['22nd Street', '15:28'], ['San Francisco', '15:36']]
  437: [['San Jose', '15:00'], ['Santa Clara', '15:05'], ['Lawrence', '15:10'], ['Sunnyvale', '15:14'], ['Mountain View', '15:19'], ['San Antonio', '15:23'], ['California Ave', '15:27'], ['Palo Alto', '15:31'], ['Menlo Park', '15:34'], ['Atherton', '15:37'], ['Redwood City', '15:41'], ['San Carlos', '15:45'], ['Belmont', '15:48'], ['Hillsdale', '15:51'], ['Hayward Park', '15:54'], ['San Mateo', '15:57'], ['Burlingame', '16:00'], ['Broadway', '16:03'], ['Millbrae', '16:08'], ['San Bruno', '16:12'], ['So. San Francisco', '16:17'], ['Bayshore', '16:23'], ['22nd Street', '16:28'], ['San Francisco', '16:36']]
  439: [['San Jose', '16:00'], ['Santa Clara', '16:05'], ['Lawrence', '16:10'], ['Sunnyvale', '16:14'], ['Mountain View', '16:19'], ['San Antonio', '16:23'], ['California Ave', '16:27'], ['Palo Alto', '16:31'], ['Menlo Park', '16:34'], ['Atherton', '16:37'], ['Redwood City', '16:41'], ['San Carlos', '16:45'], ['Belmont', '16:48'], ['Hillsdale', '16:51'], ['Hayward Park', '16:54'], ['San Mateo', '16:57'], ['Burlingame', '17:00'], ['Broadway', '17:03'], ['Millbrae', '17:08'], ['San Bruno', '17:12'], ['So. San Francisco', '17:17'], ['Bayshore', '17:23'], ['22nd Street', '17:28'], ['San Francisco', '17:36']]
  441: [['San Jose', '17:00'], ['Santa Clara', '17:05'], ['Lawrence', '17:10'], ['Sunnyvale', '17:14'], ['Mountain View', '17:19'], ['San Antonio', '17:23'], ['California Ave', '17:27'], ['Palo Alto', '17:31'], ['Menlo Park', '17:34'], ['Atherton', '17:37'], ['Redwood City', '17:41'], ['San Carlos', '17:45'], ['Belmont', '17:48'], ['Hillsdale', '17:51'], ['Hayward Park', '17:54'], ['San Mateo', '17:57'], ['Burlingame', '18:00'], ['Broadway', '18:03'], ['Millbrae', '18:08'], ['San Bruno', '18:12'], ['So. San Francisco', '18:17'], ['Bayshore', '18:23'], ['22nd Street', '18:28'], ['San Francisco', '18:36']]
  803: [['San Jose', '17:35'], ['Sunnyvale', '17:45'], ['Mountain View', '17:50'], ['Palo Alto', '17:58'], ['Redwood City', '18:04'], ['Hillsdale', '18:10'], ['San Mateo', '06:14'], ['Millbrae', '18:21'], ['San Francisco', '18:39']]
  443: [['San Jose', '18:00'], ['Santa Clara', '18:05'], ['Lawrence', '18:10'], ['Sunnyvale', '18:14'], ['Mountain View', '18:19'], ['San Antonio', '18:23'], ['California Ave', '18:27'], ['Palo Alto', '18:31'], ['Menlo Park', '18:34'], ['Atherton', '18:37'], ['Redwood City', '18:41'], ['San Carlos', '18:45'], ['Belmont', '18:48'], ['Hillsdale', '18:51'], ['Hayward Park', '18:54'], ['San Mateo', '18:57'], ['Burlingame', '19:00'], ['Broadway', '19:03'], ['Millbrae', '19:08'], ['San Bruno', '19:12'], ['So. San Francisco', '19:17'], ['Bayshore', '19:23'], ['22nd Street', '19:28'], ['San Francisco', '19:36']]
  445: [['San Jose', '19:00'], ['Santa Clara', '19:05'], ['Lawrence', '19:10'], ['Sunnyvale', '19:14'], ['Mountain View', '19:19'], ['San Antonio', '19:23'], ['California Ave', '19:27'], ['Palo Alto', '19:31'], ['Menlo Park', '19:34'], ['Atherton', '19:37'], ['Redwood City', '19:41'], ['San Carlos', '19:45'], ['Belmont', '19:48'], ['Hillsdale', '19:51'], ['Hayward Park', '19:54'], ['San Mateo', '19:57'], ['Burlingame', '20:00'], ['Broadway', '20:03'], ['Millbrae', '20:08'], ['San Bruno', '20:12'], ['So. San Francisco', '20:17'], ['Bayshore', '20:23'], ['22nd Street', '20:28'], ['San Francisco', '20:36']]
  447: [['San Jose', '20:00'], ['Santa Clara', '20:05'], ['Lawrence', '20:10'], ['Sunnyvale', '20:14'], ['Mountain View', '20:19'], ['San Antonio', '20:23'], ['California Ave', '20:27'], ['Palo Alto', '20:31'], ['Menlo Park', '20:34'], ['Atherton', '20:37'], ['Redwood City', '20:41'], ['San Carlos', '20:45'], ['Belmont', '20:48'], ['Hillsdale', '20:51'], ['Hayward Park', '20:54'], ['San Mateo', '20:57'], ['Burlingame', '21:00'], ['Broadway', '21:03'], ['Millbrae', '21:08'], ['San Bruno', '21:12'], ['So. San Francisco', '21:17'], ['Bayshore', '21:23'], ['22nd Street', '21:28'], ['San Francisco', '21:36']]
  449: [['San Jose', '21:00'], ['Santa Clara', '21:05'], ['Lawrence', '21:10'], ['Sunnyvale', '21:14'], ['Mountain View', '21:19'], ['San Antonio', '21:23'], ['California Ave', '21:27'], ['Palo Alto', '21:31'], ['Menlo Park', '21:34'], ['Atherton', '21:37'], ['Redwood City', '21:41'], ['San Carlos', '21:45'], ['Belmont', '21:48'], ['Hillsdale', '21:51'], ['Hayward Park', '21:54'], ['San Mateo', '21:57'], ['Burlingame', '22:00'], ['Broadway', '22:03'], ['Millbrae', '22:08'], ['San Bruno', '22:12'], ['So. San Francisco', '22:17'], ['Bayshore', '22:23'], ['22nd Street', '22:28'], ['San Francisco', '22:36']]
  422: [['22nd Street', '08:15'], ['Bayshore', '08:20'], ['So. San Francisco', '08:25'], ['San Bruno', '08:31'], ['Millbrae', '08:35'], ['Broadway', '08:39'], ['Burlingame', '08:43'], ['San Mateo', '08:45'], ['Hayward Park', '08:49'], ['Hillsdale', '08:52'], ['Belmont', '08:55'], ['San Carlos', '08:58'], ['Redwood City', '09:01'], ['Atherton', '09:07'], ['Menlo Park', '09:11'], ['Palo Alto', '09:14'], ['California Ave', '09:17'], ['San Antonio', '09:21'], ['Mountain View', '09:25'], ['Sunnyvale', '09:29'], ['Lawrence', '09:34'], ['Santa Clara', '09:38'], ['San Jose', '09:43']]
  424: [['San Francisco', '09:15'], ['22nd Street', '09:20'], ['Bayshore', '09:25'], ['So. San Francisco', '09:31'], ['San Bruno', '09:35'], ['Millbrae', '09:39'], ['Broadway', '09:43'], ['Burlingame', '09:45'], ['San Mateo', '09:49'], ['Hayward Park', '09:52'], ['Hillsdale', '09:55'], ['Belmont', '09:58'], ['San Carlos', '10:01'], ['Redwood City', '10:07'], ['Atherton', '10:11'], ['Menlo Park', '10:14'], ['Palo Alto', '10:17'], ['California Ave', '10:21'], ['San Antonio', '10:25'], ['Mountain View', '10:29'], ['Sunnyvale', '10:34'], ['Lawrence', '10:38'], ['Santa Clara', '10:43'], ['San Jose', '10:51']]
  426: [['San Francisco', '10:15'], ['22nd Street', '10:20'], ['Bayshore', '10:25'], ['So. San Francisco', '10:31'], ['San Bruno', '10:35'], ['Millbrae', '10:39'], ['Broadway', '10:43'], ['Burlingame', '10:45'], ['San Mateo', '10:49'], ['Hayward Park', '10:52'], ['Hillsdale', '10:55'], ['Belmont', '10:58'], ['San Carlos', '11:01'], ['Redwood City', '11:07'], ['Atherton', '11:11'], ['Menlo Park', '11:14'], ['Palo Alto', '11:17'], ['California Ave', '11:21'], ['San Antonio', '11:25'], ['Mountain View', '11:29'], ['Sunnyvale', '11:34'], ['Lawrence', '11:38'], ['Santa Clara', '11:43'], ['San Jose', '11:51']]
  428: [['San Francisco', '11:15'], ['22nd Street', '11:20'], ['Bayshore', '11:25'], ['So. San Francisco', '11:31'], ['San Bruno', '11:35'], ['Millbrae', '11:39'], ['Broadway', '11:43'], ['Burlingame', '11:45'], ['San Mateo', '11:49'], ['Hayward Park', '11:52'], ['Hillsdale', '11:55'], ['Belmont', '11:58'], ['San Carlos', '12:01'], ['Redwood City', '12:07'], ['Atherton', '12:11'], ['Menlo Park', '12:14'], ['Palo Alto', '12:17'], ['California Ave', '12:21'], ['San Antonio', '12:25'], ['Mountain View', '12:29'], ['Sunnyvale', '12:34'], ['Lawrence', '12:38'], ['Santa Clara', '12:43'], ['San Jose', '12:51']]
  802: [['San Francisco', '11:59'], ['Millbrae', '12:15'], ['San Mateo', '12:21'], ['Hillsdale', '12:25'], ['Redwood City', '12:33'], ['Palo Alto', '12:39'], ['Mountain View', '12:47'], ['Sunnyvale', '12:52'], ['San Jose', '13:03']]
  430: [['San Francisco', '12:15'], ['22nd Street', '12:20'], ['Bayshore', '12:25'], ['So. San Francisco', '12:31'], ['San Bruno', '12:35'], ['Millbrae', '12:39'], ['Broadway', '12:43'], ['Burlingame', '12:45'], ['San Mateo', '12:49'], ['Hayward Park', '12:52'], ['Hillsdale', '12:55'], ['Belmont', '12:58'], ['San Carlos', '13:01'], ['Redwood City', '13:07'], ['Atherton', '13:11'], ['Menlo Park', '13:14'], ['Palo Alto', '13:17'], ['California Ave', '13:21'], ['San Antonio', '13:25'], ['Mountain View', '13:29'], ['Sunnyvale', '13:34'], ['Lawrence', '13:38'], ['Santa Clara', '13:43'], ['San Jose', '13:51']]
  432: [['San Francisco', '13:15'], ['22nd Street', '13:20'], ['Bayshore', '13:25'], ['So. San Francisco', '13:31'], ['San Bruno', '13:35'], ['Millbrae', '13:39'], ['Broadway', '13:43'], ['Burlingame', '13:45'], ['San Mateo', '13:49'], ['Hayward Park', '13:52'], ['Hillsdale', '13:55'], ['Belmont', '13:58'], ['San Carlos', '14:01'], ['Redwood City', '14:07'], ['Atherton', '14:11'], ['Menlo Park', '14:14'], ['Palo Alto', '14:17'], ['California Ave', '14:21'], ['San Antonio', '14:25'], ['Mountain View', '14:29'], ['Sunnyvale', '14:34'], ['Lawrence', '14:38'], ['Santa Clara', '14:43'], ['San Jose', '14:51']]
  434: [['San Francisco', '14:15'], ['22nd Street', '14:20'], ['Bayshore', '14:25'], ['So. San Francisco', '14:31'], ['San Bruno', '14:35'], ['Millbrae', '14:39'], ['Broadway', '14:43'], ['Burlingame', '14:45'], ['San Mateo', '14:49'], ['Hayward Park', '14:52'], ['Hillsdale', '14:55'], ['Belmont', '14:58'], ['San Carlos', '15:01'], ['Redwood City', '15:07'], ['Atherton', '15:11'], ['Menlo Park', '15:14'], ['Palo Alto', '15:17'], ['California Ave', '15:21'], ['San Antonio', '15:25'], ['Mountain View', '15:29'], ['Sunnyvale', '15:34'], ['Lawrence', '15:38'], ['Santa Clara', '15:43'], ['San Jose', '15:51']]
  436: [['San Francisco', '15:15'], ['22nd Street', '15:20'], ['Bayshore', '15:25'], ['So. San Francisco', '15:31'], ['San Bruno', '15:35'], ['Millbrae', '15:39'], ['Broadway', '15:43'], ['Burlingame', '15:45'], ['San Mateo', '15:49'], ['Hayward Park', '15:52'], ['Hillsdale', '15:55'], ['Belmont', '15:58'], ['San Carlos', '16:01'], ['Redwood City', '16:07'], ['Atherton', '16:11'], ['Menlo Park', '16:14'], ['Palo Alto', '16:17'], ['California Ave', '16:21'], ['San Antonio', '16:25'], ['Mountain View', '16:29'], ['Sunnyvale', '16:34'], ['Lawrence', '16:38'], ['Santa Clara', '16:43'], ['San Jose', '16:51']]
  438: [['San Francisco', '16:15'], ['22nd Street', '16:20'], ['Bayshore', '16:25'], ['So. San Francisco', '16:31'], ['San Bruno', '16:35'], ['Millbrae', '16:39'], ['Broadway', '16:43'], ['Burlingame', '16:45'], ['San Mateo', '16:49'], ['Hayward Park', '16:52'], ['Hillsdale', '16:55'], ['Belmont', '16:58'], ['San Carlos', '17:01'], ['Redwood City', '17:07'], ['Atherton', '17:11'], ['Menlo Park', '17:14'], ['Palo Alto', '17:17'], ['California Ave', '17:21'], ['San Antonio', '17:25'], ['Mountain View', '17:29'], ['Sunnyvale', '17:34'], ['Lawrence', '17:38'], ['Santa Clara', '17:43'], ['San Jose', '17:51']]
  440: [['San Francisco', '17:15'], ['22nd Street', '17:20'], ['Bayshore', '17:25'], ['So. San Francisco', '17:31'], ['San Bruno', '17:35'], ['Millbrae', '17:39'], ['Broadway', '17:43'], ['Burlingame', '17:45'], ['San Mateo', '17:49'], ['Hayward Park', '17:52'], ['Hillsdale', '17:55'], ['Belmont', '17:58'], ['San Carlos', '18:01'], ['Redwood City', '18:07'], ['Atherton', '18:11'], ['Menlo Park', '18:14'], ['Palo Alto', '18:17'], ['California Ave', '18:21'], ['San Antonio', '18:25'], ['Mountain View', '18:29'], ['Sunnyvale', '18:34'], ['Lawrence', '18:38'], ['Santa Clara', '18:43'], ['San Jose', '18:51']]
  442: [['San Francisco', '18:15'], ['22nd Street', '18:20'], ['Bayshore', '18:25'], ['So. San Francisco', '18:31'], ['San Bruno', '18:35'], ['Millbrae', '18:39'], ['Broadway', '18:43'], ['Burlingame', '18:45'], ['San Mateo', '18:49'], ['Hayward Park', '18:52'], ['Hillsdale', '18:55'], ['Belmont', '18:58'], ['San Carlos', '19:01'], ['Redwood City', '19:07'], ['Atherton', '19:11'], ['Menlo Park', '19:14'], ['Palo Alto', '19:17'], ['California Ave', '19:21'], ['San Antonio', '19:25'], ['Mountain View', '19:29'], ['Sunnyvale', '19:34'], ['Lawrence', '19:38'], ['Santa Clara', '19:43'], ['San Jose', '19:51']]
  804: [['San Francisco', '18:59'], ['Millbrae', '19:15'], ['San Mateo', '19:21'], ['Hillsdale', '19:25'], ['Redwood City', '19:33'], ['Palo Alto', '19:39'], ['Mountain View', '19:47'], ['Sunnyvale', '19:52'], ['San Jose', '20:03']]
  444: [['San Francisco', '19:15'], ['22nd Street', '19:20'], ['Bayshore', '19:25'], ['So. San Francisco', '19:31'], ['San Bruno', '19:35'], ['Millbrae', '19:39'], ['Broadway', '19:43'], ['Burlingame', '19:45'], ['San Mateo', '19:49'], ['Hayward Park', '19:52'], ['Hillsdale', '19:55'], ['Belmont', '19:58'], ['San Carlos', '20:01'], ['Redwood City', '20:07'], ['Atherton', '20:11'], ['Menlo Park', '20:14'], ['Palo Alto', '20:17'], ['California Ave', '20:21'], ['San Antonio', '20:25'], ['Mountain View', '20:29'], ['Sunnyvale', '20:34'], ['Lawrence', '20:38'], ['Santa Clara', '20:43'], ['San Jose', '20:51']]
  446: [['San Francisco', '20:15'], ['22nd Street', '20:20'], ['Bayshore', '20:25'], ['So. San Francisco', '20:31'], ['San Bruno', '20:35'], ['Millbrae', '20:39'], ['Broadway', '20:43'], ['Burlingame', '20:45'], ['San Mateo', '20:49'], ['Hayward Park', '20:52'], ['Hillsdale', '20:55'], ['Belmont', '20:58'], ['San Carlos', '21:01'], ['Redwood City', '21:07'], ['Atherton', '21:11'], ['Menlo Park', '21:14'], ['Palo Alto', '21:17'], ['California Ave', '21:21'], ['San Antonio', '21:25'], ['Mountain View', '21:29'], ['Sunnyvale', '21:34'], ['Lawrence', '21:38'], ['Santa Clara', '21:43'], ['San Jose', '21:51']]
  448: [['San Francisco', '21:15'], ['22nd Street', '21:20'], ['Bayshore', '21:25'], ['So. San Francisco', '21:31'], ['San Bruno', '21:35'], ['Millbrae', '21:39'], ['Broadway', '21:43'], ['Burlingame', '21:45'], ['San Mateo', '21:49'], ['Hayward Park', '21:52'], ['Hillsdale', '21:55'], ['Belmont', '21:58'], ['San Carlos', '22:01'], ['Redwood City', '22:07'], ['Atherton', '22:11'], ['Menlo Park', '22:14'], ['Palo Alto', '22:17'], ['California Ave', '22:21'], ['San Antonio', '22:25'], ['Mountain View', '22:29'], ['Sunnyvale', '22:34'], ['Lawrence', '22:38'], ['Santa Clara', '22:43'], ['San Jose', '22:51']]

validStation = (station) -> station in (s.name for s in STATIONS)
validNumber = (number, schedule) -> number in (n for n of schedule)

toTitleCase = (str) ->
  str.replace(/^\s+|\s+$/g, '').replace /\w\S*/g, (txt) ->
    txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

formatDate = (d) -> "#{d.getMonth()+1}-#{d.getDate()}"

consDate = (n, dayOfWeek, month, year) ->
  first = new Date year, month, 1
  last = new Date year, month + 1, 0
  firstDayOfWeek = first.getDay()
  list = []
  firstOffset = (dayOfWeek - firstDayOfWeek + 7) % 7 + 1
  first.setDate firstOffset

  while first.getTime() < last.getTime()
    list.push formatDate(first)
    first.setDate first.getDate() + 7

  list.slice(n)[0]

selectSchedule = (date = new Date) ->
  holidays = ['1-1', '7-4', '12-25']
  year = date.getFullYear()
  day = date.getDay()

  # Memorial Day - last Monday of May
  holidays.push consDate -1, 1, 4, year
  # Labor Day - first Monday in September
  holidays.push consDate 0, 1, 8, year
  # Thankgiving Day - last Thursday in November
  holidays.push consDate -1, 4, 10, year

  dayAfterThanksgiving = consDate -1, 5, 10, year

  date = formatDate(date)

  switch
    when day == 0 or date in holidays then 'sunday'
    when day == 6 or date is dayAfterThanksgiving then 'saturday'
    else 'weekday'

parseTime = (str) ->
  components = str.split ':'
  hour = parseInt components[0], 10
  minute = parseInt components[1], 10
  [hour, minute]

calcDuration = (startHour, startMinute, endHour, endMinute) ->
  hours = endHour - startHour
  minutes = endMinute - startMinute
  while minutes < 0
    minutes += 60
    hours -= 1
  [hours, minutes]

inFuture = (date, arrivalTime) ->
  [endHour, endMinute] = parseTime arrivalTime
  [hours, minutes] = calcDuration date.getHours(), date.getMinutes(), endHour, endMinute
  (hours*60 + minutes) > 0

filterBySrcDestTime = (schedule, src, dest, time) ->
  validSchedules = []
  for own line, lineSchedule of schedule
    start = -1
    end = -1
    for item, index in lineSchedule
      if inFuture(time, item[1])
        if src == item[0] then start = index
        if dest == item[0] and index >= start then end = index
    if start >= 0 and end >= start
      validSchedules.push line: line, schedule: lineSchedule[start..end]

  validSchedules

getDuration = (start, end) ->
  [startHour, startMinute] = parseTime start
  [endHour, endMinute] = parseTime end
  [hours, minutes] = calcDuration startHour, startMinute, endHour, endMinute

  if hours > 0 then "#{hours} hr #{minutes} m" else "#{minutes} m"

pad2 = (n) -> ('0' + n).slice(-2)
formatStation = (station) ->
  [hour, minute] = parseTime station[1]
  ampm = if (Math.floor(hour/12) % 2) == 0 then 'am' else 'pm'
  hour = if hour == 12 then hour else hour % 12
  "#{station[0]} #{pad2(hour)}:#{pad2(minute)} #{ampm}"

timeZoneOffset = -8 # PST
getDate = ->
  d = new Date
  offset = d.getTimezoneOffset()*60*1000;
  new Date(d.getTime() + (timeZoneOffset*60*60*1000) + offset)

caltrainMe = (msg, src, dest, limit) ->
  date = getDate()
  schedule = SCHEDULES[selectSchedule(date)]
  filtered = filterBySrcDestTime(schedule, toTitleCase(src), toTitleCase(dest), date)
  if filtered.length
    filtered = filtered.sort (a, b) ->
      [aHour, aMinute] = parseTime a.schedule[0][1]
      [bHour, bMinute] = parseTime b.schedule[0][1]
      (aHour*60 + aMinute) - (bHour*60 + bMinute)

    formatted = for f in filtered[0...limit]
      start = f.schedule[0]
      end = f.schedule.slice(-1)[0]
      rideDuration = getDuration(start[1], end[1])
      duration = getDuration("#{date.getHours()}:#{date.getMinutes()}", start[1])
      "In #{duration}, Train #{f.line}: #{formatStation(start)} -> #{formatStation(end)} (#{rideDuration})"

    msg.send formatted.join('\n')
  else
    msg.send 'No more trains today :('

home = process.env.HUBOT_CALTRAIN_HOME_STATION
module.exports = (robot) ->
  robot.respond /next (?:cal)?train to\s+(.+)/i, (msg) ->
    caltrainMe msg, home, msg.match[1], 1
  robot.respond /(?:cal)?trains to\s+(.+)/i, (msg) ->
    caltrainMe msg, home, msg.match[1], 50
  robot.respond /next (?:cal)?train from\s+(.+)\s+to\s+(.+)/i, (msg) ->
    caltrainMe msg, msg.match[1], msg.match[2], 1
  robot.respond /(?:cal)?trains from\s+(.+)\s+to\s+(.+)/i, (msg) ->
    caltrainMe msg, msg.match[1], msg.match[2], 50
