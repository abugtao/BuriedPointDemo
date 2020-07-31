//
//  BuriedPointTool.h
//  BuriedPointDemo
//
//  Created by user on 2020/7/9.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BuriedPointModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BuriedPointSignProtocol <NSObject>

//页面区分表示
-(NSString *)viewControllerSign;

/**
 textField输入事件区分标示
 
 @param textField 对应textField
 @return 对应标示
 */
-(NSString *)viewSignTextField:(UITextField *)textField;


/**
 textView输入事件区分标示
 
 @param textView 对应textView
 @return 对应标示
 */
-(NSString *)viewSignTextView:(UITextView *)textView;


/**
 列表点击事件区分标示

 @param tableView 对应tableView
 @param indexPath 行列
 */
-(NSString *)viewSignTabelView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;



/**
 点击事件区分标示

 @param view 对应view
 @param action 事件
 
 */
-(NSString *)viewSign:(UIView *)view action:(SEL)action;
@end

@interface BuriedPointTool : NSObject

/**
 最大缓存埋点个数
 */
@property (assign, nonatomic) NSInteger maxBuriedPointCount;

/**
 缓存间隔的最大时间
 */
@property (assign, nonatomic) NSTimeInterval maxBuriedPointTime;


+ (instancetype)sharedBuriedPointTool;


/**
 获取当前页面最顶层的页面标示
 */
+(NSString *)getTopPageSign;

/**
得到页面事件标示
@param pageVC 对应页面的控制器
 */
+(NSString *)getPageEventSign:(UIViewController *)pageVC;


/**
 TextField输入事件标示
 @param textField 输入框
 */
+(NSString *)getTextFieldEventSign:(UITextField *)textField;


/**
 textView输入事件标示
 @param textView 输入框
 */
+(NSString *)getTextViewEventSign:(UITextView *)textView;


/**
 tableView点击事件标示
 @param tableView 对应列表
 @param indexPath 点击单元
 
 */
+(NSString *)getTableViewCellEventSign:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/**
 得到按钮点击事件的APP事件标示

 @param action 事件
 @param target 事件执行者
 @param event 事件类型
 */
+(NSString *)getClickEventSign:(SEL)action to:(id)target forEvent:(UIEvent *)event;


//添加埋点数据到本地，适合时机上传
+(void)addBuriedPoint:(BuriedPointModel *)model;



//date（0时区） 按照传入的格式转 str（东八区）
+(NSString *)dateStrWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
