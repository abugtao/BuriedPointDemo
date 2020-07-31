//
//  BuriedPointModel.h
//  BuriedPointDemo
//
//  Created by user on 2020/7/31.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BuriedPointTypePageEnter,//页面进入
    BuriedPointTypePageLeave,//页面离开
    BuriedPointTypeButtonClick,//按钮点击
    BuriedPointTypeText,//输入框事件
    BuriedPointTypeCellClick,//列表单元格点击
    
} BuriedPointType;
@interface BuriedPointModel : NSObject


//另一个key备用
@property(nonatomic,copy)NSString *eventKey;

//事件类型
@property(nonatomic,assign)BuriedPointType type;

//app事件标示
@property(nonatomic,copy)NSString *eventSign;
/**
 对应事件的描述
 */
@property (copy, nonatomic) NSString *eventMsg;

//事件所属页面标示
@property(nonatomic,copy)NSString *pageEventSign;
/**
 事件所属页面描述
 */
@property (copy, nonatomic) NSString *pageMsg;




//事件的自定义字段
@property (strong,nonatomic)NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
