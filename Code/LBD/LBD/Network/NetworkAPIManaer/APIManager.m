//
//  APIManager.m
//  LBD
//
//  Created by Navjot on 2/10/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "APIManager.h"
#import "JSON.h"
#import "MBProgressHUD.h"

#define GUARD_RELEASE(object) if(object!=nil){[object release]; object = nil;}

@interface APIManager ()
{
    NSURLConnection *urlConnection;
    NSString *status;
    int statusCode;
    NSMutableData *respdata;
    NSDictionary *respDict;
    NSString *reuqestedURL;
}

@property (nonatomic, retain) NSMutableArray *termArray;

@end


@implementation APIManager

@synthesize callback, termArray;

-(void)fetchResultsFor:(NSString *)searchStr withCallback:(NetworkAPICallback)_callback;
{
    [self setCallback:[[_callback copy]autorelease]];
    
    NSDictionary *params =@{@"latitude":@"12.966169", @"longitude":@"77.596597", @"query":searchStr};
    
    NSString *rawUrlStr = @"http://192.168.1.94:3000/products/get.json";

    NSString *escapedUrlStr = [rawUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *aUrl = [NSURL URLWithString:escapedUrlStr];
    
    NSLog(@"\n\n\n URL - %@ \n\n\n", aUrl);
    
    NSData *postData = [[NSString stringWithFormat:@"data=%@",[params JSONRepresentation]] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://192.168.1.94:3000/products/get.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    statusCode = [((NSHTTPURLResponse *)response) statusCode];
    respdata =[[NSMutableData alloc] init];
    reuqestedURL = [[response URL] absoluteString];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [respdata appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDictionary *errorInfo;
    
    if(respdata)
    {
        self.callback(NO, respdata);
    }
    else
    {
        errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                        NSLocalizedString(@"Server returned status code %d",@""),
                                                        statusCode]
                                                forKey:NSLocalizedDescriptionKey];
    }
    
    //NSError *statusError = [NSError errorWithDomain:@"HTTPStatus error" code:statusCode userInfo:errorInfo];
    
    GUARD_RELEASE(respdata);
    GUARD_RELEASE(urlConnection);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* Resp = [[[NSString alloc] initWithData:respdata encoding:NSUTF8StringEncoding]autorelease];
    
    if(([respdata length]>0)&&(([Resp length]>0)&&(![Resp isEqual:@"null"])&&(statusCode==200)) )
    {
        if(self.callback !=nil)
        {
            self.callback(YES, [Resp JSONValue]);
        }
    }
    else
    {
        NSString *errorString = nil;
        if(statusCode == 401)
        {
            errorString = [NSString stringWithFormat:@"ErrorCode 401."];
            
        }
        else if(statusCode == 403)
        {
            errorString = [NSString stringWithFormat:@"ErrorCode 403."];
        }
        
        NSError *statusError = [NSError errorWithDomain:@"HTTPStatus error"
                                                   code:statusCode
                                               userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                          errorString ,@"status",
                                                          [NSString stringWithFormat:@"%i",statusCode],@"statusCode",
                                                          nil]];
        
        if(self.callback!=nil)
        {
            self.callback(NO, statusError);
        }
        
        GUARD_RELEASE(respdata);
        GUARD_RELEASE(urlConnection);
    }
}

- (void)dealloc
{
    self.termArray = nil;
    [super dealloc];
}
@end

