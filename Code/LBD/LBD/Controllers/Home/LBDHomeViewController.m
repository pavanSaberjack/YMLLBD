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
#import <QuartzCore/QuartzCore.h>
#import "WebImageOperations.h"
#import "UIImage+ProportionalFill.h"
#import "LBDCreateGroupViewController.h"

@interface LBDHomeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    LinkedInLoginService *loginService;
    LBDUser *currentUser;
    UIButton *loginBtn;
    UITableView *rolesTable;
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
    UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100.0, 10.0, 80.0, 80.0)];
    
    CALayer *layer2 = [profileImage layer];
    [layer2 setShadowOffset:CGSizeMake(0.0, 2.0)];
    [layer2 setShadowColor:[UIColor colorWithRed:(150/255.f) green:(150/255.f) blue:(150/255.f) alpha:1.0].CGColor];
    [layer2 setShadowRadius:2.0];
    [layer2 setShadowOpacity:1.0];

    [profileImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:profileImage];
    [profileImage release];
    
    if([[currentUser.extras allKeys] containsObject:@"pictureURL"])
    {
        NSLog(@"downloadImage for - %@", currentUser.serviceName);
        [WebImageOperations processImageDataWithURLString:[currentUser.extras objectForKey:@"pictureURL"] andBlock:^(NSData *itemImageData) {
            
            UIImage *itemImage = [UIImage imageWithData:itemImageData];
            if(itemImage && itemImage.size.width!=0 && itemImage.size.height!=0)
            {
                itemImage = [itemImage imageScaledToFitSize:itemImage.size];
                [profileImage setImage:itemImage];
                [profileImage setBackgroundColor:[UIColor clearColor]];                
            }
        }];
        
    }
}

- (void)disableLogin
{
    [loginBtn setUserInteractionEnabled:NO];
    [loginBtn setHidden:YES];
}

- (void)enableLogin
{
    [loginBtn setUserInteractionEnabled:YES];
    [loginBtn setHidden:NO];
}

-(void)serviceDidLoginWithUserInfo:(id)userInfo
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    currentUser = (LBDUser *)userInfo;
    NSLog(@"loggedIN - %@", currentUser);
    
    [self disableLogin];
    [self downloadImage];    
    [self bringOnRoleView];
}

- (void)bringOnRoleView
{
    rolesTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0.0, 0.0) style:UITableViewStyleGrouped];
 
    CALayer *layer = [rolesTable layer];
    [layer setCornerRadius:10.0];
    layer.masksToBounds = YES;

    [rolesTable setDataSource:self];
    [rolesTable setDelegate:self];
    [rolesTable setAlpha:0.0];
    [self.view addSubview:rolesTable];
    [rolesTable release];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        [rolesTable setAlpha:1.0];
        [rolesTable setFrame:CGRectMake(self.view.frame.size.width/2-800/2, self.view.frame.size.height/2-800/(1.6*2) , 800.0, 800.0/1.6)];
    }];
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
        LinkedInWebView.frame = self.view.bounds;
        //LinkedInWebView.autoresizesSubviews = YES;
        //LinkedInWebView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        [[self view] addSubview:LinkedInWebView];
        
        [loginService loginWithWebView:LinkedInWebView onCompletion:^(LBDUser *user) {
            
            [self serviceDidLoginWithUserInfo:user];

        }];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *loginImg = [UIImage imageNamed:@"login_with_linkedin"];
    NSLog(@"%f, %f", self.view.frame.size.width, self.view.frame.size.height);
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.height/2-loginImg.size.width/2,
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

#pragma mark - UITableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"Consumer";
    }
    else
    {
        return @"Vendor";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else
    {
        if([currentUser.extras objectForKey:@"companies"])
        {
            return [[currentUser.extras objectForKey:@"companies"] count]+1;
        }
        else
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"roleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    if(indexPath.section==0)
    {
        [cell.textLabel setText:currentUser.userName];
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row<[[currentUser.extras objectForKey:@"companies"] count])
        {
            [cell.textLabel setText:[[[currentUser.extras objectForKey:@"companies"] objectAtIndex:indexPath.row] objectForKey:@"name"]];
        }
        else
        {
            [cell.textLabel setText:@"+"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([indexPath section] == 0)
    {
        // logged in as user
        [[LBDUser currentUser]setType:USER_CONSUMER];
    }
    else if([indexPath section] == 1)
    {
        // logged in as vendor
        [[LBDUser currentUser]setType:USER_VENDOR];
    }
    
    UITableViewCell *tappedCell = [tableView cellForRowAtIndexPath:indexPath];
    if([tappedCell.textLabel.text isEqualToString:@"+"])
    {
        NSLog(@"Direct him to a webview with the new group creation call.");
        [self createGroupsOnWeb];
    }
    else
    {
        // Push Customer View
        LBDCustomerViewController *customerVC = [[LBDCustomerViewController alloc] init];
        [customerVC setTitle:tappedCell.textLabel.text];
        [self.navigationController pushViewController:customerVC animated:YES];
        [customerVC release];
    }
}

- (void)createGroupsOnWeb
{
    LBDCreateGroupViewController *createGroupVC = [[LBDCreateGroupViewController alloc] init];
    [self.navigationController pushViewController:createGroupVC animated:YES];
    [createGroupVC release];
}

@end
