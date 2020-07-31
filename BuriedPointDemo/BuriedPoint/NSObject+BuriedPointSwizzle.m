//
//  NSObject+BuriedPointSwizzle.m
//  BuriedPointDemo
//
//  Created by user on 2020/6/11.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "NSObject+BuriedPointSwizzle.h"
#import <objc/runtime.h>


@implementation NSObject (BuriedPointSwizzle)

/**
 交换实例方法
 @param class 需要交换方法的类
 @param originalSelector 原来方法
 @param swizzledSelector 新方法
 
 */
+(void)swizzleInClass:(Class)class
     originalSelector:(SEL)originalSelector
     swizzledSelector:(SEL)swizzledSelector{
//    Class class = class;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

//返回YES说明originalSelector方法原来没有实现，添加后originalSelector的imp是method_getImplementation(swizzledMethod)
//返回NO说明已经实现了originalSelector方法，直接去method_exchangeImplementations
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



/**
 交换代理方法
 @param originClass 需要交换方法的类
 @param originSelector 原来方法
 @param replaceClass 新方法所在类
 @param swizzleSelector 新方法
 @param defaultSelector 原来没有实现就会调用
 */
-(void)swizzleOriginClass:(Class)originClass
           originSelector:(SEL)originSelector
             replaceClass:(Class)replaceClass
          swizzleSelector:(SEL)swizzleSelector
          defaultSelector:(SEL)defaultSelector{
    
    Method originMethod = class_getInstanceMethod(originClass, originSelector);
    Method swizzleMethod = class_getInstanceMethod(replaceClass, swizzleSelector);
    Method defaultMethod = class_getInstanceMethod(replaceClass, defaultSelector);
    
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originMethod&&defaultSelector) {
        BOOL didAddDefaultMethod = class_addMethod(originClass, originSelector, method_getImplementation(defaultMethod), method_getTypeEncoding(defaultMethod));
        if (didAddDefaultMethod) {
            NSLog(@"%@ 没有实现 %@  方法，手动添加 %@ 方法成功！！!",NSStringFromClass(originClass),NSStringFromSelector(originSelector),NSStringFromSelector(defaultSelector));
        }
        return;
        
    }
    //判断originalMethod是添加的默认方法 直接返回。
    if (method_getImplementation(originMethod)==method_getImplementation(defaultMethod)) {
        return;
    }
    
    
    // 向实现 delegate 的类中添加新的方法
    BOOL didAddMethod = class_addMethod(originClass, swizzleSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (didAddMethod) {
        //添加成功
        //替换的方法已经添加到原类(originClass)中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originClass, swizzleSelector);
        // 实现交换
        method_exchangeImplementations(originMethod, newMethod);
    }else{
        // 添加失败，则说明已经 hook 过originClass类的 delegate 方法，防止多次交换。
    }
    
    
    
}



@end
