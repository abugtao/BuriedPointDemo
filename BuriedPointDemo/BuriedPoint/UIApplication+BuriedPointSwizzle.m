//
//  UIApplication+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/31.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UIApplication+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"
@implementation UIApplication (BuriedPointSwizzle)

//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        SEL originSel = @selector(sendAction:to:from:forEvent:);
//        SEL swizzleSel = @selector(swizzleSendAction:to:from:forEvent:);
//        [self swizzleInClass:self originalSelector:originSel swizzledSelector:swizzleSel];
//    });
//}

-(BOOL)swizzleSendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(action));
    
    return [self swizzleSendAction:action to:target from:sender forEvent:event];
}

@end
