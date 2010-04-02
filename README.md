CPWebSocket
===========

A WebSocket implementation for Cappuccino.

Test it out by running runserver.js from
[node.websocket](http://github.com/shazow/node.websocket.js) (with
[Node](http://github.com/ry/node)) and then browsing to
TestHarness/index.html with a browser that supports WebSockets (such
as Google Chrome).


Usage
=====

The API is very simple, like the native API. You can only open, close,
and send messages with CPWebSocket.  When you instantiate CPWebSocket
you pass in a delegate that implements a few methods.

A short example:

<pre><code>// In a method somewhere

// ...
var webSocket = [CPWebSocket openWebSocketWithURL: @"ws://localhost:8080" delegate: self]
// ...

// in the delegate implementation:

- (void)webSocketDidOpen: (CPWebSocket)ws
{
    CPLog('web socket open: ' + [ws URL]);
}

- (void)webSocket: (CPWebSocket)ws didReceiveMessage: (CPString)message
{
    CPLog('web socket received message: ' + message);
}

- (void)webSocketDidClose: (CPWebSocket)ws
{
    CPLog('web socket closed');
}

- (void)webSocketDidReceiveError: (CPWebSocket)ws
{
    CPLog('web socket error');
}
</code></pre>


License
=======

Copyright 2010 Sami Samhuri

MIT License
