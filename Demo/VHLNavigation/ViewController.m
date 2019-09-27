//
//  ViewController.m
//  VHLNavigation
//
//  Created by vincent on 2017/8/28.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "ViewController.h"
#import "VHLNavigation.h"
#import "FakeNavViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self vhl_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self vhl_setNavBarTitleColor:[UIColor whiteColor]];
    [self vhl_setNavBarBackgroundColor:[UIColor whiteColor]];
    // 设置一个自定义导航栏View
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    toolBar.barStyle = UIBarStyleBlack;
//    toolBar.translucent = YES;
//    [self vhl_setNavBarBackgroundView:toolBar];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    [button setTitle:@"导航栏样式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button];
    button.center = self.view.center;
    [button addTarget:self action:@selector(gonext:) forControlEvents:UIControlEventTouchUpInside];
    
    // --------------------------------------------------------------------------------
    UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
    testview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:testview];
    
    UIView *testview1 = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 100, 120)];
    testview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:testview1];
    
    UIView *testview2 = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 100, 120)];
    testview2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testview2];
    
    UIView *testview3 = [[UIView alloc] initWithFrame:CGRectMake(300, 0, 100, 120)];
    testview3.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:testview3];
    
}
/** prefersLargeTitles 大标题显示 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
         self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
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
