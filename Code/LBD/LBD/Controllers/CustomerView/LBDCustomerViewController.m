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

@interface LBDCustomerViewController ()<PICustomViewDelegate>

@end

@implementation LBDCustomerViewController

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
    
    PICustomView *customView = [[PICustomView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
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
- (void)productSelectedAtIndexPath:(NSUInteger)rowIndex withVendorIndex:(NSUInteger)verdorIndex withProductIndex:(NSUInteger)productIndex
{
    NSLog(@"%d, %d, %d",rowIndex, verdorIndex, productIndex);
    
    LBDProductViewController *productView = [[LBDProductViewController alloc] init];
    [self.navigationController pushViewController:productView animated:YES];
    [productView release];
}
@end
