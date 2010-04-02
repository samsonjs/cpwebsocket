/*
 * AppController.j
 * CPWebSocket TestHarness
 *
 * Created by Sami Samhuri on April 1, 2010.
 * Copyright 2010, Sami Samhuri All rights reserved.
 *
 * MIT license
 *
 */

@import <Foundation/CPObject.j>
@import "../CPWebSocket.j"

CPLogRegister(CPLogConsole);

@implementation AppController : CPObject
{
	CPMenu mainMenu;
    CPLabel label;
    CPWebSocket webSocket;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    [label setFont:[CPFont boldSystemFontOfSize:24.0]];
    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    [contentView addSubview:label];
    [theWindow orderFront:self];

    [self setLabelText:@"Hello WebSocket World!"];
    [self createMainMenu];
}

- (void) openWebSocket
{
    webSocket = [CPWebSocket openWebSocketWithURL: @"ws://localhost:8080" delegate: self];
}

- (void) webSocketDidOpen: (CPWebSocket)ws
{
    [self setLabelText: @">>> web socket open: " + [ws URL]];
}

- (void) webSocket: (CPWebSocket)ws didReceiveMessage: (CPString)message
{
    [self setLabelText: @">>> web socket received: " + message];
}

- (void) webSocketDidClose: (CPWebSocket)ws
{
    [self setLabelText: @">>> web socket closed"];
}

- (void) webSocketDidReceiveError: (CPWebSocket)ws
{
    [self setLabelText: @">>> web socket error, state: " + [ws state]];
}

- (void) sendMessage
{
    [webSocket send: @"ping"];
}

- (void) closeWebSocket
{
    [webSocket close];
}

- (void) createMainMenu
{
	mainMenu = [[CPMenu alloc] initWithTitle:@"TestHarness"];
	var topMenuItem = [mainMenu addItemWithTitle:"CPWebSocket Tests" action:nil keyEquivalent:nil];  
	var menu = [[CPMenu alloc] init]; 
	[menu addItemWithTitle: @"Open WebSocket"
	                action: @selector(openWebSocket)
	         keyEquivalent: "1"];
	[menu addItemWithTitle: @"Send Message"
	                action: @selector(sendMessage)
	         keyEquivalent: "2"];
	[menu addItemWithTitle: @"Close WebSocket"
	                action: @selector(closeWebSocket)
	         keyEquivalent: "5"];
	[mainMenu setSubmenu:menu forItem:topMenuItem]; 
	[[CPApplication sharedApplication] setMainMenu:mainMenu];
	[CPMenu setMenuBarVisible:YES];
}

- (void) setLabelText: (CPString) text
{
    [label setStringValue: text];
    [label sizeToFit];
    [label setCenter:[contentView center]];
}

@end
