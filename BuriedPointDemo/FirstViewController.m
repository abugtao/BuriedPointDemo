//
//  FirstViewController.m
//  BuriedPointDemo
//
//  Created by user on 2020/6/10.
//  Copyright © 2020 Baotou BAOYIN Consumer Finance Co., Ltd. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "NSObject+BuriedPointSwizzle.h"

#import "Person.h"
#import "BuriedPointTool.h"


@interface FirstViewController ()<UITextFieldDelegate>

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"first";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 200, 100, 40)];
    tf.delegate = self;
    tf.backgroundColor = [UIColor redColor];
    [self.view addSubview:tf];
    
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 400, 100, 40)];
    tf2.delegate = self;
    tf2.backgroundColor = [UIColor redColor];
    [self.view addSubview:tf2];
    
    
    UITextView *tv2 = [[UITextView alloc] initWithFrame:CGRectMake(0, 500, 100, 100)];
    tv2.delegate = self;
    tv2.backgroundColor = [UIColor redColor];
    [self.view addSubview:tv2];
    
    Person *p = [[Person alloc] init];
    [p eat];
    NSLog(@"%p",p);
    NSLog(@"%p",[p class]);
    NSLog(@"%p",[Person class]);

    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(200, 300, 100, 40)];
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
//
//
//    int count;
//    int icount;
//    class_copyIvarList([Person class], &count);
//    class_copyPropertyList([Person class], &icount);
//    NSLog(@"%d",count);
//    NSLog(@"%d",icount);
    
    
//    UIControl
    
    
}
-(void)sliderAction:(UISlider *)slider{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}
- (void)clickAction{
    SecondViewController *VC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}



-(NSString *)viewControllerSign{
    return @"bb";
}

-(NSString *)viewSign:(UIView *)view action:(SEL)action{
    
    return @"1111";
}
//- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"aa");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
