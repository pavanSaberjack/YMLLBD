//
//  PICustomButton.m
//  BlocksLearning
//
//  Created by pavan on 1/13/13.
//  Copyright (c) 2013 pavan. All rights reserved.
//

#import "PICustomButton.h"

@implementation PICustomButton

@synthesize pID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)handleControlEvents:(UIControlEvents)event forBlock:(buttonBlock)onClickBlock
{
    #warning button should be custom 
    
    _buttonClickedBlock = onClickBlock ;
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:event];
}

- (void)buttonClicked:(UIButton *)sender
{
    _buttonClickedBlock();
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
