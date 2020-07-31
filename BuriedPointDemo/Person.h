//
//  Person.h
//  BuriedPointDemo
//
//  Created by user on 2020/6/12.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int age;

-(void)eat;
@end

NS_ASSUME_NONNULL_END
