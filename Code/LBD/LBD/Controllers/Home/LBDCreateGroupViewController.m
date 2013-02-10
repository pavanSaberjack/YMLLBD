//
//  LBDCreateGroupViewController.m
//  LBD
//
//  Created by Navjot on 2/10/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDCreateGroupViewController.h"
#import "MBProgressHUD.h"

@interface LBDCreateGroupViewController () <UIWebViewDelegate>
{
    UIWebView *linkedINWebView;
}

@end

@implementation LBDCreateGroupViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Group";
    [self performSelector:@selector(initUIWebView) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Setup
- (void)initUIWebView
{
    //Init and createUIWebview
    linkedINWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    linkedINWebView.delegate = self;
    linkedINWebView.frame = self.view.bounds;
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.linkedin.com/directory/groups/"]];
    
    //Load the url into the web view
    [linkedINWebView loadRequest:requestObj];
    
    [self.view addSubview:linkedINWebView];
    [linkedINWebView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Button Methods
- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebView delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:linkedINWebView animated:NO];
    [MBProgressHUD showHUDAddedTo:linkedINWebView animated:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:linkedINWebView animated:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:linkedINWebView animated:NO];
    NSLog(@"error - %@", error);
}

@end

