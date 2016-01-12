//
//  ViewController.m
//  实现果冻效果
//
//  Created by 智能机器人 on 16/1/12.
//  Copyright © 2016年 智能机器人. All rights reserved.
//

#import "ViewController.h"
#import "LCCuteView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LCCuteView *LCCuteView1 = [[LCCuteView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:LCCuteView1];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
