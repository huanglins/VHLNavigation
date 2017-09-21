//
//  VHLIMBaseNavigationC.m
//  VHLChat
//
//  Created by vincent on 2017/8/15.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "BaseNavigationC.h"

@interface BaseNavigationC () <UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationC

- (void)dealloc {
    self.interactivePopGestureRecognizer.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 重新响应侧滑返回手势
    self.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
#pragma mark - 侧滑手势 - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}
// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
// 禁止响应手势 是否和ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
    //return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
