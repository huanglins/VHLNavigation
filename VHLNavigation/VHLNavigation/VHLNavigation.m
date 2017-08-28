//
//  VHLNavigation.m
//  VHLNavigation
//
//  Created by vincent on 2017/8/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "VHLNavigation.h"
#import <objc/runtime.h>

@implementation UIColor (VHLNavigation)

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}
+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent
{
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}

@end

// -----------------------------------------------------------------------------
// UINavigationBar
@implementation UINavigationBar (VHLNavigation)

static char kVHLBackgroundViewKey;
static char kVHLBackgroundImageViewKey;
static int  kVHLNavBarBottom = 64;

- (UIView *)backgroundView
{
    return (UIView *)objc_getAssociatedObject(self, &kVHLBackgroundViewKey);
}
- (void)setBackgroundView:(UIView *)backgroundView
{
    objc_setAssociatedObject(self, &kVHLBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView
{
    return (UIImageView *)objc_getAssociatedObject(self, &kVHLBackgroundImageViewKey);
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView
{
    objc_setAssociatedObject(self, &kVHLBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// -> 设置导航栏背景图片
- (void)vhl_setBackgroundImage:(UIImage *)image
{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    if (!self.backgroundImageView)
    {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kVHLNavBarBottom)];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
    }
    self.backgroundImageView.image = image;
}

// -> 设置导航栏背景颜色
- (void)vhl_setBackgroundColor:(UIColor *)color
{
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    if (!self.backgroundView)
    {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kVHLNavBarBottom)];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = color;
}
#pragma mark - public method -------
/** 设置当前 NavigationBar 背景透明度*/
- (void)vhl_setBackgroundAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
}
/** 设置导航栏所有 barButtonItem 的透明度*/
- (void)vhl_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator {
    for (UIView *view in self.subviews) {
        if (hasSystemBackIndicator == YES) {
            // _UIBarBackground/_UINavigationBarBackground对应的view是系统导航栏，不需要改变其透明度
            Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
            if (_UIBarBackgroundClass != nil) {
                if (![view isKindOfClass:_UIBarBackgroundClass]) {
                    view.alpha = alpha;
                }
            }
            Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
            if (_UINavigationBarBackground != nil) {
                if (![view isKindOfClass:_UINavigationBarBackground]) {
                    view.alpha = alpha;
                }
            }
        } else {
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] == NO) {
                Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
                if (_UIBarBackgroundClass != nil) {
                    if (![view isKindOfClass:_UIBarBackgroundClass]) {
                        view.alpha = alpha;
                    }
                }
                Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
                if (_UINavigationBarBackground != nil) {
                    if (![view isKindOfClass:_UINavigationBarBackground]) {
                        view.alpha = alpha;
                    }
                }
            }
        }
    }
}

/** 设置当前 NavigationBar 垂直方向上的平移距离*/
- (void)vhl_setTranslationY:(CGFloat)translationY {
    // CGAffineTransformMakeTranslation  平移
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}
- (CGFloat)vhl_getTranslationY {
    return self.transform.ty;
}

@end
// -----------------------------------------------------------------------------
@interface UIViewController (VHLNavigation_Add)
// 设置当前 push 是否完成
- (void)setPushToCurrentVCFinished:(BOOL)isFinished;
@end
// -----------------------------------------------------------------------------
// UINavigationController
@implementation UINavigationController (VHLNavigation)

static CGFloat vhlPopDuration = 0.12;       // 侧滑动画时间
static int vhlPopDisplayCount = 0;          //
// 当前 pop 进度
- (CGFloat)vhlPopProgress
{
    CGFloat all = 60 * vhlPopDuration;
    int current = MIN(all, vhlPopDisplayCount);
    return current / all;
}

static CGFloat vhlPushDuration = 0.10;
static int vhlPushDisplayCount = 0;
// 当前 push 进度
- (CGFloat)vhlPushProgress
{
    CGFloat all = 60 * vhlPushDuration;
    int current = MIN(all, vhlPushDisplayCount);
    return current / all;
}

#pragma mark - swizzling method
// runtime
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      SEL needSwizzleSelectors[4] = {
                          NSSelectorFromString(@"_updateInteractiveTransition:"),       // 监听侧滑手势进度
                          @selector(popToViewController:animated:),                     // pop To VC
                          @selector(popToRootViewControllerAnimated:),                  // pop Root VC
                          @selector(pushViewController:animated:)                       // push
                      };
                      
                      for (int i = 0; i < 4;  i++) {
                          SEL selector = needSwizzleSelectors[i];
                          NSString *newSelectorStr = [[NSString stringWithFormat:@"vhl_%@", NSStringFromSelector(selector)] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
                          Method originMethod = class_getInstanceMethod(self, selector);
                          Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
                          method_exchangeImplementations(originMethod, swizzledMethod);
                      }
                  });
}
// 交换方法 - 监听侧滑手势进度
- (void)vhl_updateInteractiveTransition:(CGFloat)percentComplete
{
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:percentComplete];
    
    // 调用自己
    [self vhl_updateInteractiveTransition:percentComplete];
}
// 交换方法 - pop To VC
- (NSArray<UIViewController *> *)vhl_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        vhlPopDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:vhlPopDuration];
    [CATransaction begin];
    // 调用自己
    NSArray<UIViewController *> *vcs = [self vhl_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}
// 交换方法 - pop Root VC
- (NSArray<UIViewController *> *)vhl_popToRootViewControllerAnimated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        vhlPopDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:vhlPopDuration];
    [CATransaction begin];
    // 调用自己
    NSArray<UIViewController *> *vcs = [self vhl_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}
// 交换方法 - push VC
- (void)vhl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        vhlPushDisplayCount = 0;
        [viewController setPushToCurrentVCFinished:YES];
    }];
    [CATransaction setAnimationDuration:vhlPushDuration];
    [CATransaction begin];
    // 调用自己
    [self vhl_pushViewController:viewController animated:animated];
    [CATransaction commit];
}
// pop
- (void)popNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        vhlPopDisplayCount += 1;
        CGFloat popProgress = [self vhlPopProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:popProgress];
    }
}
// push
- (void)pushNeedDisplay {
    if (self.topViewController && self.topViewController.transitionCoordinator != nil) {
        vhlPushDisplayCount += 1;
        CGFloat pushProgress = [self vhlPushProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:pushProgress];
    }
}
// ** 根据进度更新导航栏 **
- (void)updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    // 如果 VC 中有隐藏了导航栏的就不做切换效果
    if ([fromVC vhl_navBarHidden] || [toVC vhl_navBarHidden]) {
        return;
    }
    // 如果 VC 中设置了自定义导航栏图片
    if (([fromVC vhl_navBarBackgroundImage] || [toVC vhl_navBarBackgroundImage])) {
        return;
    }
    // 如果 VC 中设置了切换样式为两种导航栏
    if ([fromVC vhl_navigationSwitchStyle] == 1 || [toVC vhl_navigationSwitchStyle] == 1) {
        return;
    }
    // -------------------------------------------------------------------------
    // 颜色过渡
    {
        // 导航栏按钮颜色
        UIColor *fromTintColor = [fromVC vhl_navBarTintColor];
        UIColor *toTintColor = [toVC vhl_navBarTintColor];
        UIColor *newTintColor = [UIColor middleColor:fromTintColor toColor:toTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForTintColor:newTintColor];
        // 导航栏标题颜色
        UIColor *fromTitleColor = [fromVC vhl_navBarTitleColor];
        UIColor *toTitleColor = [toVC vhl_navBarTitleColor];
        UIColor *newTitleColor = [UIColor middleColor:fromTitleColor toColor:toTitleColor percent:progress];
        [self setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
        // 导航栏背景颜色
        UIColor *fromBarTintColor = [fromVC vhl_navBarBarTintColor];
        UIColor *toBarTintColor = [toVC vhl_navBarBarTintColor];
        UIColor *newBarTintColor = [UIColor middleColor:fromBarTintColor toColor:toBarTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
        // 导航栏背景透明度
        CGFloat fromBarBackgroundAlpha = [fromVC vhl_navBarBackgroundAlpha];
        CGFloat toBarBackgroundAlpha = [toVC vhl_navBarBackgroundAlpha];
        CGFloat newBarBackgroundAlpha = [UIColor middleAlpha:fromBarBackgroundAlpha toAlpha:toBarBackgroundAlpha percent:progress];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBarBackgroundAlpha];
    }
}
#pragma mark - deal the gesture of return
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive]) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if ([sysVersion floatValue] >= 10) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}
// deal the gesture of return break off
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key) {
        UIColor *curColor = [[context viewControllerForKey:key] vhl_navBarBarTintColor];
        CGFloat curAlpha = [[context viewControllerForKey:key] vhl_navBarBackgroundAlpha];
        [self setNeedsNavigationBarUpdateForBarTintColor:curColor];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled]) {
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}
#pragma mark - setter
// -> 设置当前导航栏需要改变导航栏背景透明度
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha
{
    [self.navigationBar vhl_setBackgroundAlpha:barBackgroundAlpha];
}
// -> 设置当前导航栏背景图片
- (void)setNeedsNavigationBarUpdateForBarBackgroundImage:(UIImage *)backgroundImage {
    [self.navigationBar vhl_setBackgroundImage:backgroundImage];
}
// -> 设置当前导航栏 barTintColor | 导航栏背景颜色
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)barTintColor {
    [self.navigationBar vhl_setBackgroundColor:barTintColor];
}
// -> 设置当前导航栏的 TintColor | 按钮颜色
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor
{
    self.navigationBar.tintColor = tintColor;
}
// -> 设置当前导航栏 titleColor | 标题颜色
- (void)setNeedsNavigationBarUpdateForTitleColor:(UIColor *)titleColor {
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}
// -> 设置当前导航栏 shadowImageHidden
- (void)setNeedsNavigationBarUpdateForShadowImageHidden:(BOOL)hidden {
    self.navigationBar.shadowImage = hidden ? [UIImage new] : nil;
}
#pragma mark - 状态栏 -----------------------------------------------------------
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}
#pragma mark - 屏幕旋转相关 ------------------------------------------------------
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
// 横屏后设置是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

// -----------------------------------------------------------------------------
// UIViewController
/** VC 导航栏扩展实现*/
@implementation UIViewController (VHLNavigation)

static char kVHLPushToCurrentVCFinishedKey;         // 跳转到当前是否完成
static char kVHLPushToNextVCFinishedKey;            // 跳转到下一个VC是否完成

static char kVHLNavSwitchStyleKey;                  // 当前导航栏切换样式
static char kVHLNavBarHiddenKey;                    // 当前导航栏是否隐藏
static char kVHLNavBarBackgroundImageKey;           // 当前导航栏背景图片
static char kVHLNavBarBackgroundAlphaKey;           // 当前导航栏背景透明度
static char kVHLNavBarBarTintColorKey;              // 当前导航栏背景颜色
static char kVHLNavBarTintColorKey;                 // 当前导航栏按钮颜色
static char kVHLNavBarTitleColorKey;                // 当前导航栏标题颜色
static char kVHLNavBarShadowImageHiddenKey;         // 当前导航栏底部黑线是否隐藏
static char kVHLStatusBarStyleKey;                  // 当前导航栏状态栏样式

static char kVHLFakeNavigationBarKey;               // 假的导航栏，实现两种颜色导航栏

// runtime
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -> 交换方法
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:),
            @selector(viewDidAppear:),
            @selector(viewDidDisappear:)
        };
        
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"vhl_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
// 交换方法 - 将要出现
- (void)vhl_viewWillAppear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        [self setPushToNextVCFinished:NO];
        // 当前导航栏是否隐藏
        [self.navigationController setNavigationBarHidden:[self vhl_navBarHidden] animated:YES];
        UIImage *barBgImage = [self vhl_navBarBackgroundImage];
        // 添加一个假的导航栏
        if (barBgImage || [self shouldAddFakeNavigationBar]) {
            [self addFakeNavigationBar];
        }
        if (![self vhl_navBarHidden]) {
            [self updateNavigationInfo];
        }
    }
    // 调自己
    [self vhl_viewWillAppear:animated];
}
// 交换方法 - 已经出现
- (void)vhl_viewDidAppear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        // 当前导航栏是否隐藏
        [self.navigationController setNavigationBarHidden:[self vhl_navBarHidden] animated:NO];
        [self removeFakeNavigationBar];     // 删除 fake navigation bar
        if (![self vhl_navBarHidden]) {
            [self updateNavigationInfo];
        }
    }
    // 调自己
    [self vhl_viewDidAppear:animated];
}
// 交换方法 - 将要消失
- (void)vhl_viewWillDisappear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        [self setPushToNextVCFinished:YES];
        // 当前导航栏是否隐藏
        [self.navigationController setNavigationBarHidden:[self vhl_navBarHidden] animated:YES];
        UIImage *barBgImage = [self vhl_navBarBackgroundImage];
        // 添加假的导航栏
        if (barBgImage || [self shouldAddFakeNavigationBar]) {
            [self addFakeNavigationBar];
        }
        if (![self vhl_navBarHidden]) {
            [self updateNavigationInfo];
        }
    }
    // 调自己
    [self vhl_viewWillDisappear:animated];
}
// 交换方法 - 已经消失
- (void)vhl_viewDidDisappear:(BOOL)animated {
    // 删除 fake navigation bar
    [self removeFakeNavigationBar];
    // 调用自己
    [self vhl_viewDidDisappear:animated];
}
// 更新导航栏
- (void)updateNavigationInfo {
    if (!self.fakeNavigationBar) {
        if ([self vhl_navBarBackgroundImage]) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:[self vhl_navBarBackgroundImage]];
        } else {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self vhl_navBarBarTintColor]];
        }
    }
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self vhl_navBarBackgroundAlpha]];
    [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self vhl_navBarTintColor]];
    [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self vhl_navBarTitleColor]];
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:[self vhl_navBarShadowImageHidden]];
}
#pragma mark - fake navigation bar ---------------------------------------------
// 是否需要添加一个假的 NavigationBar
- (BOOL)shouldAddFakeNavigationBar {
    // 判断当前导航栏交互的两个VC其中是否设置了导航栏样式为两种颜色导航栏，或者设置了导航栏背景图片
    UIViewController *fromVC = [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    if ((fromVC && ([fromVC vhl_navigationSwitchStyle] == 1 || [fromVC vhl_navBarBackgroundImage])) ||
        (toVC && ([toVC vhl_navigationSwitchStyle] == 1 || [toVC vhl_navBarBackgroundImage]))) {
        return YES;
    }
    return NO;
}
// 添加一个假的导航栏背景
- (void)addFakeNavigationBar {
    UIViewController *fromVC = [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [fromVC.fakeNavigationBar removeFromSuperview];
    [toVC.fakeNavigationBar removeFromSuperview];
    fromVC.fakeNavigationBar = nil;
    toVC.fakeNavigationBar = nil;
    
    if (!fromVC.fakeNavigationBar) {
        [fromVC vhl_setNavBarBackgroundAlpha:0.0f];
        fromVC.fakeNavigationBar = [[UINavigationBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        if ([fromVC vhl_navBarBackgroundImage]) {
            [fromVC.fakeNavigationBar vhl_setBackgroundImage:[fromVC vhl_navBarBackgroundImage]];
        } else {
            [fromVC.fakeNavigationBar vhl_setBackgroundColor:[fromVC vhl_navBarBarTintColor]];
        }
        fromVC.fakeNavigationBar.shadowImage = [UIImage new];//[self vhl_navBarShadowImageHidden]?[UIImage new]:nil;
        [fromVC.fakeNavigationBar setTranslucent:NO];
        [fromVC.view addSubview:fromVC.fakeNavigationBar];
    }
    if (!toVC.fakeNavigationBar) {
        [toVC vhl_setNavBarBackgroundAlpha:0.0f];
        toVC.fakeNavigationBar = [[UINavigationBar alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        if ([toVC vhl_navBarBackgroundImage]) {
            [toVC.fakeNavigationBar vhl_setBackgroundImage:[toVC vhl_navBarBackgroundImage]];
        } else {
            [toVC.fakeNavigationBar vhl_setBackgroundColor:[toVC vhl_navBarBarTintColor]];
        }
        toVC.fakeNavigationBar.shadowImage = [UIImage new];//[self vhl_navBarShadowImageHidden]?[UIImage new]:nil;
        [toVC.fakeNavigationBar setTranslucent:NO];
        [toVC.view addSubview:toVC.fakeNavigationBar];
    }
}
// 将假的导航栏背景删除
- (void)removeFakeNavigationBar {
    if (self.fakeNavigationBar) {
        [self vhl_setNavBarBackgroundAlpha:1.0f];
        [self updateNavigationInfo];
        [self.fakeNavigationBar removeFromSuperview];
        self.fakeNavigationBar = nil;
    }
}
//
- (UINavigationBar *)fakeNavigationBar {
    return (UINavigationBar *)objc_getAssociatedObject(self, &kVHLFakeNavigationBarKey);
}
- (void)setFakeNavigationBar:(UINavigationBar *)navigationBar
{
    objc_setAssociatedObject(self, &kVHLFakeNavigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - private method --------------------------------------------------
- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏，且当前是全屏，//且没有手动设置隐藏导航栏
    if (self.navigationController &&
        CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds)) {
        return YES;
    }
    return NO;
}
/** 回到当前VC是否完成*/
- (void)setPushToCurrentVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kVHLPushToCurrentVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)pushToCurrentVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kVHLPushToCurrentVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}
/** 跳转到下个VC是否完成*/
- (void)setPushToNextVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kVHLPushToNextVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)pushToNextVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kVHLPushToNextVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}
#pragma mark - public method ---------------------------------------------------
/** 设置当前导航栏侧滑过度效果*/
- (void)vhl_setNavigationSwitchStyle:(VHLNavigationSwitchStyle)style {
    objc_setAssociatedObject(self, &kVHLNavSwitchStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (VHLNavigationSwitchStyle)vhl_navigationSwitchStyle {
    id style = objc_getAssociatedObject(self, &kVHLNavSwitchStyleKey);
    return style?[style integerValue]:0;
}

/** 设置隐藏当前导航栏*/
- (void)vhl_setNavBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kVHLNavBarHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)vhl_navBarHidden {
    id hidden = objc_getAssociatedObject(self, &kVHLNavBarHiddenKey);
    return hidden?[hidden boolValue]:NO;
}

/** 设置当前导航栏的背景图片*/
- (void)vhl_setNavBarBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)vhl_navBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kVHLNavBarBackgroundImageKey);
    return image?: nil;
}

/** 当前导航栏的透明度*/
- (void)vhl_setNavBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_ASSIGN);
    
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
}
- (CGFloat)vhl_navBarBackgroundAlpha {
    id barBackgroundAlpha = objc_getAssociatedObject(self, &kVHLNavBarBackgroundAlphaKey);
    return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : 1.0;
}
/** 设置当前导航栏 barTintColor(导航栏背景颜色)*/
- (void)vhl_setNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if ([self pushToCurrentVCFinished] && ![self pushToNextVCFinished]) {
        [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
    }
}
- (UIColor *)vhl_navBarBarTintColor {
    UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarBarTintColorKey);
    return (barTintColor != nil) ? barTintColor : [UIColor whiteColor];
}
/** 设置当前导航栏 TintColor(导航栏按钮等颜色)*/
- (void)vhl_setNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pushToNextVCFinished] == NO) {
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:color];
    }
}
- (UIColor *)vhl_navBarTintColor {
    UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarTintColorKey);
    return (tintColor != nil) ? tintColor : [UIColor blackColor];
}

/** 设置当前导航栏 titleColor(标题颜色)*/
- (void)vhl_setNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pushToNextVCFinished]) {
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:color];
    }
}
- (UIColor *)vhl_navBarTitleColor {
    UIColor *titleColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarTitleColorKey);
    return (titleColor != nil) ? titleColor : [UIColor blackColor];
}
/** 设置当前导航栏 shadowImage(底部分割线)是否隐藏*/
- (void)vhl_setNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kVHLNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:hidden];
}
- (BOOL)vhl_navBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kVHLNavBarShadowImageHiddenKey);
    return hidden?[hidden boolValue]:NO;
}
/** 设置当前状态栏样式 白色/黑色 */
- (void)vhl_setStatusBarStyle:(UIStatusBarStyle)style
{
    objc_setAssociatedObject(self, &kVHLStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法
}
- (UIStatusBarStyle)vhl_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kVHLStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self vhl_statusBarStyle];
}
#pragma mark - 屏幕旋转相关 ------------------------------------------------------
// 默认不支持旋转 - 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

/** 
    objc_setAssociatedObject 来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。
 */
