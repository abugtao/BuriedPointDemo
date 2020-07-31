//
//  UITextField+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/30.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UITextField+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"
#import <objc/runtime.h>

static const void *beginEditTimeKey = &beginEditTimeKey;
static const void *endEditTimeKey = &endEditTimeKey;
static const void *originTextKey = &originTextKey;



@implementation UITextField (BuriedPointSwizzle)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSeletor = @selector(setDelegate:);
        SEL swizzledSelector = @selector(swizzleSetDelegate:);
        [self swizzleInClass:self originalSelector:originSeletor swizzledSelector:swizzledSelector];
    });
}

-(void)swizzleSetDelegate:(id<UITextFieldDelegate>)delegate{
    //替换即将开始编辑的代理方法
    SEL originSeletor = @selector(textFieldShouldBeginEditing:);
    SEL swizzleSeletor = @selector(swizzleTextFieldShouldBeginEditing:);
    SEL defaultSeletor = @selector(defaultTextFieldShouldBeginEditing:);
    
    [self swizzleOriginClass:[delegate class] originSelector:originSeletor replaceClass:[self class] swizzleSelector:swizzleSeletor defaultSelector:defaultSeletor];
    
    
    //替换即将结束编辑的代理方法
    SEL originSeletor2 = @selector(textFieldShouldEndEditing:);
    SEL swizzleSeletor2 = @selector(swizzleTextFieldShouldEndEditing:);
    SEL defaultSeletor2 = @selector(defaultTextFieldShouldEndEditing:);
    
    [self swizzleOriginClass:[delegate class] originSelector:originSeletor2 replaceClass:[self class] swizzleSelector:swizzleSeletor2 defaultSelector:defaultSeletor2];
    
    
    [self swizzleSetDelegate:delegate];
    
}


-(BOOL)swizzleTextFieldShouldBeginEditing:(UITextField *)textField{
    textField.originText = textField.text;
    textField.beginEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextFieldEventSign:textField];
    NSLog(@"开始编辑--%@---开始编辑时间%@--原来的文案 (%@)",eventSign,dateStr,textField.originText);
    
    return [self swizzleTextFieldShouldBeginEditing:textField];
}

-(BOOL)defaultTextFieldShouldBeginEditing:(UITextField *)textField{
    textField.originText = textField.text;
    textField.beginEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextFieldEventSign:textField];
    NSLog(@"开始编辑--%@---开始编辑时间%@--原来的文案 (%@)",eventSign,dateStr,textField.originText);
    
    return YES;
}


-(BOOL)swizzleTextFieldShouldEndEditing:(UITextField *)textField{
    
    textField.endEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *benginDateStr = [BuriedPointTool dateStrWithDate:[NSDate dateWithTimeIntervalSince1970:textField.beginEditTime]];
    NSString *endDateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextFieldEventSign:textField];
    NSLog(@"结束编辑--%@---开始编辑时间%@--原来的文案 (%@)--结束编辑的时间%@--结束时文案(%@)",eventSign,benginDateStr,textField.originText,endDateStr,textField.text);
    
    return [self swizzleTextFieldShouldBeginEditing:textField];
}

-(BOOL)defaultTextFieldShouldEndEditing:(UITextField *)textField{
    textField.endEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *benginDateStr = [BuriedPointTool dateStrWithDate:[NSDate dateWithTimeIntervalSince1970:textField.beginEditTime]];
    NSString *endDateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextFieldEventSign:textField];
    NSLog(@"结束编辑--%@---开始编辑时间%@--原来的文案 (%@)--结束编辑的时间%@--结束时文案(%@)",eventSign,benginDateStr,textField.originText,endDateStr,textField.text);
    
    return YES;
}


#pragma mark -添加属性
-(NSTimeInterval)beginEditTime{
    NSTimeInterval time = [objc_getAssociatedObject(self,beginEditTimeKey) doubleValue];
    return time;
}

-(void)setBeginEditTime:(NSTimeInterval)beginEditTime{
    objc_setAssociatedObject(self, beginEditTimeKey, @(beginEditTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)endEditTime{
    NSTimeInterval time = [objc_getAssociatedObject(self, endEditTimeKey) doubleValue];
    return time;
}

-(void)setEndEditTime:(NSTimeInterval)endEditTime{
    objc_setAssociatedObject(self, endEditTimeKey, @(endEditTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)originText{
    return objc_getAssociatedObject(self, originTextKey);
}

-(void)setOriginText:(NSString *)originText{
    objc_setAssociatedObject(self, originTextKey, originText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
