//
//  LBDUser.m
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDUser.h"

#define GUARD_RELEASE(object) if(object!=nil){[object release]; object = nil;}

@implementation LBDUser

@synthesize serviceName;
@synthesize userName;
@synthesize email;
@synthesize userId;
@synthesize authToken;
@synthesize extras;

-(NSString *)description
{
    return [NSString stringWithFormat:
            @"Service : %@\nID : %@\nName : %@\nEmail : %@\nAuthToken: %@\n Extras : %@",
            serviceName ,userId, userName, email, authToken, extras];
}


#pragma mark - Dealloc
- (void) dealloc
{
    GUARD_RELEASE(serviceName);
    GUARD_RELEASE(userName);
    GUARD_RELEASE(email);
    GUARD_RELEASE(userId);
    GUARD_RELEASE(authToken);
    GUARD_RELEASE(extras);
    
    [super dealloc];
}

@end

