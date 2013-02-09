//
//  ScrollCarouselView.h
//  PageControlWithVerticalScroll
//
//  Created by YMediaLabs on 3/21/12.
//  Copyright (c) 2012 YMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol ScrollCarouselViewDelegate <NSObject>

- (void)didScrollToItemAtIndex:(NSInteger)itemIndex;
- (void)selectedProductAtIndex:(NSUInteger)productIndex;
@optional
- (void)willBeginDraggingAtIndex:(NSInteger)itemIndex;
- (void)swipeToRightFromIndex:(NSInteger)itemIndex;
- (void)swipeToLeftFromIndex:(NSInteger)itemIndex;

@end

@interface ScrollCarouselView : UIView<iCarouselDataSource, iCarouselDelegate,UIScrollViewDelegate>
{
    int loadedItems;
    id<ScrollCarouselViewDelegate> scrollCarouselDelegate;
    iCarousel *scrollCarousel;
    NSMutableArray *scrollViews;
    NSInteger currentIndex;
    NSInteger previousIndex;
    CGSize sizeThumb;
    CGFloat itemSpacing;
    NSInteger type;
    
    CGSize customContentOffset;
    
    CGSize sizeForSelectedExpansion;
    UIImageView *backgroundImageView;
    
    BOOL isTapRequired;
}

@property (nonatomic, readwrite) int loadedItems;
@property(nonatomic, strong)id<ScrollCarouselViewDelegate> scrollCarouselDelegate;
@property (nonatomic, readwrite) CGFloat itemSpacing;

-(id)initWithFrame:(CGRect)frame withViewFrame:(CGRect)imgFrame withContentOffset:(CGSize )contentOffset needTap:(BOOL)isTapReq;

- (void)createCarouselScroll;
- (void)scrollToIndex:(NSInteger)indexValue animationRequired:(BOOL)animation;
- (void)changeViewBackground;
- (NSInteger)getCurrentItemIndex;

- (void)refreshCarousel;
- (NSArray *)getAllItemObjects;
@end
