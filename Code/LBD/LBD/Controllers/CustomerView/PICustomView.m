//
//  PICustomView.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 Pavan Itagi. All rights reserved.
//

#import "PICustomView.h"
#import "PICustomCell.h"
#import "ScrollCarouselView.h"
#import "LBDProductViewController.h"

#define NUMBER_OF_COMPONENTS 3

@interface PICustomView()<UITableViewDataSource, UITableViewDelegate, PICustomCellDelegate, ScrollCarouselViewDelegate, PICustomCellDataSource>
{
    UITableView *venderTableView; // table veiw for venders
    
    NSUInteger selectedIndex;
    NSUInteger previousIndex;
    NSUInteger selectedComponent;
    
    ScrollCarouselView *scrollCarouselView;
}
@end

@implementation PICustomView

- (void)dealloc
{
    
    [venderTableView release];
    
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        selectedIndex = -1;
        previousIndex = -1;
        selectedComponent = -1;
        
        [self createTheView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Private methods
- (void)createTheView
{
    venderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,1024.0f, 748.0f) style:UITableViewStylePlain];
    [venderTableView setSeparatorColor:[UIColor clearColor]];
    [venderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [venderTableView setBackgroundColor:[UIColor clearColor]];
    [venderTableView setDelegate:self];
    [venderTableView setDataSource:self];
    [self addSubview:venderTableView];
    
    [self createCarouselView];
}

- (void)createCarouselView
{
    CGRect pageRect = CGRectMake(0.0f, 48.0f, self.frame.size.width, 100);
    CGRect imageRect = CGRectMake(0, 0, 100, 100);
    
    scrollCarouselView = [[ScrollCarouselView alloc] initWithFrame:pageRect withViewFrame:imageRect withContentOffset:CGSizeMake(-360, 0) needTap:YES];
    
    scrollCarouselView.scrollCarouselDelegate = self;
    scrollCarouselView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    
    PICustomCell *cell = (PICustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[PICustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        [cell setDelegate:self];
        [cell setDataSource:self];
        [cell createTheView];
    }    
        
    [cell setCellIndexPath:indexPath];
    
    // use NUMBER of components Value get array and send for creation
    
    if (selectedIndex == indexPath.row) {
        [cell addTheCarouselToCell:scrollCarouselView];
    }
    else
    {
        if ([scrollCarouselView superview]) {
            [cell removeCarousel:scrollCarouselView];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedIndex) {
        return 400.0f;
    }
    return 250.0f;
}

#pragma mark - PICustomCellDelegate methods
- (void)cellButtonClickedAtIndexPath:(NSIndexPath *)indexPath forComponent:(NSUInteger)component
{    
    if (selectedIndex == indexPath.row)
    {
        previousIndex = -1;
        selectedIndex = -1;
        selectedComponent = -1;
        
        [venderTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        previousIndex = selectedIndex;
        selectedIndex = indexPath.row;
        selectedComponent = component;
        
        NSArray *indexPathArray;
        
        if (previousIndex != -1) indexPathArray = @[[NSIndexPath indexPathForRow:previousIndex inSection:0], [NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        else indexPathArray = @[[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        
        [venderTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        
        [venderTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSArray *visibleCellsArray = [venderTableView visibleCells];
    for (PICustomCell *cell in visibleCellsArray) {
        [cell fadeCellsWithSelectedIndex:selectedIndex forComponent:selectedComponent];
    }    
    
//    [venderTableView reloadData];
}

#pragma mark - PICustomCellDataSource methods
- (NSUInteger)numberOfComponentsForRowIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

#pragma mark - ScrollCarouselViewDelegate methods
- (void)didScrollToItemAtIndex:(NSInteger)itemIndex
{
    NSLog(@"selected product index %d", itemIndex);
}

- (void)selectedProductAtIndex:(NSUInteger)productIndex
{
    // Call the product view from here
    
    [self.delegate productSelectedAtIndexPath:selectedIndex withVendorIndex:(selectedComponent-1000) withProductIndex:productIndex];
}
@end
