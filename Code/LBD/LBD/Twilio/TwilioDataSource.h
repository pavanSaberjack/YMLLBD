//
//  TwilioDataSource.h
//  ConcurrentSample
//
//  Created by Mahesh on 2/9/13.
//  Copyright (c) 2013 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDevice;

@protocol TwilioDataSourceDelegate <NSObject>

- (void)didReceiveRecordedUrl:(NSString *)string;

@end

@interface TwilioDataSource : NSObject

// the device that connect to the Twilio services
@property (nonatomic, strong, readonly)TCDevice *device;
// delegate
@property (nonatomic, strong)id<TwilioDataSourceDelegate>dataSourceDelegate;

-(id)initWithUserName:(NSString *)userName;

/*
 getting the audio file and the video file
 */

- (void)listenAudio:(NSURL *)url;
- (void)recordQuerys;
- (void)stopAudio;

@end
