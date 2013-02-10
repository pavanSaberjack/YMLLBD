//
//  PICustomView.h
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 Pavan Itagi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PICustomViewDelegate;

@interface PICustomView : UIView
@property (nonatomic, assign)id<PICustomViewDelegate>delegate;
- (void)reloadTheViewWithVendorsArray:(NSArray *)verdorsArray;

@end

@protocol PICustomViewDelegate <NSObject>

- (void)productSelectedAtIndexPath:(NSUInteger)rowIndex withVendorIndex:(NSUInteger)verdorIndex withProductIndex:(NSUInteger)productIndex;

@end