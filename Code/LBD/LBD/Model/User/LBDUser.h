//
//  LBDUser.h
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBDUser : NSObject
{
    //NS: minimalistic set
    NSString *serviceName;
    NSString *authToken;
	NSString *userName;
	NSString *email;
	NSString *userId;
    
    //NS: extra-info -- to be used by services to push in whatever extra key-value pairs they want to save
    NSDictionary *extras;
}

@property (retain) NSString *serviceName;
@property (retain) NSString *authToken;
@property (retain) NSString *userName;
@property (retain) NSString *email;
@property (retain) NSString *userId;
@property (retain) NSDictionary *extras;

@end
