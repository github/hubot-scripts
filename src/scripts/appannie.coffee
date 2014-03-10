# Description
#   AppAnnie analytics information provider
#
# Dependencies:
#   "<none>": "<none>"
#
# Configuration:
#   ANNIE_TOKEN
#   ANNIE_ACCOUNT_ID_IOS
#   ANNIE_ACCOUNT_ID_ANDROID
#   ANNIE_APP_ID_IOS
#   ANNIE_APP_ID_ANDROID
#   ANNIE_COUNTRIES
#
# Commands:
#   annie accounts - Returns AppAnnie acounts information for setup
#   annie apps <platform> - Returns AppAnnie apps information for setup
#   annie downloads <platform> - Returns last known day downloads data for <platform>
#   annie downloads <platform> <range> - Returns last known <range> downloads data for <platform>
#
# Notes:
#   <platform> "ios" or "android"
#   <range> "today", "week" or "month"
#
# Author:
#   meetsapp


api_path = 'https://api.appannie.com/'
api_token = process.env.ANNIE_TOKEN

globalOptions = {
  account_id: '',
  account_id_ios: process.env.ANNIE_ACCOUNT_ID_IOS,
  account_id_android: process.env.ANNIE_ACCOUNT_ID_ANDROID,
  app_id: '',
  app_id_ios: process.env.ANNIE_APP_ID_IOS,
  app_id_android: process.env.ANNIE_APP_ID_ANDROID,
  start_date: '',
  end_date: '',
  countries: process.env.ANNIE_COUNTRIES or 'US',
  page_index: '0'
}

get_end_point = (options) ->
  return {
    accounts: 'v1/accounts?page_index=0',
    apps: 'v1/accounts/'+options.account_id+'/apps'
    downloads: 'v1/accounts/'+options.account_id+'/apps/'+options.app_id+'/sales'+'?start_date='+options.start_date+'&end_date='+options.end_date+'&countries='+options.countries
  }

# Offset in days
get_current_date = (offset) ->
    now = new Date()
    now.setDate(now.getDate()+offset)
    now_day = now.getDate()
    now_year = now.getFullYear()
    now_month = now.getMonth()+1
    return now_formatted = now_year+'-'+now_month+'-'+now_day


module.exports = (robot) ->

  # Returns account information
  robot.respond /annie accounts/i, (msg) ->
    end_point = get_end_point(globalOptions)
    msg.http(api_path+end_point.accounts)
      .headers(Authorization: 'Bearer '+api_token, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse body
        msg.send 'account_id: '+ data.account_list[0]. account_id
        msg.send body

  # Returns apps information from a platform
  robot.respond /annie apps(?:( ios| android))?/i, (msg) ->
    platform = msg.match[1] or 'none'
    platform = platform.replace(' ', '')

    localOptions = globalOptions
    if platform is 'ios'
      localOptions.account_id = globalOptions.account_id_ios
    else if platform is 'android'
      localOptions.account_id = globalOptions.account_id_android
    else
      msg.send 'You must provide a platform name "ios" or "android"'

    unless platform is 'none'
      end_point = get_end_point(localOptions)
      msg.http(api_path+end_point.apps)
        .headers(Authorization: 'Bearer '+api_token, Accept: 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse body
          msg.send 'app_id: '+ data.app_list[0]. app_id
          msg.send body

  # Returns downloads by platform and range
  robot.respond /annie downloads(?:( ios| android))?(?:( week| month))?/i, (msg) ->

    platform = msg.match[1] or 'both'
    platform = platform.replace(' ', '')
    range = msg.match[2] or 'today'
    range = range.replace(' ', '')
    localOptions = globalOptions

    unless platform is 'both'
      msg.send 'Checking '+platform+' platform...'
      if platform is 'ios'
        localOptions.account_id = globalOptions.account_id_ios
        localOptions.app_id = globalOptions.app_id_ios
        if range is 'today'
          localOptions.start_date = get_current_date(-2)
        if range is 'week'
          localOptions.start_date = get_current_date(-9)
        if range is 'month'
          localOptions.start_date = get_current_date(-33)
        localOptions.end_date = get_current_date(-2)

      else if platform is 'android'
        localOptions.account_id = globalOptions.account_id_android
        localOptions.app_id = globalOptions.app_id_android
        if range is 'today'
          localOptions.start_date = get_current_date(-3)
        if range is 'week'
          localOptions.start_date = get_current_date(-10)
        if range is 'month'
          localOptions.start_date = get_current_date(-34)
        localOptions.end_date = get_current_date(-3)

      end_point = get_end_point(localOptions)
      msg.http(api_path+end_point.downloads)
        .headers(Authorization: 'Bearer '+api_token, Accept: 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse body
          msg.send 'Downloads: '+data.sales_list[0].units.app.downloads
    else
      msg.send 'Platform must be specified "android" or "ios"'
