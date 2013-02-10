//
//  TwilioDataSource.m
//  ConcurrentSample
//
//  Created by Mahesh on 2/9/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//


#import "TwilioDataSource.h"
#import "AudioStreamer.h"
#import "Headers/TCDevice.h"
#import "Headers/TCDevice.h"
#import "TCConnection.h"

#define HOST  @"http://www.indrajeet.byethost13.com"

typedef void(^TCUnlink)(void);

@interface TwilioDataSource()<NSURLConnectionDataDelegate,TCDeviceDelegate,TCConnectionDelegate>

@property (nonatomic, strong)NSString *capabilityToken;
@property (nonatomic, strong)AudioStreamer *streamer;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSURLConnection *capabilityTokenConnection;
@property (nonatomic, strong)TCDevice *device;
@property (nonatomic, strong)TCConnection *deviceConnection;
@property (nonatomic, assign)TCUnlink unlink;
@property (nonatomic, assign)BOOL needUrl;

@end

@implementation TwilioDataSource

-(id)initWithUserName:(NSString *)userName
{
    if ( self = [super init] )
    { 
        _userName = userName;
        _needUrl = YES;
    }
    return self;
}

- (void)getDevice
{
    if(self.capabilityToken)
        self.device = [[TCDevice alloc]initWithCapabilityToken:self.capabilityToken delegate:self];
}

- (void)connect
{
    self.deviceConnection = [self.device connect:nil delegate:self];
    _device.incomingSoundEnabled = YES;
    
    __block __typeof__(self) weakSelf = self;
    
    self.unlink = ^(void){
        [weakSelf.device unlisten];
    };
    
    double delayInSeconds = 25.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), self.unlink);
}

- (void)disconnect
{
    [self.deviceConnection disconnect];
}

#pragma mark - CapabilityToken
- (void)getCapabilityTokenandDevice:(NSString *)authHost
{
    NSURL* url = [NSURL URLWithString:authHost];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:
                    [NSURLRequest requestWithURL:url]
                                         returningResponse:&response
                                                     error:&error];
    if (data)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200)
        {
            NSString* capabilityToken =
            [[NSString alloc] initWithData:data
                                  encoding:NSUTF8StringEncoding];
            
            self.capabilityToken = capabilityToken;
            [self getDevice];
        }
        else
        {
            NSString*  errorString = [NSString stringWithFormat:
                                      @"HTTP status code %d",
                                      httpResponse.statusCode];
            NSLog(@"Error logging in: %@", errorString);
        }
    }
    else
    {
        NSLog(@"Error logging in: %@", [error localizedDescription]);
    }
}

#pragma mark - get url
- (NSString *)getRecordedUrl
{
    NSURL* url = [NSURL URLWithString:@"http://www.indrajeet.byethost13.com/getUrl.php"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:
                    [NSURLRequest requestWithURL:url]
                                         returningResponse:&response
                                                     error:&error];
    if (data)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200)
        {
            NSString* url =
            [[NSString alloc] initWithData:data
                                  encoding:NSUTF8StringEncoding];
            
            return url;
        }
        else
        {
            NSString*  errorString = [NSString stringWithFormat:
                                      @"HTTP status code %d",
                                      httpResponse.statusCode];
            NSLog(@"Error logging in: %@", errorString);
        }
    }
    else
    {
        NSLog(@"Error logging in: %@", [error localizedDescription]);
    }
    
    return nil;
}

#pragma mark - TCDevice Delegate
-(void)deviceDidStartListeningForIncomingConnections:(TCDevice*)device
{
    NSLog(@"Started listening");
    _needUrl = YES;

}

-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error
{
    NSLog(@"stopped listening");
    
    [self.deviceConnection disconnect];
    self.device = Nil;
    self.unlink = nil;
    
    NSString *url = [self getRecordedUrl];
    
    if([url length]>0 && _needUrl)
    {
        // upload the url to the backend
        
        _needUrl = NO;
    }
}

-(void)device:(TCDevice*)device didReceiveIncomingConnection:(TCConnection*)connection
{
    if (self.deviceConnection)
    {
        [self.deviceConnection disconnect];
    }
    self.deviceConnection = connection;
    [self.deviceConnection reject];
    
    NSLog(@"Received Connection");
}

-(void)device:(TCDevice *)device didReceivePresenceUpdate:(TCPresenceEvent *)presenceEvent
{

}

#pragma mark - TCConnection Delegate
-(void)connection:(TCConnection*)connection didFailWithError:(NSError*)error
{
    // error
}

-(void)connectionDidStartConnecting:(TCConnection*)connection
{
    // connection started
}

-(void)connectionDidConnect:(TCConnection*)connection
{
    // connected
}

-(void)connectionDidDisconnect:(TCConnection*)connection
{
    // disconnected
}


#pragma Mark  - RecordQuery
- (void)recordQuerys
{
    if (self.device)
    {
        _needUrl = NO;
        [self.device  unlisten];
        self.device = Nil;
        self.deviceConnection = nil;
        self.unlink = nil;
    }
    
    // renew the token
    [self getCapabilityTokenandDevice:[NSString stringWithFormat:@"%@/auth.php?clientName=%@",HOST,_userName]];
    
    // connect the server
    [self connect];
}

- (void)listenAudio:(NSURL *)url
{
    // listen to audio
    if (self.streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	self.streamer = [[AudioStreamer alloc] initWithURL:url];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:self.streamer];
    
    [self.streamer start];
}

- (void)destroyStreamer
{
	if (self.streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:self.streamer];
		
		[self.streamer stop];
		self.streamer = nil;
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([self.streamer isWaiting])
	{
	}
	else if ([self.streamer isPlaying])
	{
	}
	else if ([self.streamer isIdle])
	{
		[self destroyStreamer];
	}
}

- (void)stopAudio
{
    [self destroyStreamer];
}

@end
