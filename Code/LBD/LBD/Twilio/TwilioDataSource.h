//
//  TwilioDataSource.h
//  ConcurrentSample
//
//  Created by Mahesh on 2/9/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDevice;

@interface TwilioDataSource : NSObject

// the device that connect to the Twilio services
@property (nonatomic, strong, readonly)TCDevice *device;

-(id)initWithUserName:(NSString *)userName;

/*
 getting the audio file and the video file
 */

- (void)listenAudio:(NSURL *)url;
- (void)recordQuerys;
- (void)stopAudio;

@end
