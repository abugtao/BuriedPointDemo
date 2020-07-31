//
//  UITableView+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/30.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "UITableView+BuriedPointSwizzle.h"
#import "NSObject+BuriedPointSwizzle.h"
#import "BuriedPointTool.h"
@implementation UITableView (BuriedPointSwizzle)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(setDelegate:);
        SEL swizzleSel = @selector(swizzleSetDelegate:);
        [self swizzleInClass:self originalSelector:originSel swizzledSelector:swizzleSel];
    });
}

-(void)swizzleSetDelegate:(id<UITableViewDelegate>)delegate{
    SEL originSel = @selector(tableView:didSelectRowAtIndexPath:);
    
    SEL swizzleSel = @selector(swizzleTableView:didSelectRowAtIndexPath:);
    
    SEL defaultSel = @selector(defaultTableView:didSelectRowAtIndexPath:);
    [self swizzleOriginClass:[delegate class] originSelector:originSel replaceClass:[self class] swizzleSelector:swizzleSel defaultSelector:defaultSel];
    
    
    [self swizzleSetDelegate:delegate];
}

-(void)swizzleTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *eventSign = [BuriedPointTool getTableViewCellEventSign:tableView indexPath:indexPath];
    NSLog(@"UITableView:执行了点击事件---%ld   %ld---%@",indexPath.row,indexPath.section,eventSign);
    [self swizzleTableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)defaultTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *eventSign = [BuriedPointTool getTableViewCellEventSign:tableView indexPath:indexPath];
    NSLog(@"UITableView:执行了点击事件---%ld   %ld---%@",indexPath.row,indexPath.section,eventSign);
    
}
@end
