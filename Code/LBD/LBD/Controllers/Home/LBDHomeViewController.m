//
//  LBDHomeViewController.m
//  LBD
//
//  Created by Navjot on 2/9/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDHomeViewController.h"
#import "LinkedInLoginService.h"
#import "MBProgressHUD.h"
#import "LBDCustomerViewController.h"

@interface LBDHomeViewController ()
{
    LinkedInLoginService *loginService;
    LBDUser *currentUser;
}

@end

@implementation LBDHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loginService = [[LinkedInLoginService alloc] init];
    }
    return self;
}

-(void)downloadImage //NS: store the image also -- downloading each time right now
{
//    if([[currentUser.extras allKeys] containsObject:@"pictureURL"])
//    {
//        NSLog(@"downloadImage for - %@", currentUser.serviceName);
//        [MBProgressHUD showDimmedHUDAddedTo:profileImage animated:NO];
//        [WebImageOperations processImageDataWithURLString:[currentUser.extras objectForKey:@"pictureURL"] andBlock:^(NSData *itemImageData) {
//            
//            UIImage *itemImage = [UIImage imageWithData:itemImageData];
//            if(itemImage && itemImage.size.width!=0 && itemImage.size.height!=0)
//            {
//                itemImage = [itemImage imageScaledToFitSize:itemImage.size];
//                [profileImage setImage:itemImage];
//                [profileImage setBackgroundColor:[UIColor clearColor]];
//                
//                appDel.profileImage = profileImage.image;
//            }
//            [MBProgressHUD hideHUDForView:profileImage animated:YES];
//        }];
//        
//    }
}

-(void)serviceDidLoginWithUserInfo:(id)userInfo
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    currentUser = (LBDUser *)userInfo;
    NSLog(@"loggedIN - %@", currentUser);
    
    // Push Customer View
    LBDCustomerViewController *customer = [[LBDCustomerViewController alloc] init];
    [self.navigationController pushViewController:customer animated:YES];
    
    
    //[self downloadImage]; 
}

- (void)login:(id)sender
{
    NSLog(@"Login!");
    
    if([loginService isServiceAvailable])
    {
        [MBProgressHUD showDimmedHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:NO];
        [self serviceDidLoginWithUserInfo:[loginService getAccountInfo]];        
    }
    else
    {
        UIWebView *LinkedInWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
        LinkedInWebView.autoresizesSubviews = YES;
        LinkedInWebView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        [[self view] addSubview:LinkedInWebView];
        
        [loginService loginWithWebView:LinkedInWebView onCompletion:^(LBDUser *user) {
            
            [self serviceDidLoginWithUserInfo:user];

        }];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *loginImg = [UIImage imageNamed:@"login_with_linkedin"];
    NSLog(@"%f, %f", self.view.frame.size.width, self.view.frame.size.height);
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.height/2-loginImg.size.width/2,
                                                                    self.view.frame.size.width/2+50.0,
                                                                    loginImg.size.width,
                                                                    loginImg.size.height)];
    [loginBtn setImage:loginImg forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc
{
    [loginService release];
    [currentUser release];
    [super dealloc];
}

@end
