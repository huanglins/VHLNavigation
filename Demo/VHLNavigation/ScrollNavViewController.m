//
//  ScrollNavViewController.m
//  VHLNavigation
//
//  Created by vincent on 2017/9/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "ScrollNavViewController.h"
#import "FakeNavViewController.h"
#import "VHLNavigation.h"

@interface ScrollNavViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScrollNavViewController

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"导航栏滚动";
    [self vhl_setNavBarBackgroundColor:[UIColor colorWithRed:(rand() % 100 * 0.01) green:(rand() % 100 * 0.01) blue:0.86 alpha:1.00]];
    [self vhl_setNavBarShadowImageHidden:YES];
    self.navBackButtonColor = [UIColor blackColor];
    // 设置一个自定义导航栏View
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    toolBar.translucent = YES;
    //[self vhl_setNavBarBackgroundView:toolBar];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIScrollview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f", offsetY);
    /** 1. VC 中设置*/
    if (offsetY > 0) {
        if (offsetY <= 64) {
            //[self vhl_setNavBarBackgroundAlpha:offsetY / 64.0f];
        }
        [self vhl_setNavBarTranslationY:offsetY];
    } else {
        [self vhl_setNavBarTranslationY:1.0];
        //[self vhl_setNavBarBackgroundAlpha:1.0];
    }
    
    
    /** 2. 自己管理 NavigationBar方式设置导航栏浮动*/
//    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
//    CGFloat progress = offsetY / navBarHeight;
//    if (offsetY > 0) {
//        if (offsetY >= navBarHeight) {
//            [self setNavigationBarTransformProgress:1];
//        } else {
//            [self setNavigationBarTransformProgress:progress];
//        }
//    } else {
//        [self setNavigationBarTransformProgress:0.0f];
//    }
}
- (void)setNavigationBarTransformProgress:(CGFloat)progress {
    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    NSLog(@"%f",(-navBarHeight * progress));
    [self.navigationController.navigationBar vhl_setTranslationY:(-navBarHeight * progress)];
    [self.navigationController.navigationBar vhl_setBarButtonItemsAlpha:(1 - progress) hasSystemBackIndicator:YES];
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell - %d", (int)indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:(rand() % 100 * 0.01) green:(rand() % 100 * 0.01) blue:0.86 alpha:1.00];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FakeNavViewController *fakeVC = [[FakeNavViewController alloc] init];
    [self.navigationController pushViewController:fakeVC animated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
