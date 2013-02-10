//
//  QuestionsView.m
//  LBD
//
//  Created by Pavan Itagi on 10/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "QuestionsView.h"

@implementation QuestionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}


- (void) createView
{
    UITableView *tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 300)];
    [tab setDelegate:self];
    [tab setDataSource:self];
    [self addSubview:tab];
    
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
