//
//  LBDProductViewController.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDProductViewController.h"
#import "LBDCustomPopUpView.h"
@interface LBDProductViewController ()<LBDCustomPopUpViewDelegate>

@end

@implementation LBDProductViewController

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
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 400, 400)];
    [imgView setBackgroundColor:[UIColor redColor]];
    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [imgView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:2];
    [tapGesture release];
    [imgView release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark _ tohces method
- (void)tapped:(UITapGestureRecognizer *)sender
{
    UIView *senderView = sender.view;
    CGPoint p = [sender locationInView:self.view];
    NSLog(@"%@", [NSValue valueWithCGPoint:p]);
    
    // Add question for co-ordinate
    
    LBDCustomPopUpView *popUpView = [[LBDCustomPopUpView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    [popUpView setCoordinatePoint:[sender locationInView:senderView]];
    [popUpView setDelegate:self];
    [popUpView setBackgroundColor:[UIColor blueColor]];
    popUpView.center = p;
    [ActUtility makeTransitionOfType:TransitionTypeFade fromSide:TransitionFromBottom OnLayer:senderView.layer withDuration:0.4];
    [self.view addSubview:popUpView];
    
    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    for (UIGestureRecognizer *gesture in touch.gestureRecognizers) {
        if (gesture.numberOfTouches == 2 ) {
            NSLog(@"double tap");
        }
    }
    
}

#pragma mark - LBDCustomPopUpViewDelegate methods
- (void)continueButtonClickedForCoordinate:(CGPoint)point
{
    // Add Question at this co-ordinate
    
    NSLog(@"Ask question for co-orduinate at %@", [NSValue valueWithCGPoint:point]);
}
@end
