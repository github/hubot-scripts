# Gets border waiting times to US.
#
# crossing <port_name>

parser = require('xml2json');

String.prototype.minimize = ->
  return this.toLowerCase().replace( /\ /g, '' )

delay_time = ( port_object ) ->
  return "N/A" if port_object["operational_status"].match /N\/A|closed/gi
  return port_object["delay_minutes"]

build_name = ( port_object ) ->
  name = port_object['port_name']
  name += " #{port_object['crossing_name']}" unless port_object['crossing_name'] instanceof Object
  return name

safe_element = ( port_object, element ) ->
  return "N/A" if port_object[ element ] instanceof Object
  return port_object[ element ]

module.exports = (robot) ->
  robot.respond /crossing (.*)$/i, (msg) ->
    port_name = msg.match[1]
    message = ""

    msg.http('http://apps.cbp.gov/bwt/bwt.xml')
      .get() (err, res, body) ->
        json_border_data = parser.toJson( body )
        border = JSON.parse( json_border_data )["border_wait_time"]["port"]
        for port in border
          if port.port_name.minimize() is port_name.minimize()
            message += "#{ build_name( port )}\n" +
                     "Updated at #{ safe_element( port, 'date' ) } #{ safe_element( port['passenger_vehicle_lanes']['standard_lanes'], 'update_time' ) }\n" +
                     "Port is now #{port['port_status']}\n" +
                     "Normal Lanes: #{ delay_time( port['passenger_vehicle_lanes']['standard_lanes'] )}\n" +
                     "SENTRI: #{delay_time( port['passenger_vehicle_lanes']['NEXUS_SENTRI_lanes'] )}\n" +
                     "Ready Lanes: #{delay_time( port['passenger_vehicle_lanes']['ready_lanes'] )}\n" +
                     "Pedestrian: #{ delay_time( port['pedestrian_lanes']['standard_lanes'] )}\n"

        message = "I don't know where #{port_name} is" if message.minimize() is ""

        msg.send message
