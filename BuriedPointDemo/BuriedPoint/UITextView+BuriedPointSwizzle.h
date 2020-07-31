//
//  UITextView+BuriedPointSwizzle.h
//  BuriedPointDemo
//
//  Created by user on 2020/7/30.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (BuriedPointSwizzle)
@property(nonatomic,assign)NSTimeInterval beginEditTime;//开始编辑时间

@property(nonatomic,assign)NSTimeInterval endEditTime;//结束编辑时间

@property(nonatomic,copy)NSString *originText;//编辑前输入框中的文案
@end

NS_ASSUME_NONNULL_END
