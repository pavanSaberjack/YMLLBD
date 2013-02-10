//
//  ScrollCarouselView.m
//  PageControlWithVerticalScroll
//
//  Created by YMediaLabs on 3/21/12.
//  Copyright (c) 2012 YMediaLabs. All rights reserved.
//

#import "ScrollCarouselView.h"

#define NOTIFICATION_DISPLAY_COUNT 3

@interface ScrollCarouselView()
@end

@implementation ScrollCarouselView

@synthesize scrollCarouselDelegate;
@synthesize loadedItems,itemSpacing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame withViewFrame:(CGRect)imgFrame withContentOffset:(CGSize )contentOffset needTap:(BOOL)isTapReq
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isTapRequired = isTapReq;
        sizeForSelectedExpansion = CGSizeMake(0, 15);
        customContentOffset = CGSizeZero;
//        scrollViews = self.selectedDataSources;
        
        sizeThumb = CGSizeMake(imgFrame.size.width, imgFrame.size.height);
        previousIndex = 0;
        currentIndex = 0;
        itemSpacing = imgFrame.size.width + 9.0;//self.frame.size.height;
        customContentOffset = contentOffset;
        
        [self createCarouselScroll];
        
        loadedItems = NOTIFICATION_DISPLAY_COUNT;

    }
    return self;
}

-(void)createCarouselScroll
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,-20,1024,self.frame.size.height+40)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.1];
    [self addSubview:bgView];
    [bgView release];
    
    scrollCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,0,1024,self.frame.size.height)];
    scrollCarousel.dataSource = self;
    scrollCarousel.delegate = self;
    scrollCarousel.contentOffset = customContentOffset;
    scrollCarousel.backgroundColor = [UIColor clearColor];
    scrollCarousel.scrollSpeed=0.66f;
    scrollCarousel.decelerationRate=0.36f;
    [self addSubview:scrollCarousel];
    scrollCarousel.type = iCarouselTypeLinear;
    //[self performSelector:@selector(delaySelect) withObject:nil afterDelay:0.3];
}

-(void)delaySelect
{
    //[self.carouselDelegate carouselScrollViewSelectedItemIndex:0];
}

- (void)scrollToIndex:(NSInteger)indexValue animationRequired:(BOOL)animation
{
    [scrollCarousel scrollToItemAtIndex:indexValue animated:animation];
}

#pragma mark -
#pragma mark iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 20; //[scrollViews count] + 1;
}

- (NSUInteger) numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return 8;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:[NSString stringWithFormat:@"%d",index] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 120, 120)];
    [button setTag:(index + 2000)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (float)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
    //[carousel reloadData];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    [scrollCarouselDelegate didScrollToItemAtIndex:carousel.currentItemIndex];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    [scrollCarouselDelegate didScrollToItemAtIndex:carousel.currentItemIndex];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    [scrollCarouselDelegate didScrollToItemAtIndex:carousel.currentItemIndex];
}

- (void)didStopScrollingAtIndex:(NSInteger)itemIndex
{
    [scrollCarouselDelegate didScrollToItemAtIndex:itemIndex];
}

- (void)refreshCarousel
{
    [scrollCarousel reloadData];
}

- (NSInteger)getCurrentItemIndex
{
    return scrollCarousel.currentItemIndex;
}

- (NSArray *)getAllItemObjects
{
    NSMutableArray * objectsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < scrollCarousel.numberOfItems; i++) {
        [objectsArray addObject:[scrollCarousel itemViewAtIndex:i]];
    }
    
    return objectsArray;
}

- (void)buttonClicked:(UIButton *)sender
{
    [self.scrollCarouselDelegate selectedProductAtIndex:(sender.tag - 2000)];
}
@end
