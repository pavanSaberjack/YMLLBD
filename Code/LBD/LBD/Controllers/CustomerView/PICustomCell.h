//
//  PICustomCell.h
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 Pavan Itagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PICustomCellDelegate;
@protocol PICustomCellDataSource;

@interface PICustomCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) id<PICustomCellDelegate>delegate;
@property (nonatomic, assign) id<PICustomCellDataSource>dataSource;
- (void)createTheView;
- (void)createTheCellWithViews:(NSArray *)objects;
- (void)addTheCarouselToCell:(id)carouselView;
- (void)removeCarousel:(id)carouselView;
- (void) fadeCellsWithSelectedIndex:(NSUInteger)selectedIndex forComponent:(NSUInteger)selectedComponent;
- (void)clearState;
- (void)fadeViews;
@end

@protocol PICustomCellDelegate <NSObject>
- (void)cellButtonClickedAtIndexPath:(NSIndexPath *)indexPath forComponent:(NSUInteger)component;
@end

@protocol PICustomCellDataSource <NSObject>
- (NSUInteger)numberOfComponentsForRowIndexPath:(NSIndexPath *)indexPath;
@end
