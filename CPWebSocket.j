//
// CPWebSocket.j
//
// Copyright 2010 Sami Samhuri
// Additions Ignacio Cases
//
// MIT license
//

@import <Foundation/CPObject.j>

CPWebSocketStateConnecting = 0,
CPWebSocketStateOpen       = 1,
CPWebSocketStateClosing    = 2,
CPWebSocketStateClosed     = 3;

@implementation CPWebSocket : CPObject
{
    JSObject _ws;
    id delegate;
}

+ (id) openWebSocketWithURL: (CPString)url_ delegate: (id) delegate_
{
    return  [[self alloc] initWithURL: url_ delegate: delegate_];
}

- (id) initWithURL: (CPString)url_ delegate: (id) delegate_
{
    self = [super init];
    if (self) {
        _ws = new WebSocket(url_);
        delegate = delegate_;
        [self _setupCallbacks];
    }
    return self;
}

- (void) _setupCallbacks
{
    _ws.onopen = function() {
        [delegate webSocketDidOpen: self];
        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };
    _ws.onclose = function(event) {
        [delegate webSocketDidClose: self];
        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };
    _ws.onmessage = function(event) {
        [delegate webSocket: self didReceiveMessage: event.data];
        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };
    _ws.onerror = function(event) {
        [delegate webSocketDidReceiveError: self];
        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };
}

- (CPString) URL
{
    return _ws.URL;
}

// I. Cases: In Draft 76 the api is readyState instead of state
- (CPNumber) readyState
{
    return _ws.readyState;
}
// I. Cases
- (CPString)state 
{
    var result;
    
    if ([self readyState] == 0) {
        result = @"CPWebSocketStateConnecting";
    }else if ([self readyState] == 1) {
        result = @"CPWebSocketStateOpen";
    } else if ([self readyState] == 2) {
        result = @"CPWebSocketStateClosing";
    } else if ([self readyState] == 3) {
        result = @"CPWebSocketStateClosed";
    }
    return result;
}

- (CPNumber) bytesBuffered
{
    return _ws.bufferedAmount;
}

- (void) close
{
    _ws.close();
}

- (BOOL) send: (JSObject) data
{
    // TODO check the state, should not be CPWebSocketConnecting
    return _ws.send(data);
}

@end
