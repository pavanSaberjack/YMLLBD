//
//  LBDUser.h
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_VENDOR @"vendor"
#define USER_CONSUMER @"consumer"

@interface LBDUser : NSObject
{
    //NS: minimalistic set
    NSString *serviceName;
    NSString *authToken;
	NSString *userName;
	NSString *email;
	NSString *userId;
    NSString *type;
    
    //NS: extra-info -- to be used by services to push in whatever extra key-value pairs they want to save
    NSDictionary *extras;
}

+ (LBDUser *)currentUser;

@property (retain) NSString *serviceName;
@property (retain) NSString *authToken;
@property (retain) NSString *userName;
@property (retain) NSString *email;
@property (retain) NSString *userId;
@property (retain) NSString *type;
@property (retain) NSDictionary *extras;

@end
