//
//  BuriedPointTool.m
//  BuriedPointDemo
//
//  Created by user on 2020/7/9.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "BuriedPointTool.h"
@interface BuriedPointTool()
/**
所有产生的点击埋点事件集合,数据格式：
@[@{key:value,key:value}];
*/
@property(nonatomic,strong)NSMutableArray *buriedPointArray;



@end
@implementation BuriedPointTool

+ (instancetype)sharedBuriedPointTool{
    
    static BuriedPointTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


/**
 获取当前页面最顶层的页面标示
 */
+(NSString *)getTopPageSign{
    UIViewController *topVC = [self topViewController];
    return [self getPageEventSign:topVC];
    
}

/**
得到页面事件标示
@param pageVC 对应页面的控制器
 */
+(NSString *)getPageEventSign:(UIViewController *)pageVC{
    NSString *eventSign = NSStringFromClass([pageVC class]);
    if ([pageVC respondsToSelector:@selector(viewControllerSign)]) {
        
        id<BuriedPointSignProtocol> delegate= (id<BuriedPointSignProtocol>)pageVC;
        return [NSString stringWithFormat:@"%@%@",eventSign,[delegate viewControllerSign]];
    }
    
    return eventSign;
}

/**
 TextField输入时间标示
 @param textField 输入框
 */
+(NSString *)getTextFieldEventSign:(UITextField *)textField{
    NSString *eventSign = [NSString stringWithFormat:@"%@%@",[self getTopPageSign],NSStringFromClass([textField class])];
    if ([textField.delegate respondsToSelector:@selector(viewSignTextField:)]) {
        id<BuriedPointSignProtocol> delegate= (id<BuriedPointSignProtocol>)textField.delegate;
        return [NSString stringWithFormat:@"%@%@",eventSign,[delegate viewSignTextField:textField]];
    }
    
    return eventSign;
    
}

/**
 textView输入事件标示
 @param textView 输入框
 */
+(NSString *)getTextViewEventSign:(UITextView *)textView{
    NSString *eventSign = [NSString stringWithFormat:@"%@%@",[self getTopPageSign],NSStringFromClass([textView class])];
    if ([textView.delegate respondsToSelector:@selector(viewSignTextView:)]) {
        id<BuriedPointSignProtocol> delegate= (id<BuriedPointSignProtocol>)textView.delegate;
        return [NSString stringWithFormat:@"%@%@",eventSign,[delegate viewSignTextView:textView]];
    }
    
    return eventSign;
}

/**
 tableView点击事件标示
 @param tableView 对应列表
 @param indexPath 点击单元
 
 */
+(NSString *)getTableViewCellEventSign:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *eventSign = nil;
    if ([tableView.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)tableView.delegate;
        eventSign = [NSString stringWithFormat:@"%@%@",[self getPageEventSign:vc],NSStringFromClass([tableView class])];
    }else{
        eventSign = [NSString stringWithFormat:@"%@%@%@",[self getTopPageSign],NSStringFromClass([tableView.delegate class]),NSStringFromClass([tableView class])];
    }
    if ([tableView.delegate respondsToSelector:@selector(viewSignTabelView:indexPath:)]) {
        id<BuriedPointSignProtocol> delegate= (id<BuriedPointSignProtocol>)tableView.delegate;
        return [NSString stringWithFormat:@"%@%@",eventSign,[delegate viewSignTabelView:tableView indexPath:indexPath]];
    }
    
    return eventSign;
}

/**
 得到按钮点击事件的APP事件标示

 @param action 事件
 @param target 事件执行者
 @param event 事件类型
 */
+(NSString *)getClickEventSign:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    NSString *eventSign = nil;
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)target;
        eventSign = [NSString stringWithFormat:@"%@%@",[self getPageEventSign:vc],NSStringFromSelector(action)];
    }else{
        eventSign = [NSString stringWithFormat:@"%@%@%@",[self getTopPageSign],NSStringFromClass([target class]),NSStringFromSelector(action)];
    }
    
    
    if ([target respondsToSelector:@selector(viewSign:action:)]) {
        id<BuriedPointSignProtocol> delegate= (id<BuriedPointSignProtocol>)target;
        UITouch *touch = [[event allTouches] anyObject];
        
        return [NSString stringWithFormat:@"%@%@",eventSign,[delegate viewSign:touch.view action:action]];
    }
    return eventSign;
}


//添加埋点数据到本地，适合时机上传
+(void)addBuriedPoint:(BuriedPointModel *)model{
    //model转成dic
    NSDictionary *buriedPointInfo = nil;
    
    NSMutableArray * eventMutableArray = [BuriedPointTool sharedBuriedPointTool].buriedPointArray;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;

   //如果当前缓存的埋点数据为空，则将当前时间更新为此次埋点的开始时间
   if (eventMutableArray.count == 0) {
       [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:@"buriedPointBeginTime"];
   }
   NSTimeInterval beginTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"buriedPointBeginTime"];
   [eventMutableArray addObject:buriedPointInfo];

   if ((eventMutableArray.count >= [BuriedPointTool sharedBuriedPointTool].maxBuriedPointCount ||nowTime - beginTime > [BuriedPointTool sharedBuriedPointTool].maxBuriedPointTime)) {

       NSArray *array = [eventMutableArray copy];

//       [self requestUploadBuriedPoint:[eventMutableArray copy] complete:^(BOOL isSuccess) {
//           //如果上传没成功的话则将数据返回到数据池中，假如上传过程中APP被杀死，则不做处理
//           if (!isSuccess) {
//               [eventMutableArray addObjectsFromArray:array];
//               [eventMutableArray writeToFile:[BuriedPointTool getBuriedPointEventDataPlistPath] atomically:YES];
//           }
//       }];
       [eventMutableArray removeAllObjects];
   }
   [eventMutableArray writeToFile:[BuriedPointTool getBuriedPointEventDataPlistPath] atomically:YES];
}

//date（0时区） 按照传入的格式转 str（东八区）
+(NSString *)dateStrWithDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [format stringFromDate:date];
    return dateStr;
}

/**
 获取最上层的VC
 */
+(UIViewController *)topViewController{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    if (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    
    return resultVC;
}
+(UIViewController *)_topViewController:(UIViewController *)VC{
    if([VC isKindOfClass:[UITabBarController class]]){
        return [self _topViewController:[(UITabBarController *)VC selectedViewController]];
    }else if ([VC isKindOfClass:[UINavigationController class]]){
        return [self _topViewController:[(UINavigationController *)VC topViewController]];
    }else{
        return VC;
    }
    return nil;
}


-(NSMutableArray *)buriedPointArray{
    if (!_buriedPointArray) {
        _buriedPointArray = [BuriedPointTool getCacheBuriedPointData];
    }return _buriedPointArray;
}

/**
 获取缓存的用户其他埋点数据
 */
+(NSMutableArray *)getCacheBuriedPointData{

    NSString *buriedPointDataPath = [BuriedPointTool getBuriedPointEventDataPlistPath];
    NSArray *buriedPointDataArray = [NSArray arrayWithContentsOfFile:buriedPointDataPath];
    return [NSMutableArray arrayWithArray:buriedPointDataArray];
}

/**
 获取其他埋点数据文件路径
 */
+(NSString *)getBuriedPointEventDataPlistPath{

    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"BuriedPointData.plist"];
}

@end
