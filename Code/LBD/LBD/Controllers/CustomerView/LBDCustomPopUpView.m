//
//  LBDCustomPopUpView.m
//  LBD
//
//  Created by Pavan Itagi on 10/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDCustomPopUpView.h"

@implementation LBDCustomPopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createTheView];
    }
    return self;
}


- (void)createTheView
{
    self.layer.masksToBounds = NO;
    [self setBackgroundColor:[UIColor darkGrayColor]];
    self.layer.cornerRadius = 8; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(-15, 20);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 50)];
    [lbl1 setText:@"Localize"];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    [lbl1 setTextAlignment:NSTextAlignmentCenter];
    [lbl1 setTextColor:[UIColor whiteColor]];
    [lbl1 setNumberOfLines:2];
    [self addSubview:lbl1];
    
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, self.frame.size.width, 50)];
    [lbl setText:@"Do you want to ask question on this part?"];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setNumberOfLines:2];
    [self addSubview:lbl];
    
    
    PICustomButton *closeButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(self.center.x - 100, self.frame.size.height- 50, 80, 30)];
    [closeButton setBackgroundColor:[UIColor grayColor]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    PICustomButton *continueButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
    [continueButton setFrame:CGRectMake(self.center.x + 40, self.frame.size.height- 50, 80, 30)];
    [continueButton setBackgroundColor:[UIColor grayColor]];
    [continueButton setTitle:@"OK" forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:continueButton];
}

- (void)remove
{
    [self removeFromSuperview];
}

- (void)continueClicked
{
    [self.delegate continueButtonClickedForCoordinate:self.center forView:self.superview];
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
