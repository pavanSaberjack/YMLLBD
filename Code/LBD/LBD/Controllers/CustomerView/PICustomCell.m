//
//  PICustomCell.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 Pavan Itagi. All rights reserved.
//

#import "PICustomCell.h"
#import "PICustomButton.h"
#import <QuartzCore/QuartzCore.h>

@interface PICustomCell()
{
    UIView *vendersView;
}
@end

@implementation PICustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        vendersView = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 300)];
        [self.contentView addSubview:vendersView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGRect rect = self.contentView.frame;
//    rect.size.width = 1024;
//    self.contentView.frame = rect;
//    
//    
//    rect = self.frame;
//    self.frame = rect;
//    
//    NSLog(@"%@", [NSValue valueWithCGRect:self.contentView.frame]);
//    
//}

#pragma mark - UI CreationMethod
- (void)createTheViewWith:(NSArray *)vendorsList
{
    for (id view in [vendersView subviews]) {
        [view removeFromSuperview];
    }
    
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setClipsToBounds:YES];
    [self setAutoresizesSubviews:YES];
    
    int numberOfViews = [self.dataSource numberOfComponentsForRowIndexPath:self.cellIndexPath];
    
    CGFloat width = 1024.00 / numberOfViews;
    CGFloat x = 80.0f;
    CGFloat y = 20.0f;
    
    for (int i = 0; i < [vendorsList count]; i++)
    {
        PICustomButton *customButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
        [customButton setFrame:CGRectMake(x, y, 150, 150)];
        [customButton setBackgroundColor:[UIColor whiteColor]];
        [customButton setTag:(1000 + i)];
        [customButton addTarget:self action:@selector(componentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer2 = [customButton layer];
        [layer2 setShadowOffset:CGSizeMake(0.0, 3.0)];
        [layer2 setShadowColor:[UIColor colorWithRed:(150/255.f) green:(150/255.f) blue:(150/255.f) alpha:1.0].CGColor];
        [layer2 setShadowRadius:3.0];
        [layer2 setShadowOpacity:1.0];
        
        [vendersView addSubview:customButton];
        
        x += width;
    }

}

//- (void)createTheView
//{
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [self setClipsToBounds:YES];
//    [self setAutoresizesSubviews:YES];
//    
//    int numberOfViews = [self.dataSource numberOfComponentsForRowIndexPath:self.cellIndexPath];
//    
//    CGFloat width = 1024.00 / numberOfViews;
//    CGFloat x = 80.0f;
//    CGFloat y = 20.0f;
//    
//    for (int i = 0; i < numberOfViews; i++)
//    {
//        PICustomButton *customButton = [PICustomButton buttonWithType:UIButtonTypeCustom];
//        [customButton setFrame:CGRectMake(x, y, 150, 150)];
//        [customButton setBackgroundColor:[UIColor whiteColor]];
//        [customButton setTag:(1000 + i)];
//        [customButton addTarget:self action:@selector(componentClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        CALayer *layer2 = [customButton layer];
//        [layer2 setShadowOffset:CGSizeMake(0.0, 3.0)];
//        [layer2 setShadowColor:[UIColor colorWithRed:(150/255.f) green:(150/255.f) blue:(150/255.f) alpha:1.0].CGColor];
//        [layer2 setShadowRadius:3.0];
//        [layer2 setShadowOpacity:1.0];
//                
//        [self.contentView addSubview:customButton];
//        
//        x += width;
//    }
//}

- (void)addTheCarouselToCell:(id)carouselView
{
//    CGRect frame = ((UIView *)carouselView).frame;
//    frame.origin.y = 220;
//    [carouselView setFrame:frame];
    
//    [carouselView setAlpha:1.0f];
    [self.contentView addSubview:carouselView];
}

- (void)removeCarousel:(id)carouselView
{
    [UIView animateWithDuration:0.1 animations:^{
//        [carouselView setAlpha:0.0f];
        [carouselView removeFromSuperview];
    } completion:^(BOOL finished) {
//        [carouselView removeFromSuperview];
    }];
}

- (void) fadeCellsWithSelectedIndex:(NSUInteger)selectedIndex forComponent:(NSUInteger)selectedComponent
{
    int numberOfViews = [self.dataSource numberOfComponentsForRowIndexPath:self.cellIndexPath];
    
    for (int i = 0; i < numberOfViews; i++) {
        id subview = [vendersView viewWithTag:(1000 + i)];
        
        if (![subview isKindOfClass:[PICustomButton class]]) {
            continue;
        }
        
        PICustomButton *button = (PICustomButton *)subview;
        
        if (selectedIndex == -1) {
            [button setAlpha:1.0];
            continue;
        }
        
        
        [button setAlpha:0.2];
        if (selectedIndex == self.cellIndexPath.row) {
            if (selectedComponent == (i + 1000)) {
                [button setAlpha:1.0];
            }
        }
    }
    
}

#pragma mark - button Click methods
- (void)componentClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cellButtonClickedAtIndexPath:forComponent:)]) {
        [self.delegate cellButtonClickedAtIndexPath:self.cellIndexPath forComponent:sender.tag];
    }
}
@end
