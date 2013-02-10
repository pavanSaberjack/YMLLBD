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
    PICustomButton *closeButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(self.frame.size.width - 20, 2, 20, 20)];
    [closeButton setBackgroundColor:[UIColor blackColor]];
    [closeButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 25, self.frame.size.width, 50)];
    [lbl setText:@"Do you want to ask question on this part?"];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setNumberOfLines:2];
    [self addSubview:lbl];
    
    PICustomButton *continueButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
    [continueButton setFrame:CGRectMake(self.center.x - 40, self.frame.size.height- 35, 80, 30)];
    [continueButton setBackgroundColor:[UIColor greenColor]];
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
    [self.delegate continueButtonClickedForCoordinate:self.center];
    
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
