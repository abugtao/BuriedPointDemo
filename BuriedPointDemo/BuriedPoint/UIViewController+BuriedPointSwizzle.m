//
//  UIViewController+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/6/11.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UIViewController+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"

#import <objc/runtime.h>

static const void *pageVCEnterTimeKey = &pageVCEnterTimeKey;
static const void *pageVCLeaveTimeKey = &pageVCLeaveTimeKey;
static const void *pageVCStayTimeKey = &pageVCStayTimeKey;

@implementation UIViewController (BuriedPointSwizzle)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //页面进入方法替换
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(buriedPoint_viewDidAppear:);
        [self swizzleInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        
        //页面离开方法替换
        SEL originalSelector2 = @selector(viewDidDisappear:);
        SEL swizzledSelector2 = @selector(buriedPoint_viewDidDisappear:);
        [self swizzleInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
        
        
    });
}


-(void)buriedPoint_viewDidAppear:(BOOL)animated{
    
    NSString *eventSign = [BuriedPointTool getPageEventSign:self];
    self.pageVCEnterTime = [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    NSLog(@"进入了---%@---页面----进入页面时间%@",eventSign,dateStr);
    
    
    [self buriedPoint_viewDidAppear:animated];
}

-(void)buriedPoint_viewDidDisappear:(BOOL)animated{
    NSString *eventSign = [BuriedPointTool getPageEventSign:self];
    self.pageVCLeaveTime = [[NSDate date] timeIntervalSince1970];
    self.pageVCStayTime = self.pageVCLeaveTime - self.pageVCEnterTime;
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    NSLog(@"离开了---%@---页面----离开页面时间%@---页面停留时间%fs",eventSign,dateStr,self.pageVCStayTime);
    
    
    [self buriedPoint_viewDidDisappear:animated];
}

#pragma mark - 添加时间属性

- (NSTimeInterval)pageVCEnterTime
{
    NSTimeInterval time = [objc_getAssociatedObject(self, pageVCEnterTimeKey) doubleValue];
    return time;
}
- (void)setPageVCEnterTime:(NSTimeInterval)pageVCEnterTime
{
    objc_setAssociatedObject(self, pageVCEnterTimeKey, @(pageVCEnterTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimeInterval)pageVCLeaveTime
{
    NSTimeInterval time = [objc_getAssociatedObject(self, pageVCLeaveTimeKey) doubleValue];
    return time;
}
- (void)setPageVCLeaveTime:(NSTimeInterval)pageVCLeaveTime
{
    objc_setAssociatedObject(self, pageVCLeaveTimeKey, @(pageVCLeaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimeInterval)pageVCStayTime
{
    NSTimeInterval time = [objc_getAssociatedObject(self, pageVCStayTimeKey) doubleValue];
    return time;
}
- (void)setPageVCStayTime:(NSTimeInterval)pageVCStayTime
{
    objc_setAssociatedObject(self, pageVCStayTimeKey, @(pageVCStayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
