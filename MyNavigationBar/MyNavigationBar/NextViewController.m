//
//  NextViewController.m
//  MyNavigationBar
//
//  Created by 梅毅 on 2017/4/6.
//  Copyright © 2017年 my. All rights reserved.
//

#import "NextViewController.h"
#import "ViewController.h"
#import "UIViewController+Cloudox.h"
#import "UINavigationController+Cloudox.h"

@interface NextViewController ()<UINavigationControllerDelegate>

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second View";
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.delegate = self;
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(toBackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"0.0";
}
- (void)toBackView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
