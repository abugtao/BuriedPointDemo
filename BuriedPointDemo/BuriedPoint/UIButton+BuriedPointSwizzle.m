//
//  UIButton+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/31.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UIButton+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"
@implementation UIButton (BuriedPointSwizzle)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(sendAction:to:forEvent:);
        
        SEL swizzleSel = @selector(swizzleSendAction:to:forEvent:);
        [self swizzleInClass:self originalSelector:originSel swizzledSelector:swizzleSel];
    });
}
-(void)swizzleSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    NSString *eventSign = [BuriedPointTool getClickEventSign:action to:target forEvent:event];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    NSLog(@"点击了按钮---%@---点击时间%@",eventSign,dateStr);
    [self swizzleSendAction:action to:target forEvent:event];
}
@end
