# Description:
#   Provides a Server-Sent Events path for broadcasting messages to subscribers.
#
# Dependencies:
#   None
#
# Commands:
#   hubot minime <message> - sends the message to any subscribers.
#
# Configuration:
#   None
#
# Author:
#   jimbojw

module.exports = (robot) ->
  
  # collection of open connections (ES6 Set would be preferable if available)
  id = 0
  connections = {}
  
  # implement SSE
  robot.router.get '/minime/events', (req, res) ->
    
    req.socket.setTimeout Infinity
    
    res.writeHead 200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive'
    }
    res.write '\n'
    
    id = id + 1
    res.minime_id = id
    connections[id] = res
    
    res.on 'close', () ->
      delete connections[res.minime_id]
  
  # repackage and post all server sent events to parent window
  robot.router.get '/minime/iframe', (req, res) ->
    res.writeHead 200, { 'Content-Type': 'text/html' }
    res.end """<!doctype html>
      <script>
      (function(window){
        var source = new EventSource(window.location.pathname.replace(/\\/iframe(\\/|$)/, '/events\\1'));
        source.onmessage = function(e) {
          window.parent.postMessage(JSON.stringify({
            from: 'minime',
            message: JSON.parse(e.data)
          }), '*');
        };
      })(window);
      </script>
    """
  
  # test the iframe
  robot.router.get '/minime/test', (req, res) ->
    res.writeHead 200, { 'Content-Type': 'text/html' }
    res.end """<!doctype html>
      <html><head></head><body>
      <h1>messages: <h1>
      <script>
      (function(window, document){
        var iframe = document.createElement('iframe');
        iframe.height = '1px';
        iframe.width = '1px';
        iframe.style.border = 'none';
        iframe.src = './iframe';
        window.onmessage = function(event) {
          var payload = JSON.parse(event.data);
          if (payload.from === 'minime') {
            var pre = document.createElement('pre');
            pre.appendChild(document.createTextNode(event.data));
            document.body.appendChild(pre);
          }
        };
        document.body.appendChild(iframe);
      })(window, document);
      </script>
      </body></html>
    """
  
  # send minime messages out to subsribers
  robot.respond /(?:mini ?me) (.*)/i, (msg) ->
    
    subscribers = Object.keys(connections).length
    s = if subscribers == 1 then '' else 's'
      
    if subscribers
      msg.send 'publishing to ' + subscribers + ' minime subscriber' + s
      for k, res of connections
        res.write 'data: ' + JSON.stringify(msg.match[1]) + '\n\n'
    else
      msg.send('there are no minime subscribers at this time :(');

