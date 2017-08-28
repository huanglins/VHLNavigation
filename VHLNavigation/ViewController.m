//
//  ViewController.m
//  VHLNavigation
//
//  Created by vincent on 2017/8/28.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "ViewController.h"
#import "FakeNavViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    [button setTitle:@"导航栏样式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.center = self.view.center;
    [button addTarget:self action:@selector(gonext:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gonext:(UIButton *)sender {
    FakeNavViewController *vc1 = [[FakeNavViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
