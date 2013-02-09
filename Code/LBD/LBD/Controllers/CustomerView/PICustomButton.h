//
//  PICustomButton.h
//  BlocksLearning
//
//  Created by pavan on 1/13/13.
//  Copyright (c) 2013 pavan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)();
@interface PICustomButton : UIButton
{
    buttonBlock _buttonClickedBlock;
}
- (void)handleControlEvents:(UIControlEvents)event forBlock:(buttonBlock)onClickBlock;
@end
