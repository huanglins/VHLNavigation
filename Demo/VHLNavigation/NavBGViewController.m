//
//  NavBGViewController.m
//  VHLNavigation
//
//  Created by vincent on 2017/8/28.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "NavBGViewController.h"
#import "HiddenNavViewController.h"
#import "FakeNavViewController.h"
#import "TransitionViewController.h"
#import "AlphaNavViewController.h"
#import "ScrollNavViewController.h"
#import "NavTableViewController.h"
#import "VHLNavigation.h"

@interface NavBGViewController ()

@end

@implementation NavBGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏背景图片";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //[self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavigationBar];
    [self vhl_setNavBarBackgroundImage:[UIImage imageNamed:@"navbg"]];  // millcolorGrad
//    [self vhl_setNavBarShadowImageHidden:YES];
//    [self vhl_setNavBarTitleColor:[UIColor whiteColor]];
//    [self vhl_setNavBarTintColor:[UIColor whiteColor]];
//    [self vhl_setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self vhl_setInteractivePopGestureRecognizerEnable:NO];
    //[self vhl_setNavTranslucent:YES];
    
    //
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 60 + 64, 150, 30)];
    [button setTitle:@"微信样式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(goFake:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100 + 64, 150, 30)];
    [button1 setTitle:@"颜色过渡" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(goTransition:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 140 + 64, 150, 30)];
    [button2 setTitle:@"导航栏背景图片" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(goNavBG:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180 + 64, 150, 30)];
    [button3 setTitle:@"隐藏导航栏" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(goHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 220 + 64, 150, 30)];
    [button4 setTitle:@"导航栏透明度" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button4 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(goAlphaNav:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(100, 260 + 64, 150, 30)];
    [button5 setTitle:@"导航栏滚动" forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button5 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button5];
    [button5 addTarget:self action:@selector(goScrollNav:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300 + 64, 150, 30)];
    [button6 setTitle:@"TableVC" forState:UIControlStateNormal];
    [button6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button6 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button6];
    [button6 addTarget:self action:@selector(goTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    // 输入框
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 360 + 64, 150, 30)];
    textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textField];
    
    // --------------------------------------------------------------------------------
    UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0, -90, 100, 120)];
    testview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:testview];
    
    UIView *testview1 = [[UIView alloc] initWithFrame:CGRectMake(100, -90, 100, 120)];
    testview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:testview1];
    
    UIView *testview2 = [[UIView alloc] initWithFrame:CGRectMake(200, -90, 100, 120)];
    testview2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testview2];
    
    UIView *testview3 = [[UIView alloc] initWithFrame:CGRectMake(300, -90, 100, 120)];
    testview3.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:testview3];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    titleView.backgroundColor = [UIColor orangeColor];
//    self.navigationItem.titleView = titleView;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    // 自己设置导航栏样式
//    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18]};
//    [self.navigationController.navigationBar setTitleTextAttributes:dict];
//    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
//    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18]};
//    [self.navigationController.navigationBar setTitleTextAttributes:dict];
//    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
//    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)goFake:(UIButton *)sender {
    FakeNavViewController *vc1 = [[FakeNavViewController alloc] init];
    vc1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (void)goTransition:(UIButton *)sender {
    TransitionViewController *vc2 = [[TransitionViewController alloc] init];
    [vc2 vhl_setNavBarBackgroundColor:[UIColor colorWithRed:(rand() % 100 * 0.01) green:(rand() % 100 * 0.01) blue:0.86 alpha:1.00]];
    vc2.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (void)goNavBG:(UIButton *)sender {
    NavBGViewController *vc3 = [[NavBGViewController alloc] init];
    vc3.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc3 animated:YES];
}

- (void)goHidden:(UIButton *)sender {
    HiddenNavViewController *vc4 = [[HiddenNavViewController alloc] init];
    vc4.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc4 animated:YES];
}

- (void)goAlphaNav:(UIButton *)sender {
    AlphaNavViewController *vc5 = [[AlphaNavViewController alloc] init];
    vc5.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc5 animated:YES];
}
- (void)goScrollNav:(UIButton *)sender {
    ScrollNavViewController *vc6 = [[ScrollNavViewController alloc] init];
    vc6.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc6 animated:YES];
}
- (void)goTableViewController:(UIButton *)sender {
    NavTableViewController *vc7 = [[NavTableViewController alloc] init];
    vc7.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc7 animated:YES];
}
// 强制转屏
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        // 从2开始是因为前两个参数已经被selector和target占用
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}
// ----------------------------------------------------------------------------- 屏幕旋转
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
