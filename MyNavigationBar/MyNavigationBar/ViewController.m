//
//  ViewController.m
//  MyNavigationBar
//
//  Created by 梅毅 on 2017/4/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First View";
    self.view.backgroundColor = [UIColor blueColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 50);
    [btn setTitle:@"Next View" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toNextView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.navigationController.cloudox = @"hey";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
-(void)toNextView
{
    NextViewController *nextVC = [[NextViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
