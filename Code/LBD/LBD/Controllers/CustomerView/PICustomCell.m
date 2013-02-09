//
//  PICustomCell.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 Pavan Itagi. All rights reserved.
//

#import "PICustomCell.h"
#import "PICustomButton.h"
@interface PICustomCell()
{
    UIView *view;
}

@end

@implementation PICustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.frame;
    rect.size.width = 1024;
    self.contentView.frame = rect;
    
    
    rect = self.frame;
    self.frame = rect;
    
    NSLog(@"%@", [NSValue valueWithCGRect:self.contentView.frame]);
    
    
    
    
}

#pragma mark - UI CreationMethod
- (void)createTheView
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setClipsToBounds:YES];
    [self setAutoresizesSubviews:YES];
    
    
    
    
    NSLog(@"%@", [NSValue valueWithCGRect:self.contentView.frame]);
    
    int numberOfViews = [self.dataSource numberOfComponentsForRowIndexPath:self.cellIndexPath];
    
    CGFloat width = 1024.00 / numberOfViews;
    CGFloat x = 80.0f;
    CGFloat y = 20.0f;
    
    for (int i = 0; i < numberOfViews; i++) {
        PICustomButton *customButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
        [customButton setFrame:CGRectMake(x, y, 150, 150)];
        [customButton setBackgroundColor:[UIColor blueColor]];
        [customButton setTag:i];
        [customButton addTarget:self action:@selector(componentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:customButton];
        
        x += width;
    }
}

- (void)addTheCarouselToCell:(id)carouselView
{
    CGRect frame = ((UIView *)carouselView).frame;
    frame.origin.y = 220;
    [carouselView setFrame:frame];
    
    [self.contentView addSubview:carouselView];
}

#pragma mark - button Click methods
- (void)componentClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cellButtonClickedAtIndexPath:forComponent:)]) {
        [self.delegate cellButtonClickedAtIndexPath:self.cellIndexPath forComponent:sender.tag];
    }
}
@end
