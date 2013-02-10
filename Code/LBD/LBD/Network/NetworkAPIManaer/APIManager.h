//
//  APIManager.h
//  LBD
//
//  Created by Navjot on 2/10/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkAPICallback)(BOOL success, id result);

@interface APIManager : NSObject
{
    NetworkAPICallback callback;
}

@property(nonatomic, retain) NetworkAPICallback callback;

-(void)fetchResultsFor:(NSString *)searchStr withCallback:(NetworkAPICallback)_callback;

@end
