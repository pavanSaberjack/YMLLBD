//
//  LinkedInLoginService.h
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import "LBDUser.h"

typedef void (^LinkedInLoginCompletion) (id);

@interface LinkedInLoginService : NSObject

-(void)loginWithWebView:(UIWebView *)webView onCompletion:(LinkedInLoginCompletion)completion;

-(BOOL)isServiceAvailable;
-(LBDUser *)getAccountInfo;

@end
