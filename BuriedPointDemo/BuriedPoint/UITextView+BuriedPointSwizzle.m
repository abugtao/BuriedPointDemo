//
//  UITextView+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/30.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UITextView+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"
#import <objc/runtime.h>
static const void *beginEditTimeKey = &beginEditTimeKey;
static const void *endEditTimeKey = &endEditTimeKey;
static const void *originTextKey = &originTextKey;
@implementation UITextView (BuriedPointSwizzle)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(setDelegate:);
        SEL swizzleSel = @selector(swizzleSetDelegate:);
        [self swizzleInClass:self originalSelector:originSel swizzledSelector:swizzleSel];
    });
}

-(void)swizzleSetDelegate:(id<UITextViewDelegate>)delegate{
    //替换即将开始编辑的代理方法
    SEL originSeletor = @selector(textViewShouldBeginEditing:);
    SEL swizzleSeletor = @selector(swizzleTextViewShouldBeginEditing:);
    SEL defaultSeletor = @selector(defaultTextViewShouldBeginEditing:);
    
    [self swizzleOriginClass:[delegate class] originSelector:originSeletor replaceClass:[self class] swizzleSelector:swizzleSeletor defaultSelector:defaultSeletor];
    
    
    //替换即将结束编辑的代理方法
    SEL originSeletor2 = @selector(textViewShouldEndEditing:);
    SEL swizzleSeletor2 = @selector(swizzleTextViewShouldEndEditing:);
    SEL defaultSeletor2 = @selector(defaultTextViewShouldEndEditing:);
    
    [self swizzleOriginClass:[delegate class] originSelector:originSeletor2 replaceClass:[self class] swizzleSelector:swizzleSeletor2 defaultSelector:defaultSeletor2];
    
    
    [self swizzleSetDelegate:delegate];
}

-(BOOL)swizzleTextViewShouldBeginEditing:(UITextView *)textView{
    textView.originText = textView.text;
    textView.beginEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextViewEventSign:textView];
    NSLog(@"开始编辑--%@---开始编辑时间%@--原来的文案 (%@)",eventSign,dateStr,textView.originText);
    
    return [self swizzleTextViewShouldBeginEditing:textView];
}

-(BOOL)defaultTextViewShouldBeginEditing:(UITextView *)textView{
    textView.originText = textView.text;
    textView.beginEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];
    
    NSString *eventSign = [BuriedPointTool getTextViewEventSign:textView];
    NSLog(@"开始编辑--%@---开始编辑时间%@--原来的文案 (%@)",eventSign,dateStr,textView.originText);
    
    return YES;
}


-(BOOL)swizzleTextViewShouldEndEditing:(UITextView *)textView{

    textView.endEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *benginDateStr = [BuriedPointTool dateStrWithDate:[NSDate dateWithTimeIntervalSince1970:textView.beginEditTime]];
    NSString *endDateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];

    NSString *eventSign = [BuriedPointTool getTextViewEventSign:textView];
    NSLog(@"结束编辑--%@---开始编辑时间%@--原来的文案 (%@)--结束编辑的时间%@--结束时文案(%@)",eventSign,benginDateStr,textView.originText,endDateStr,textView.text);

    return [self swizzleTextViewShouldEndEditing:textView];
}

-(BOOL)defaultTextViewShouldEndEditing:(UITextView *)textView{
    textView.endEditTime = [[NSDate date] timeIntervalSince1970];
    NSString *benginDateStr = [BuriedPointTool dateStrWithDate:[NSDate dateWithTimeIntervalSince1970:textView.beginEditTime]];
    NSString *endDateStr = [BuriedPointTool dateStrWithDate:[NSDate date]];

    NSString *eventSign = [BuriedPointTool getTextViewEventSign:textView];
    NSLog(@"结束编辑--%@---开始编辑时间%@--原来的文案 (%@)--结束编辑的时间%@--结束时文案(%@)",eventSign,benginDateStr,textView.originText,endDateStr,textView.text);

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
