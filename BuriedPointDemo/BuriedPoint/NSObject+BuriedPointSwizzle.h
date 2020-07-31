//
//  NSObject+BuriedPointSwizzle.h
//  BuriedPointDemo
//
//  Created by user on 2020/6/11.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BuriedPointSwizzle)

/**
 交换实例方法
 @param class 需要交换方法的类
 @param originalSelector 原来方法
 @param swizzledSelector 新方法
 
 */
+(void)swizzleInClass:(Class)class
     originalSelector:(SEL)originalSelector
     swizzledSelector:(SEL)swizzledSelector;



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
          defaultSelector:(SEL)defaultSelector;





@end

NS_ASSUME_NONNULL_END
