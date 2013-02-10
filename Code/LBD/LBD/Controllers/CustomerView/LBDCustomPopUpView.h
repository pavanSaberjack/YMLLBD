//
//  LBDCustomPopUpView.h
//  LBD
//
//  Created by Pavan Itagi on 10/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBDCustomPopUpViewDelegate;
@interface LBDCustomPopUpView : UIView
@property (nonatomic, assign) id<LBDCustomPopUpViewDelegate>delegate;
@property (nonatomic, assign) CGPoint coordinatePoint;
@end

@protocol LBDCustomPopUpViewDelegate <NSObject>

- (void)continueButtonClickedForCoordinate:(CGPoint)point;

@end