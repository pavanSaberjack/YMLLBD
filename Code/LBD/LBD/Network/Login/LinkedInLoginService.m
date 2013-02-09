//
//  LinkedInLoginService.m
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LinkedInLoginService.h"
#import "MBProgressHUD.h"
#import "JSON.h"

@interface LinkedInLoginService () <UIWebViewDelegate>
{
    LinkedInLoginCompletion loginCompletion;
    UIWebView *linkedInWebView;
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    LBDUser *user;
}

@property(nonatomic, retain) OAToken *requestToken;
@property(nonatomic, retain) OAToken *accessToken;
@property(nonatomic, retain) OAConsumer *consumer;

- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (void)testApiCall;

@end

@implementation LinkedInLoginService

@synthesize requestToken, accessToken,consumer;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self initLinkedInApi];
    }
    return self;
}

- (void)dealloc
{
    [requestToken release];
    [accessToken release];
    [consumer release];
    [requestTokenURL release];
    [accessTokenURL release];
    [userLoginURL release];
    [loginCompletion release];
    [super dealloc];
}


-(void)loginWithWebView:(UIWebView *)webView onCompletion:(LinkedInLoginCompletion)completion
{
    loginCompletion = [completion copy];
    
    linkedInWebView = webView;
    [linkedInWebView setDelegate:self];
    
    //NS: API calls start here
    NSLog(@"Starting LinkedIn API calls.");
    [self requestTokenFromProvider];
}

#pragma mark
#pragma mark Class Private Methods

- (void)initLinkedInApi
{
    apikey = @"8yj48bo1uyxs";
    secretkey = @"DMf5l6pqSQsWWx76";
    
    self.consumer = [[OAConsumer alloc] initWithKey:apikey
                                             secret:secretkey
                                              realm:@"http://api.linkedin.com/"];
    
    requestTokenURLString = @"https://api.linkedin.com/uas/oauth/requestToken";
    accessTokenURLString = @"https://api.linkedin.com/uas/oauth/accessToken";
    userLoginURLString = @"https://www.linkedin.com/uas/oauth/authorize";
    linkedInCallbackURL = @"hdlinked://linkedin/oauth";
    
    requestTokenURL = [[NSURL URLWithString:requestTokenURLString] retain];
    accessTokenURL = [[NSURL URLWithString:accessTokenURLString] retain];
    userLoginURL = [[NSURL URLWithString:userLoginURLString] retain];
    
}

- (void)requestTokenFromProvider
{
    OAMutableURLRequest *request =
    [[[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                     consumer:self.consumer
                                        token:nil
                                     callback:linkedInCallbackURL
                            signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];    
}


- (void)requestTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    if (ticket.didSucceed == NO)
        return;
    
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    [self allowUserToLogin];
}

- (void)requestTokenResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)allowUserToLogin
{
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@",
                                       userLoginURLString, self.requestToken.key];
    
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL: userLoginURL];
    [linkedInWebView loadRequest:request];
}

- (void)accessTokenFromProvider
{
    
    OAMutableURLRequest *request =
    [[[OAMutableURLRequest alloc] initWithURL:accessTokenURL consumer:self.consumer token:self.requestToken realm:nil signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];
}


- (void)accessTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    if ( problem )
    {
        NSLog(@"Request access token failed.");
        NSLog(@"%@",responseBody);
    }
    else
    {
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [self testApiCall];
    }
    [responseBody release];
}


#pragma mark
#pragma mark WebView Delegate Methods

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    [MBProgressHUD showDimmedHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:linkedInCallbackURL].location != NSNotFound);
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {
            [self.requestToken setVerifierWithUrl:url];
            [self accessTokenFromProvider];
        }
        else
        {
            // User refused to allow our app access
            // Notify parent and close this view
            [linkedInWebView setHidden:YES];
            [linkedInWebView removeFromSuperview];
            [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            if (loginCompletion) {
                loginCompletion(nil);
            }
        }
    }
    
	return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}


#pragma mark
#pragma mark Test API Methods

- (void)testApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,picture-url,positions)"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:self.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(testApiCallResult:didFinish:)
                  didFailSelector:@selector(testApiCallResult:didFail:)];
    [request release];
}

- (void)testApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    [self setUserFromUserInfo:[responseBody JSONValue]];
    [responseBody release];
    
    // Notify parent and close this view
    [linkedInWebView setHidden:YES];
    [linkedInWebView removeFromSuperview];
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    if (loginCompletion)
    {
        loginCompletion(user);
    }    
}

- (void)testApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

-(BOOL)isServiceAvailable
{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInUser"])
    {
        return YES;
    }
    return NO;
}

-(LBDUser *)getAccountInfo
{
    [self setUserFromUserInfo:[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInUser"]];
    return user;
}

-(void)setUserFromUserInfo:(NSDictionary *)info
{
    NSLog(@"info is:%@",info);
    user = [[LBDUser alloc] init];
    [user setServiceName:@"LinkedIn"];
    [user setAuthToken:self.accessToken.key];
    [user setUserName:[info objectForKey:@"firstName"]];
    [user setEmail:@""];
    [user setUserId:[info objectForKey:@"id"]];
    [user setExtras:[NSDictionary dictionaryWithObjects:
                     [NSArray arrayWithObjects:[info objectForKey:@"pictureUrl"],
                      [info  objectForKey:@"headline"],[info objectForKey:@"lastName"],nil]
                                                forKeys:[NSArray arrayWithObjects:@"pictureURL", @"headline",@"lastName",nil]]];
    
    //NS: save the user in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:@"linkedInUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

