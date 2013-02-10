#import "ActUtility.h"

#import <objc/runtime.h>

@implementation ActUtility

+(void)makeTransitionOfType:(TransitionType)transitionType fromSide:(TransitionFrom)transitionFrom OnLayer:(CALayer *)layer withDuration:(CGFloat)duration 
{
    CATransition *animation = [CATransition animation];
    [animation setType:[ActUtility getTransitionType:transitionType]];
    [animation setSubtype:[ActUtility getTransitionSubType:transitionFrom]];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDuration:duration];
    [layer addAnimation:animation forKey:0];
}

+(NSString *const)getTransitionType:(TransitionType)transitionType
{
    NSArray *arrTransitionType = [NSArray arrayWithObjects:kCATransitionFade, kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, @"oglFlip", @"pageCurl", @"pageUnCurl", @"rippleEffect", @"suckEffect", @"cameraIrisHollowOpen", @"cameraIrisHollowClose", nil];
    return [arrTransitionType objectAtIndex:transitionType];
}

+(NSString *const)getTransitionSubType:(TransitionFrom)transitionFrom
{
    NSArray *arrTransitionSubType = [NSArray arrayWithObjects:kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom, nil];
    return [arrTransitionSubType objectAtIndex:transitionFrom];
}

+ (BOOL)checkForEmailValidationForString:(NSString *)strEmail
{
    if ([[strEmail componentsSeparatedByString:@"@"] count] == 2)
    {
        NSString *regExp = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
        if ([emailPredicate evaluateWithObject:strEmail])
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (Class)getClassNameForDefineTriggerCustomValueCellType:(NSNumber *)category
{
    NSString * classNameString = nil;
    
    switch ([category intValue]) {
        case 1:
        {
            classNameString = @"ActTriggerCustomValueCellTypeFreeTextField";
        }
            break;
            
        case 2:
        {
            classNameString = @"ActTriggerCustomValueCellTypeInteger";
        }
            break;
            
        case 3:
        {
            classNameString = @"ActTriggerCustomValueCellTypeSingleChoicePickList";
        }
            break;
            
        case 4:
        {
            classNameString = @"ActTriggerCustomValueCellTypeMultipleChoicePickList";
        }
            break;
            
        case 5:
        {
            classNameString = @"ActTriggerCustomValueCellTypeAggregateField";
        }
            break;
            
        case 6:
        {
            classNameString = @"ActTriggerCustomValueCellTypeEvent";
        }
            break;
            
        case 7:
        {
            classNameString = @"ActTriggerCustomValueCellTypeAbsoluteOrRelativeDate";
        }
            break;
            
        case 8:
        {
            classNameString = @"ActTriggerCustomValueCellTypeRelativeDateOnly";
        }
            break;
            
        case 9:
        {
            classNameString = @"ActTriggerCustomValueCellTypeReference";
        }
            break;
            
        case 10:
        {
            classNameString = @"ActTriggerCustomValueCellTypeTextArea";
        }
            break;
        default:
            break;
    }
    
    const char * a = [classNameString cStringUsingEncoding:NSUTF8StringEncoding];
    id c = objc_getClass(a);
    
    return [c class];
}

+ (void)addShadowForLabel:(UILabel *)label withSahdowColor:(UIColor *)color
{
    [label setShadowColor:color];
    [label setShadowOffset:CGSizeMake(0, 1)];
    [label.layer setShadowRadius:10];
}

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color) {
    
   // CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    //CGContextRestoreGState(context);
}

// Copying one objects properties value to other object of same type
+ (void)copyPropertiesOfObject:(id)oldObject toObject:(id)newObject
{
    unsigned int count = 0;
    objc_property_t *prop = class_copyPropertyList([oldObject class], &count);
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(prop[i]);
        NSString *propertyKey = [NSString stringWithUTF8String:propertyName];
        id valueOfProperty = [oldObject valueForKey:propertyKey];
        [newObject setValue:valueOfProperty forKey:propertyKey];
    }
}

+ (NSString *)getTimeLabelStringForValue:(NSNumber *)frequency
{
    int timeVal = [frequency intValue];
    
    if (timeVal > 0 && timeVal <= 60) return [NSString stringWithFormat:@"%dm", timeVal];
    else if (timeVal > 60 && timeVal <= 23*60) return [NSString stringWithFormat:@"%dh", (timeVal/60)];
    else return [NSString stringWithFormat:@"%dd", (timeVal/(60*24))];
    
    return nil;
}

+ (NSNumber *)getTimeValue:(NSString *)frequency
{
    NSNumber * number = nil;
    
    if ([frequency rangeOfString:@"Minutes"].location != NSNotFound) {
        //
        number = @([frequency integerValue]);
    }
    else if ([frequency rangeOfString:@"Hours"].location != NSNotFound)
    {
        NSString *numberOfHours = [frequency componentsSeparatedByString:@" "][0];
        number = @([numberOfHours integerValue] * 60);
    }
    else if ([frequency rangeOfString:@"Day"].location != NSNotFound)
    {
        NSString *numberOfDays = [frequency componentsSeparatedByString:@" "][0];
        number = @([numberOfDays intValue] * 24 * 60);
    }
    
    return number;
}
@end
