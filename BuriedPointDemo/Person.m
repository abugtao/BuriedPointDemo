//
//  Person.m
//  BuriedPointDemo
//
//  Created by user on 2020/6/12.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "Person.h"
#import "NSObject+BuriedPointSwizzle.h"
@implementation Person



-(void)eat{
    NSLog(@"eat_person");
}

-(void)swizz_eat{
    NSLog(@"eat_swizz");
    
}

+(void)eat{
    NSLog(@"eat_class");
}

-(void)sleepOfHour:(NSNumber *)hour{
    NSLog(@"sleep_person_%@",hour);
}

+(void)sleepOfHour:(NSNumber *)hour{
    NSLog(@"sleep_class_%@",hour);
}

-(NSNumber *)eatEnough:(NSNumber *)breadCount{
    NSLog(@"breadCount_person_%@",breadCount);
    return @(1);
}

+(NSNumber *)eatEnough:(NSNumber *)breadCount{
    NSLog(@"breadCount_class_%@",breadCount);
    return @(0);
}


@end
