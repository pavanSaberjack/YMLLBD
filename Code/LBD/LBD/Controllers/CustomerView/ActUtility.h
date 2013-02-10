#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//#import "ActEnums.h"

typedef enum
{
    TransitionFromLeft = 0,
    TransitionFromRight,
    TransitionFromTop,
    TransitionFromBottom
}TransitionFrom;

typedef enum
{
    TransitionTypeFade = 0,
    TransitionTypePush,
    TransitionTypeMoveIn,
    TransitionTypeReveal,
    TransitionTypeFlip,
    TransitionTypeCurlUp,
    TransitionTypeCurlDown,
    TransitionTypeRippleEffect,
    TransitionTypeSuckEffect,
    TransitionTypeCameraOpen,
    TransitionTypeCameraClose
}TransitionType;


@interface ActUtility : NSObject
{
    
}

+(NSString *const)getTransitionSubType:(TransitionFrom)transitionFrom;
+(NSString *const)getTransitionType:(TransitionType)transitionType;
+(void)makeTransitionOfType:(TransitionType)transitionType fromSide:(TransitionFrom)transitionFrom OnLayer:(CALayer *)layer withDuration:(CGFloat)duration;
+ (BOOL)checkForEmailValidationForString:(NSString *)strEmail;
+ (Class)getClassNameForDefineTriggerCustomValueCellType:(NSNumber *)category;

+ (void)addShadowForLabel:(UILabel *)label withSahdowColor:(UIColor *)color;

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

+ (void)copyPropertiesOfObject:(id)oldObject toObject:(id)newObject;

+ (NSString *)getTimeLabelStringForValue:(NSNumber *)frequency;
+ (NSNumber *)getTimeValue:(NSString *)frequency;
@end
