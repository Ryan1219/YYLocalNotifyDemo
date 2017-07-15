//
//  ViewController.m
//  YYLocalNotificationDemo
//
//  Created by Ryan on 2017/7/15.
//  Copyright © 2017年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "YYLocalNotifyManager.h"

@interface ViewController ()

/* <#description#> */
@property (nonatomic,strong) UIButton *loginBtn;
/* <#description#> */
@property (nonatomic,assign) NSInteger badge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 100, 40)];
    [self.loginBtn setTitle:@"本地通知" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor redColor];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.loginBtn.layer.cornerRadius = 6;
    self.loginBtn.layer.masksToBounds = true;
    [self.loginBtn addTarget:self action:@selector(clickLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    
    NSLog(@"------%@",[NSDate date]);
    

}

- (void)clickLoginBtnAction:(UIButton *)sender {
    
//
    self.badge++;
    [YYLocalNotifyManager registerLocalNotifyWithStartDate:@"2017-07-15 11:31:00" alertBody:@"今天不想上班，好累啊" listingId:@"skjfljglgjwjgl" badge:self.badge];
    
//
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
