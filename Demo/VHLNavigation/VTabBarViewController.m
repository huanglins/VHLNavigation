//
//  VTabBarViewController.m
//  VHLNavigation
//
//  Created by Vincent on 2018/7/2.
//  Copyright © 2018 Darnel Studio. All rights reserved.
//

#import "VTabBarViewController.h"
#import "NavBGViewController.h"
#import "BaseNavigationC.h"

#import "VHLNavigation.h"

#import "ViewController.h"

@interface VTabBarViewController ()

@end

@implementation VTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self vhl_setNavBarHidden:YES];
    [self setUpSubNavVCs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubNavVCs{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i < 3; i++) {
        if (i == 0) {
            ViewController *vc = [[ViewController alloc] init];
            BaseNavigationC *navC = [[BaseNavigationC alloc] initWithRootViewController:vc];
            navC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil selectedImage:nil];
            [array addObject:navC];
        } else {
            NavBGViewController *bgVC = [[NavBGViewController alloc] init];
            BaseNavigationC *navC = [[BaseNavigationC alloc] initWithRootViewController:bgVC];
            navC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil selectedImage:nil];
            [array addObject:navC];
        }
    }
    self.viewControllers = array;
}

#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

//Presentation推出支持的屏幕旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.selectedViewController;
}
- (BOOL)prefersStatusBarHidden {
    return [self.selectedViewController prefersStatusBarHidden];
}

@end
