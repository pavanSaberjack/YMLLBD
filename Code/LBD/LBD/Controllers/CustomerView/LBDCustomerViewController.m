//
//  LBDCustomerViewController.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDCustomerViewController.h"
#import "PICustomView.h"
#import "LBDProductViewController.h"
#import "JSON.h"
#import "APIManager.h"
#import "MBProgressHUD.h"

@interface LBDCustomerViewController ()<PICustomViewDelegate, UITextFieldDelegate>
{
    NSMutableString *searchStr;
    
    NSTimer *searchTimer;
    BOOL timerON;
    
    UITextField *searchTextField;
    APIManager *apiManager;
    
    PICustomView *customView;
}
@end

@implementation LBDCustomerViewController

@synthesize title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchStr = [[NSMutableString alloc] initWithString:@""];
        apiManager = [[APIManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.height, self.view.frame.size.width)];
//    [bgView setImage:[UIImage imageNamed:@"blackBG"]];
//    [bgView setUserInteractionEnabled:YES];
//    [self.view addSubview:bgView];
//    [bgView release];

    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0,
                                                                    20.0,
                                                                    self.view.frame.size.height-20.0,
                                                                    32.0)];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    [searchTextField setDelegate:self];
    [searchTextField setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    [searchTextField setTextAlignment:UITextAlignmentLeft];
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [searchTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchTextField setReturnKeyType:UIReturnKeySearch];
    [searchTextField setTextColor:[UIColor grayColor]];
    [searchTextField setText:@" search for something..."];
    [self.view addSubview:searchTextField];
    [searchTextField release];

    customView = [[PICustomView alloc] initWithFrame:CGRectMake(0.0, 52.0, self.view.frame.size.height, self.view.frame.size.height)];
    [customView setDelegate:self];
    [self.view addSubview:customView];
    [customView release];
    
	// Do any additional setup after loading the view.
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

#pragma mark - PICustomViewDelegate methods
- (void)productSelectedAtIndexPath:(NSUInteger)rowIndex withVendorIndex:(NSString *)verdorIndex withProductIndex:(NSString *)productIndex
{
//    NSLog(@"%d, %d, %d",rowIndex, verdorIndex, productIndex);
//    
//    
//    id vender = (3 * rowIndex) + verdorIndex;
    
    LBDProductViewController *productView = [[LBDProductViewController alloc] initWithVenderId:@"" WithProductId:@""];
    [self.navigationController pushViewController:productView animated:YES];
    [productView release];
}

- (void)dealloc
{
    self.title = nil;
    [searchStr release];
    [apiManager release];
    [super dealloc];
}

#pragma mark - TextField methods
#pragma mark - TextField Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@" search for something..."])
    {
        [textField setText:@""];
        [textField setTextColor:[UIColor blackColor]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [textField setText:@" search for something..."];
        [textField setTextColor:[UIColor grayColor]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string && ![string isEqualToString:@""])
    {
        [searchStr appendString:string];
    }
    else
    {
        [searchStr deleteCharactersInRange:NSMakeRange([searchStr length]-1, 1)];
    }
    NSLog(@"search Str - %@",searchStr);
    
    if(![searchStr isEqualToString:@""])
    {
        if(timerON)
        {
            [searchTimer invalidate];
            searchTimer = nil;
        }
        
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                                     selector:@selector(searchTimerFired:)
                                                     userInfo:nil repeats:NO];
        timerON = TRUE;
    }
    else
    {
        NSLog(@"Empty Search Field");
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchTimerFired:(NSTimer *)aTimer
{
    NSLog(@"Search - %@", searchStr);
    timerON = FALSE;

    [MBProgressHUD showDimmedHUDAddedTo:self.view animated:YES];
    [apiManager fetchResultsFor:searchStr withCallback:^(BOOL success, id result){
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success)
        {
            NSLog(@"SEACRH SUCCESS - %@", [result objectForKey:@"products"]);
            
            [customView reloadTheViewWithVendorsArray:[result objectForKey:@"products"]];
        }
        else
        {
            NSLog(@"FAILURE - %@", result);
        }
    }];    
}

@end
