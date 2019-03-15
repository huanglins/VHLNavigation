//
//  VHLNavigation.m
//  VHLNavigation
//
//  Created by vincent on 2017/8/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "VHLNavigation.h"
#import <objc/runtime.h>
#import "sys/utsname.h"

// -----------------------------------------------------------------------------
@implementation VHLNavigation

static char kVHLDefaultNavBarBarTintColorKey;
static char kVHLDefaultNavBarTintColorKey;
static char kVHLDefaultNavBarTitleColorKey;
static char kVHLDefaultNavBarShadowImageHiddenKey;
static char kVHLDefaultStatusBarStyleKey;
static char kVHLDefaultStatusBarHeightKey;          // 存储默认状态栏高度

static char kVHLDefaultIgnoreVCListKey;             // 全局忽略数组

/** 颜色过渡*/
+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
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
+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent {
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}
// --------------------------------------------------- //
/** 判断是否是 iPhone X 系列的异形屏*/
+ (BOOL)vhl_isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    // 如果不是 iPhone
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    // 判断底部安全区域
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}
/** 全局设置导航栏背景颜色 */
+ (void)vhl_setDefaultNavBackgroundColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLDefaultNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIColor *)defaultNavBackgroundColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kVHLDefaultNavBarBarTintColorKey);
    return (color != nil) ? color : [UIColor whiteColor];
}

/** 全局设置导航栏按钮颜色 */
+ (void)vhl_setDefaultNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLDefaultNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIColor *)defaultNavBarTintColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kVHLDefaultNavBarTintColorKey);
    return (color != nil) ? color : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}

/** 全局设置导航栏标题颜色 */
+ (void)vhl_setDefaultNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLDefaultNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIColor *)defaultNavBarTitleColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kVHLDefaultNavBarTitleColorKey);
    return (color != nil) ? color : [UIColor blackColor];
}

/** 全局设置导航栏黑色分割线是否隐藏*/
+ (void)vhl_setDefaultNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kVHLDefaultNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (BOOL)defaultNavBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kVHLDefaultNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : NO;
}

/** 全局设置状态栏样式*/
+ (void)vhl_setDefaultStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kVHLDefaultStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (UIStatusBarStyle)defaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kVHLDefaultStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}

/** 全局设置状态栏样式*/
+ (void)vhl_setDefaultStatusBarHeight:(CGFloat)height {
    objc_setAssociatedObject(self, &kVHLDefaultStatusBarHeightKey, @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (CGFloat)defaultStatusBarHeight {
    id style = objc_getAssociatedObject(self, &kVHLDefaultStatusBarHeightKey);
    return (style != nil) ? [style floatValue] : 0.0;
}

// ---------------------------------------------------------------------------
+ (NSMutableArray *)defaultIgnoreVCList {
    id vcList = objc_getAssociatedObject(self, &kVHLDefaultIgnoreVCListKey);
    if (!vcList || ![vcList isKindOfClass:[NSMutableArray class]]) {
        vcList = [NSMutableArray array];
        objc_setAssociatedObject(self, &kVHLDefaultIgnoreVCListKey, vcList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return vcList;
}
+ (void)vhl_saveDefaultIgnoreVCList:(NSMutableArray *)vcList {
    objc_setAssociatedObject(self, &kVHLDefaultIgnoreVCListKey, vcList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (BOOL)vhl_isIgnoreVC:(NSString *)vcName {
    return [[VHLNavigation defaultIgnoreVCList] containsObject:vcName];
}
/** 全局添加一个需要忽略的 ViewController */
+ (void)vhl_addIgnoreVCClassName:(NSString *)vcClassName {
    NSMutableArray *vcList = [self defaultIgnoreVCList];
    if (![vcList containsObject:vcClassName]) {
        [vcList addObject:vcClassName];
        [VHLNavigation vhl_saveDefaultIgnoreVCList:vcList];
    }
}
/** 全局删除一个需要忽略的 ViewController*/
+ (void)vhl_removeIgnoreVCClassName:(NSString *)vcClassName {
    NSMutableArray *vcList = [self defaultIgnoreVCList];
    if ([vcList containsObject:vcClassName]) {
        [vcList removeObject:vcClassName];
        [VHLNavigation vhl_saveDefaultIgnoreVCList:vcList];
    }
}

@end

// -----------------------------------------------------------------------------
// UINavigationBar
@implementation UINavigationBar (VHLNavigation)

static char kVHLBackgroundViewKey;
static char kVHLBackgroundImageViewKey;

- (UIView *)backgroundView {
    return (UIView *)objc_getAssociatedObject(self, &kVHLBackgroundViewKey);
}
- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, &kVHLBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView {
    return (UIImageView *)objc_getAssociatedObject(self, &kVHLBackgroundImageViewKey);
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, &kVHLBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// -> 设置导航栏背景View
- (void)vhl_setBackgroundView:(UIView *)view {
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    // 这里需要将系统添加的模糊层隐藏，不然会在自己添加的背景层再添加一层模糊层
    if ([self.subviews.firstObject subviews].count > 1) {
        UIView *backgroundEffectView = [[self.subviews.firstObject subviews] objectAtIndex:1];// UIVisualEffectView
        if (backgroundEffectView != nil) {
            backgroundEffectView.alpha = 0.0;
        }
    }
    
    self.backgroundView = view;
    self.backgroundView.frame = self.subviews.firstObject.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    /** iOS11下导航栏不显示问题 */
    if (self.subviews.count > 0) {
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
    } else {
        [self insertSubview:self.backgroundView atIndex:0];
    }
}
// -> 设置导航栏背景图片
- (void)vhl_setBackgroundImage:(UIImage *)image {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    if (!self.backgroundImageView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.subviews.firstObject.bounds];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;  // ****
        // _UIBarBackground is first subView for navigationBar
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
        } else {
            [self insertSubview:self.backgroundImageView atIndex:0];
        }
    }
    self.backgroundImageView.image = image;
}

// -> 设置导航栏背景颜色
- (void)vhl_setBackgroundColor:(UIColor *)color {
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    if (!self.backgroundView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:self.subviews.firstObject.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;  // ****
        // _UIBarBackground is first subView for navigationBar
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        } else {
            [self insertSubview:self.backgroundView atIndex:0];
        }
    }
    self.backgroundView.backgroundColor = color;
}
#pragma mark - public method
/** 设置当前 NavigationBar 背景透明度*/
- (void)vhl_setBackgroundAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
    
    if (@available(iOS 11.0, *)) {  // iOS11 下 UIBarBackground -> UIView/UIImageViwe
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass([view class]) containsString:@"UIbarBackGround"]) {
                view.alpha = 0;
            }
        }
        // iOS11 下如果不设置 UIBarBackground 下的UIView的透明度，会显示一个白色图层
        if (barBackgroundView.subviews.firstObject) {
            barBackgroundView.subviews.firstObject.alpha = alpha;
        }
    }
    if (self.isTranslucent) {
        if ([barBackgroundView subviews].count > 1) {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    }
}
/** 设置当前 NavigationBar 底部分割线是否隐藏*/
- (void)vhl_setShadowImageHidden:(BOOL)hidden {
    self.shadowImage = hidden ? [UIImage new] : nil;
}
/** 设置当前 NavigationBar _UINavigationBarBackIndicatorView (默认的返回箭头)是否隐藏*/
- (void)vhl_setBarBackIndicatorViewHidden:(BOOL)hidden {
    for (UIView *view in self.subviews) {
        Class _UINavigationBarBackIndicatorViewClass = NSClassFromString(@"_UINavigationBarBackIndicatorView");
        if (_UINavigationBarBackIndicatorViewClass != nil) {
            if ([view isKindOfClass:_UINavigationBarBackIndicatorViewClass]) {
                view.hidden = hidden;
            }
        }
    }
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
/** 因为在 UINavigationController 中使用了 VC 中的扩展方法，所以需要提到上面来声明，否则无法调用*/
@interface UIViewController (VHLNavigation_Add)
// 设置当前 push 是否完成
- (void)setPushToCurrentVCFinished:(BOOL)isFinished;
// 当前 VC 是否需要添加一个假的NavigationBar
- (BOOL)shouldAddFakeNavigationBar;
@end
// -----------------------------------------------------------------------------
// UINavigationController
@implementation UINavigationController (VHLNavigation)

static CGFloat vhlPopDuration = 0.12;       // 侧滑动画时间
static int vhlPopDisplayCount = 0;          //
// 当前 pop 进度
- (CGFloat)vhlPopProgress {
    CGFloat all = 60 * vhlPopDuration;
    int current = MIN(all, vhlPopDisplayCount);
    return current / all;
}

static CGFloat vhlPushDuration = 0.10;
static int vhlPushDisplayCount = 0;
// 当前 push 进度
- (CGFloat)vhlPushProgress {
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
- (void)vhl_updateInteractiveTransition:(CGFloat)percentComplete {
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
- (BOOL)updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    // 如果 VC 中是设置为被忽略的VC，不处理
    if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] ||
        [VHLNavigation vhl_isIgnoreVC:NSStringFromClass([toVC class])]) {
        return NO;
    }
    // 如果 VC 中有隐藏了导航栏的就不做切换效果
    if ([fromVC vhl_navBarHidden] || [toVC vhl_navBarHidden]) {
        return NO;
    }
    // 如果 VC 中设置了自定义导航栏图片
    if (([fromVC vhl_navBarBackgroundImage] || [toVC vhl_navBarBackgroundImage])) {
        return NO;
    }
    // 如果 VC 中设置了切换样式为两种导航栏
    if ([fromVC vhl_navigationSwitchStyle] == 1 || [toVC vhl_navigationSwitchStyle] == 1) {
        return NO;
    }
    // 如果 VC 中两个导航栏的透明度不一样，也使用假的导航栏
    if ([fromVC vhl_navBarBackgroundAlpha] != [toVC vhl_navBarBackgroundAlpha]) {
        return NO;
    }
    // -------------------------------------------------------------------------
    // 颜色过渡
    {
        // 导航栏按钮颜色
        UIColor *fromTintColor = [fromVC vhl_navBarTintColor];
        UIColor *toTintColor = [toVC vhl_navBarTintColor];
        UIColor *newTintColor = [VHLNavigation middleColor:fromTintColor toColor:toTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForTintColor:newTintColor];
        // 导航栏标题颜色
        UIColor *fromTitleColor = [fromVC vhl_navBarTitleColor];
        UIColor *toTitleColor = [toVC vhl_navBarTitleColor];
        UIColor *newTitleColor = [VHLNavigation middleColor:fromTitleColor toColor:toTitleColor percent:progress];
        [self setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
        // 导航栏背景颜色
        UIColor *fromBarTintColor = [fromVC vhl_navBarBackgroundColor];
        UIColor *toBarTintColor = [toVC vhl_navBarBackgroundColor];
        UIColor *newBarTintColor = [VHLNavigation middleColor:fromBarTintColor toColor:toBarTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
        // 导航栏背景透明度
        CGFloat fromBarBackgroundAlpha = [fromVC vhl_navBarBackgroundAlpha];
        CGFloat toBarBackgroundAlpha = [toVC vhl_navBarBackgroundAlpha];
        CGFloat newBarBackgroundAlpha = [VHLNavigation middleAlpha:fromBarBackgroundAlpha toAlpha:toBarBackgroundAlpha percent:progress];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBarBackgroundAlpha];
    }
    return YES;
}
#pragma mark - deal the gesture of return
// 导航栏返回按钮点击
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive]) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if ([sysVersion floatValue] >= 10) {
            if (@available(iOS 10.0, *)) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    __strong typeof (self) pThis = weakSelf;
                    [pThis dealInteractionChanges:context];
                }];
            }
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
#pragma clang diagnostic pop
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}
// 处理侧滑手势
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key) {
        if (![self.topViewController shouldAddFakeNavigationBar]) {
            UIColor *curColor = [[context viewControllerForKey:key] vhl_navBarBackgroundColor];
            CGFloat curAlpha = [[context viewControllerForKey:key] vhl_navBarBackgroundAlpha];
            [self setNeedsNavigationBarUpdateForBarTintColor:curColor];
            [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
        }
    };
    
    if ([context isCancelled]) {        // 自动取消侧滑手势
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {                            // 自动完成侧滑手势
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}
#pragma mark - setter
// -> 设置当前导航栏需要改变导航栏背景透明度
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    [self.navigationBar vhl_setBackgroundAlpha:barBackgroundAlpha];
}
// -> 设置当前导航栏的背景View
- (void)setNeedsNavigationBarUpdateForBarBackgroundView:(UIView *)backgroundView {
    [self.navigationBar vhl_setBackgroundView:backgroundView];
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
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor {
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
#pragma mark - 屏幕旋转/状态栏隐藏显示相关 ------------------------------------------
// 1. 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
// 2. 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
// 3. 横屏后设置是否隐藏状态栏
//- (BOOL)prefersStatusBarHidden {
//    return [self.topViewController prefersStatusBarHidden];
//}
// 4. 默认的屏幕方向（当前 ViewController 必须是通过模态出来的 UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
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
static char kVHLNavBarBackgroundViewKey;            // 当前导航栏背景图片   1
static char kVHLNavBarBackgroundImageKey;           // 当前导航栏背景图片   2
static char kVHLNavBarBackgroundColorKey;           // 当前导航栏背景颜色   3
static char kVHLNavBarBackgroundAlphaKey;           // 当前导航栏背景透明度
static char kVHLNavBarTintColorKey;                 // 当前导航栏按钮颜色
static char kVHLNavBarTitleColorKey;                // 当前导航栏标题颜色
static char kVHLNavBarShadowImageHiddenKey;         // 当前导航栏底部黑线是否隐藏
static char kVHLNavBarTranslationYKey;              // 当前导航栏浮动高度Y
static char kVHLStatusBarHiddenKey;                 // 当前状态栏是否隐藏
static char kVHLStatusBarStyleKey;                  // 当前导航栏状态栏样式
static char kVHLInteractivePopEnableKey;            // 当前侧滑手势是否可用

static char kVHLFakeNavigationBarKey;               // 假的导航栏，实现两种颜色导航栏
static char kVHLTempBackViewKey;                    // 用于放在 view 最底部，避免切换是显示了下一个 view

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
    if ([self canUpdateNavigationBar] && ![self isIgnoreVC]) {
        [self setPushToNextVCFinished:NO];
        // iOS 10.3.1 下第一个VC也会出现默认导航栏返回箭头的BUG，
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController.navigationBar vhl_setBarBackIndicatorViewHidden:YES];
        } else {
            [self.navigationController.navigationBar vhl_setBarBackIndicatorViewHidden:NO];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        // ** 优化从有状态栏+导航栏切换到无状态栏+无导航栏，有状态栏+导航栏的 VC 高度不变
        if ([self isStatusBarDiff]) {
            [self vhl_setStatusBarHidden:NO];
        }
        // 当前导航栏是否隐藏
        [self.navigationController setNavigationBarHidden:[self vhl_navBarHidden] animated:YES];
        // 恢复导航栏浮动偏移到默认状态
        if ([self vhl_navBarTranslationY] > 0) {
            [self vhl_setNavBarTranslationY:0.0];
        }
        // 添加一个假 NavigationBar
        if ([self shouldAddFakeNavigationBar] && ![self isMotal]) {
            [self addFakeNavigationBar];
        }
        // 更新导航栏信息
        if (![self vhl_navBarHidden] && ![self isIgnoreVC]) {
            // ** 当两个VC都是颜色过渡的时候，这里不设置背景，不然会闪动一下 **
            // ** 模态跳转下，需要更新导航背景，不然有概率出现白色背景
            if (!self.vhl_fakeNavigationBar && (![self isTransitionStyle] || [self isMotal] || [self isRootViewController])) {
                if ([self vhl_navBarBackgroundView]) {
                    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundView:[self vhl_navBarBackgroundView]];
                } else if ([self vhl_navBarBackgroundImage]) {
                    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:[self vhl_navBarBackgroundImage]];
                } else {
                    [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self vhl_navBarBackgroundColor]];
                }
            }
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self vhl_navBarTintColor]];
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self vhl_navBarTitleColor]];
        }
    } else {
        // [self.navigationController setNavigationBarHidden:NO animated:NO];
        // 添加一个假 NavigationBar
//        if ([self shouldAddFakeNavigationBar] && ![self isMotal]) {
//            [self addFakeNavigationBar];
//        }
    }
    // 调自己
    [self vhl_viewWillAppear:animated];
}
// 交换方法 - 已经出现
- (void)vhl_viewDidAppear:(BOOL)animated {
    if ([self isRootViewController] == NO) {
        self.pushToCurrentVCFinished = YES;
    }
    if (self.vhl_fakeNavigationBar) {
        [self removeFakeNavigationBar];     // 删除 fake NavigationBar
    }
    if ([self canUpdateNavigationBar]) {
        [self vhl_setNavBarTranslationY:0.0];
        if (![self isIgnoreVC]) {
            [self updateNavigationInfo];
        } else {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:1];
            if (self.navigationController.navigationBar.barTintColor) {
                [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:self.navigationController.navigationBar.barTintColor];
            }
        }
        
        [self updateInteractivePopGestureRecognizer];
        [VHLNavigation vhl_setDefaultStatusBarHeight:[self vhl_statusBarHeight]];
    }
    // 调自己
    [self vhl_viewDidAppear:animated];
}
// 交换方法 - 将要消失
- (void)vhl_viewWillDisappear:(BOOL)animated {
    // willdisappear 这里不能通过 [self.navigationController.viewControllers containsObject:self] 进行判断是否
    if ([self canUpdateNavigationBar] && ![self isIgnoreVC]) {
        // 当前导航栏是否隐藏
        [self.navigationController setNavigationBarHidden:[self vhl_navBarHidden] animated:YES];
        // 恢复导航栏浮动偏移
        if ([self vhl_navBarTranslationY] > 0.0) {
            [self vhl_setNavBarTranslationY:0.0];
        }
        // 更新导航栏信息
        if (![self vhl_navBarHidden]) {
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self vhl_navBarTintColor]];
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self vhl_navBarTitleColor]];
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self vhl_navBarBackgroundAlpha]];
        }
        [self setPushToNextVCFinished:YES];
    }
    // 调自己
    [self vhl_viewWillDisappear:animated];
}
// 交换方法 - 已经消失
- (void)vhl_viewDidDisappear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        // 删除 fake NavigationBar
        [self removeFakeNavigationBar];
        // 恢复导航栏浮动偏移
        [self vhl_setNavBarTranslationY:0.0];
    }
    // 调用自己
    [self vhl_viewDidDisappear:animated];
}
// 更新导航栏
- (void)updateNavigationInfo {
    if ([self vhl_navBarHidden]) {
        return;
    }
    if (!self.vhl_fakeNavigationBar) {
        if ([self vhl_navBarBackgroundView]) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundView:[self vhl_navBarBackgroundView]];
        } else if ([self vhl_navBarBackgroundImage]) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:[self vhl_navBarBackgroundImage]];
        } else {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self vhl_navBarBackgroundColor]];
        }
    }
    [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self vhl_navBarTintColor]];
    [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self vhl_navBarTitleColor]];
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self vhl_navBarBackgroundAlpha]];
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:[self vhl_navBarShadowImageHidden]];
    [self vhl_setNavBarTranslationY:[self vhl_navBarTranslationY]];
}
// 更新侧滑手势
- (void)updateInteractivePopGestureRecognizer {
    if (self.navigationController && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.navigationController.viewControllers.count <= 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.navigationController.interactivePopGestureRecognizer.enabled = [self vhl_interactivePopGestureRecognizerEnable];
        }
    }
}
#pragma mark - fake navigation bar ---------------------------------------------
- (UIViewController *)fromVC {
    return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
}
- (UIViewController *)toVC {
    return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
}
/** 能否更新导航栏*/
- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏，且当前是全屏
    if (self.navigationController && [self.navigationController.viewControllers containsObject:self]) {
        return YES;
    }
    return NO;
}
/** 是否需要添加一个假的 NavigationBar*/
- (BOOL)shouldAddFakeNavigationBar {
    // 判断当前导航栏交互的两个VC其中是否设置了导航栏样式为两种颜色导航栏，或者设置了导航栏背景图片，或者透明度不一致(用过渡不好看..)
    UIViewController *fromVC = [self fromVC];
    UIViewController *toVC = [self toVC];
    if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] ||
        [VHLNavigation vhl_isIgnoreVC:NSStringFromClass([toVC class])]) {
        return YES;
    }
    if ((fromVC && ([fromVC vhl_navigationSwitchStyle] == 1 || [fromVC vhl_navBarBackgroundImage])) ||
        (toVC && ([toVC vhl_navigationSwitchStyle] == 1 || [toVC vhl_navBarBackgroundImage])) ||
        [fromVC vhl_navBarHidden] != [toVC vhl_navBarHidden] ||
        [fromVC vhl_navBarBackgroundAlpha] != [toVC vhl_navBarBackgroundAlpha]) {
        return YES;
    }
    return NO;
}
// 是否是被忽略的 ViewController
- (BOOL)isIgnoreVC {
    if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([self class])]) {
        return YES;
    }
    return NO;
}
// 是否都是颜色渐变过渡
- (BOOL)isTransitionStyle {
    UIViewController *fromVC = [self fromVC];
    UIViewController *toVC = [self toVC];
    // 如果 VC 中有隐藏了导航栏的就不做切换效果
    if ([fromVC vhl_navBarHidden] || [toVC vhl_navBarHidden]) {
        return NO;
    }
    // 如果 VC 中设置了自定义导航栏图片
    if (([fromVC vhl_navBarBackgroundImage] || [toVC vhl_navBarBackgroundImage])) {
        return NO;
    }
    // 如果 VC 中设置了切换样式为两种导航栏
    if ([fromVC vhl_navigationSwitchStyle] == 1 || [toVC vhl_navigationSwitchStyle] == 1) {
        return NO;
    }
    // 如果 VC 中两个导航栏的透明度不一样，也使用假的导航栏
    if ([fromVC vhl_navBarBackgroundAlpha] != [toVC vhl_navBarBackgroundAlpha]) {
        return NO;
    }
    return YES;
}
// 判断当前是否是模态跳转
- (BOOL)isMotal {
    UIViewController *toVC = [self toVC];
    if ([toVC isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    return NO;
}
// 判断当前是否是第一个视图
- (BOOL)isRootViewController {
    UIViewController *rootViewController = self.navigationController.viewControllers.firstObject;
    if ([rootViewController isKindOfClass:[UITabBarController class]] == NO) {
        return rootViewController == self;
    } else {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [tabBarController.viewControllers containsObject:self];
    }
}
// 判断是否需要优化导航栏高度：从有状态栏pop到无状态栏,无状态栏VC必须隐藏导航栏
- (BOOL)isStatusBarDiff {
    UIViewController *fromVC = [self fromVC];
    UIViewController *toVC = [self toVC];
    
    CGFloat statusBarHeight = [VHLNavigation defaultStatusBarHeight];
    BOOL needChangeFromNavBarFrame = (![fromVC vhl_statusBarHidden] && [toVC vhl_statusBarHidden]);
    BOOL heightEqual = [fromVC vhl_navigationBarAndStatusBarHeight] == [fromVC vhl_navgationBarHeight];
    
    return (needChangeFromNavBarFrame && heightEqual && statusBarHeight > 0 && [toVC vhl_navBarHidden]);
}
// 添加一个假的 NavigationBar
- (void)addFakeNavigationBar {
    UIViewController *fromVC = [self fromVC];
    UIViewController *toVC = [self toVC];
    
    [fromVC removeFakeNavigationBar];
    [toVC removeFakeNavigationBar];
    
    if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] &&
        [VHLNavigation vhl_isIgnoreVC:NSStringFromClass([toVC class])]) {
        return;
    }
    
    if ((!fromVC.vhl_fakeNavigationBar && ![fromVC vhl_navBarHidden]) ||
        ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] &&
        ![VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])])) {
        
        CGRect fakeNavFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),
                                         [self vhl_navigationBarAndStatusBarHeight]);
        // 2. 判断当前 vc 是否是 UITableViewController 或 UICollectionViewController , 因为这种 vc.view 会为 scrollview
        // ** 虽然 view frame 为全屏开始，但是因为安全区域，使得内容视图在导航栏下面 **
        // ** 千万不要再设置 edgesForExtendedLayout 为 None，因为 tableview 默认开启了 clipsToBounds 会使得添加的导航栏失效 **
        if ([fromVC.view isKindOfClass:[UIScrollView class]] || fromVC.edgesForExtendedLayout == UIRectEdgeNone) {
            // 需要重新计算导航栏在滚动视图中的位置
            fakeNavFrame = [fromVC.view convertRect:fakeNavFrame fromView:fromVC.navigationController.view];
        }
        
        fromVC.vhl_fakeNavigationBar = [[UIImageView alloc] initWithFrame:fakeNavFrame];
        if ([fromVC vhl_navBarBackgroundView]) {
            fromVC.vhl_fakeNavigationBar.backgroundColor = [UIColor clearColor];
            UIView *view = [fromVC vhl_navBarBackgroundView];
            view.bounds = fromVC.vhl_fakeNavigationBar.bounds;
            [fromVC.vhl_fakeNavigationBar addSubview:view];
        } else {
            fromVC.vhl_fakeNavigationBar.backgroundColor = [fromVC vhl_navBarBackgroundColor];
            fromVC.vhl_fakeNavigationBar.image = [fromVC vhl_navBarBackgroundImage];
            if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] && fromVC.navigationController.navigationBar.barTintColor) {
                fromVC.vhl_fakeNavigationBar.backgroundColor = fromVC.navigationController.navigationBar.barTintColor;
            }
        }
        fromVC.vhl_fakeNavigationBar.alpha = [fromVC vhl_navBarBackgroundAlpha];
        [fromVC.view addSubview:fromVC.vhl_fakeNavigationBar];
        [fromVC.view bringSubviewToFront:fromVC.vhl_fakeNavigationBar];
        // 隐藏系统导航栏背景
        [fromVC.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:0.0f];
        
        // - 当从有状态栏切换到无状态栏时，会出现一个当前 vc 显示了底部 vc 的内容，这里增加一个 view 用于遮盖
        // temp background view
        CGRect tempviewFrame = fakeNavFrame;
        tempviewFrame.size.height = tempviewFrame.size.height + [VHLNavigation defaultStatusBarHeight]?:20.0f;
        fromVC.vhl_tempBackView = [[UIView alloc] initWithFrame:tempviewFrame];
        fromVC.vhl_tempBackView.backgroundColor = fromVC.view.backgroundColor;
        [fromVC.view addSubview:fromVC.vhl_tempBackView];
        [fromVC.view sendSubviewToBack:fromVC.vhl_tempBackView];
    }
    if ((!toVC.vhl_fakeNavigationBar && ![toVC vhl_navBarHidden]) ||
        ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([fromVC class])] &&
        ![VHLNavigation vhl_isIgnoreVC:NSStringFromClass([toVC class])] && ![toVC vhl_navBarHidden])) {
        
        CGRect fakeNavFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),[self vhl_navigationBarAndStatusBarHeight]);
        // 判断边缘布局的方式，UIRectEdgeNone 是以导航栏下面开始的
        if (toVC.edgesForExtendedLayout == UIRectEdgeNone) {
            fakeNavFrame = CGRectMake(0, -[self vhl_navigationBarAndStatusBarHeight], CGRectGetWidth(self.view.bounds),
                                      [self vhl_navigationBarAndStatusBarHeight]);
        }
        // 2. 判断当前 vc 是否是 UITableViewController 或 UICollectionViewController , 因为这种 vc.view 会为 tableview
        // 虽然 view frame 为全屏开始，但是内容视图在不设置 edgesForExtendedLayout 的情况下 adjustedContentInset 为在导航栏下面
        if ([toVC.view isKindOfClass:[UIScrollView class]]) {
            fakeNavFrame = [toVC.view convertRect:fakeNavFrame fromView:toVC.navigationController.view];
            CGPoint offset = ((UIScrollView *)toVC.view).contentOffset;
            if (offset.y == 0) {
                fakeNavFrame = CGRectMake(fakeNavFrame.origin.x, fakeNavFrame.origin.y -[self vhl_navigationBarAndStatusBarHeight], fakeNavFrame.size.width, fakeNavFrame.size.height);
            }
        }
        //
        toVC.vhl_fakeNavigationBar = [[UIImageView alloc] initWithFrame:fakeNavFrame];
        if ([toVC vhl_navBarBackgroundView]) {
            toVC.vhl_fakeNavigationBar.backgroundColor = [UIColor clearColor];
            UIView *view = [toVC vhl_navBarBackgroundView];
            view.frame = CGRectMake(0, 0, fakeNavFrame.size.width,fakeNavFrame.size.height);
            [toVC.vhl_fakeNavigationBar addSubview:view];
        } else {
            toVC.vhl_fakeNavigationBar.backgroundColor = [toVC vhl_navBarBackgroundColor];
            toVC.vhl_fakeNavigationBar.image = [toVC vhl_navBarBackgroundImage];
            if ([VHLNavigation vhl_isIgnoreVC:NSStringFromClass([toVC class])] && toVC.navigationController.navigationBar.barTintColor) {
                toVC.vhl_fakeNavigationBar.backgroundColor = toVC.navigationController.navigationBar.barTintColor;
            }
        }
        toVC.vhl_fakeNavigationBar.alpha = [toVC vhl_navBarBackgroundAlpha];
        [toVC.view addSubview:toVC.vhl_fakeNavigationBar];
        [toVC.view bringSubviewToFront:toVC.vhl_fakeNavigationBar];
        // 隐藏系统导航栏背景
        [toVC.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:0.0f];
    }
}
// 将假的导航栏背景删除
- (void)removeFakeNavigationBar {
    if (self.vhl_fakeNavigationBar) {
        [self.vhl_fakeNavigationBar removeFromSuperview];
        self.vhl_fakeNavigationBar = nil;
    }
    if (self.vhl_tempBackView) {
        [self.vhl_tempBackView removeFromSuperview];
        self.vhl_tempBackView = nil;
    }
}
// -
- (UIImageView *)vhl_fakeNavigationBar {
    return (UIImageView *)objc_getAssociatedObject(self, &kVHLFakeNavigationBarKey);
}
- (void)setVhl_fakeNavigationBar:(UIImageView *)navigationBar {
    objc_setAssociatedObject(self, &kVHLFakeNavigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)vhl_tempBackView {
    return (UIView *)objc_getAssociatedObject(self, &kVHLTempBackViewKey);
}
- (void)setVhl_tempBackView:(UIView *)tempbackview {
    objc_setAssociatedObject(self, &kVHLTempBackViewKey, tempbackview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - private method --------------------------------------------------
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

/** 1.设置当前导航栏的背景View*/
- (void)vhl_setNavBarBackgroundView:(UIView *)view {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)vhl_navBarBackgroundView {
    UIView *view = (UIView *)objc_getAssociatedObject(self, &kVHLNavBarBackgroundViewKey);
    return view?: nil;
}
/** 2.设置当前导航栏的背景图片*/
- (void)vhl_setNavBarBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)vhl_navBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kVHLNavBarBackgroundImageKey);
    return image?: nil;
}

/** 3.设置当前导航栏 barTintColor(导航栏背景颜色)*/
- (void)vhl_setNavBarBackgroundColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pushToCurrentVCFinished] && ![self pushToNextVCFinished]) {
        [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
    }
}
- (UIColor *)vhl_navBarBackgroundColor {
    UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarBackgroundColorKey);
    return (barTintColor != nil) ? barTintColor : [VHLNavigation defaultNavBackgroundColor];
}

/** 当前导航栏的透明度*/
- (void)vhl_setNavBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, &kVHLNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
}
- (CGFloat)vhl_navBarBackgroundAlpha {
    id barBackgroundAlpha = objc_getAssociatedObject(self, &kVHLNavBarBackgroundAlphaKey);
    return barBackgroundAlpha ? [barBackgroundAlpha floatValue] : 1.0;
}

/** 设置当前导航栏 TintColor(导航栏按钮等颜色)*/
- (void)vhl_setNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (![self pushToNextVCFinished]) {
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:color];
    }
}
- (UIColor *)vhl_navBarTintColor {
    UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarTintColorKey);
    return (tintColor != nil) ? tintColor : [VHLNavigation defaultNavBarTintColor];
}

/** 设置当前导航栏 titleColor(标题颜色)*/
- (void)vhl_setNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kVHLNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (![self pushToNextVCFinished]) {
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:color];
    }
}
- (UIColor *)vhl_navBarTitleColor {
    UIColor *titleColor = (UIColor *)objc_getAssociatedObject(self, &kVHLNavBarTitleColorKey);
    return (titleColor != nil) ? titleColor : [VHLNavigation defaultNavBarTitleColor];
}

/** 设置当前导航栏 shadowImage(底部分割线)是否隐藏*/
- (void)vhl_setNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kVHLNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:hidden];
}
- (BOOL)vhl_navBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kVHLNavBarShadowImageHiddenKey);
    return hidden?[hidden boolValue]:[VHLNavigation defaultNavBarShadowImageHidden];
}

/** 当前当前导航栏距离顶部的浮动高度*/
- (void)vhl_setNavBarTranslationY:(CGFloat)translationY {
    if (translationY <= 0) translationY = 0;
    if (translationY >= [self vhl_navgationBarHeight]) translationY = [self vhl_navgationBarHeight];
    
    objc_setAssociatedObject(self, &kVHLNavBarTranslationYKey, @(translationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar vhl_setTranslationY:-translationY];
    [self.navigationController.navigationBar vhl_setBarButtonItemsAlpha:(1.0 - (translationY / [self vhl_navgationBarHeight])) hasSystemBackIndicator:NO];
}
- (CGFloat)vhl_navBarTranslationY {
    id translationY = objc_getAssociatedObject(self, &kVHLNavBarTranslationYKey);
    return translationY?[translationY floatValue]:0;
}
/** 设置当前状态栏是否隐藏,默认为NO*/
- (void)vhl_setStatusBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kVHLStatusBarHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate]; // 刷新状态栏
}
- (BOOL)vhl_statusBarHidden {
    id hidden = objc_getAssociatedObject(self, &kVHLStatusBarHiddenKey);
    if ([VHLNavigation vhl_isIPhoneXSeries]) {  // ** iPhoneX 下设置为不能隐藏状态栏
        return NO;
    }
    return hidden?[hidden boolValue]:NO;
}
/** 设置当前状态栏样式 白色/黑色 */
- (void)vhl_setStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kVHLStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法
}
- (UIStatusBarStyle)vhl_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kVHLStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : [VHLNavigation defaultStatusBarStyle];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self vhl_statusBarStyle];
}
/** 设置当前是否启用侧滑手势，默认启用*/
- (void)vhl_setInteractivePopGestureRecognizerEnable:(BOOL)enable {
    objc_setAssociatedObject(self, &kVHLInteractivePopEnableKey, @(enable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)vhl_interactivePopGestureRecognizerEnable {
    id enable = objc_getAssociatedObject(self, &kVHLInteractivePopEnableKey);
    return enable?[enable boolValue]:YES;
}
/** 获取*/
/** 获取当前导航栏高度*/
- (CGFloat)vhl_statusBarHeight {
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}
- (CGFloat)vhl_navgationBarHeight {
    return CGRectGetHeight(self.navigationController.navigationBar.bounds);
}
/** 获取导航栏加状态栏高度*/
- (CGFloat)vhl_navigationBarAndStatusBarHeight {
    CGFloat navHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    // 分享热点，拨打电话等。导航栏从 20 变成 40。
    statusHeight = [VHLNavigation vhl_isIPhoneXSeries]?statusHeight:MIN(20, statusHeight);
    
    return  navHeight + statusHeight;
}
#pragma mark - 屏幕旋转/状态栏隐藏显示相关 ------------------------------------------------------
/** VC 重写以下方法就行*/
// 1. 默认不支持旋转 - 是否支持设备自动旋转
//- (BOOL)shouldAutorotate {
//    return NO;
//}
// 2. 支持屏幕旋转的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
// 3. 横屏状态栏是否隐藏，默认为竖屏不隐藏，横屏隐藏。如果想要横屏也隐藏，那么将该方法拷贝到 VC 中，，返回值为 NO。
- (BOOL)prefersStatusBarHidden {
    return [self vhl_statusBarHidden];
}

@end

/**
 objc_setAssociatedObject 来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。
 */
