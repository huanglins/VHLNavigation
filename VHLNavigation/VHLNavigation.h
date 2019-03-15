//
//  VHLNavigation.h
//  VHLNavigation
//
//  Created by vincent on 2017/8/23.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 全局配的属性*/
@interface VHLNavigation : NSObject

/** 判断是否是 iPhone X 系列的异形屏*/
+ (BOOL)vhl_isIPhoneXSeries;

/** 全局设置导航栏背景颜色 */
+ (void)vhl_setDefaultNavBackgroundColor:(UIColor *)color;
/** 全局设置导航栏按钮颜色 */
+ (void)vhl_setDefaultNavBarTintColor:(UIColor *)color;
/** 全局设置导航栏标题颜色 */
+ (void)vhl_setDefaultNavBarTitleColor:(UIColor *)color;
/** 全局设置导航栏黑色分割线是否隐藏*/
+ (void)vhl_setDefaultNavBarShadowImageHidden:(BOOL)hidden;
/** 全局设置状态栏样式*/
+ (void)vhl_setDefaultStatusBarStyle:(UIStatusBarStyle)style;

/** !!!全局设置需要忽略的 ViewController
    在和未设置忽略的导航栏进行切换是会进行两种导航栏样式的切换方式，也可以在 viewWillApper 中设置自己想要的效果，
    但是建议在该组件可以满足的情况下，尽量使用该组件来设置导航栏的样式
 */
/** 全局添加一个需要忽略的 ViewController */
+ (void)vhl_addIgnoreVCClassName:(NSString *)vcClassName;
/** 删除已添加忽略的 ViewController */
+ (void)vhl_removeIgnoreVCClassName:(NSString *)vcClassName;

@end

// -----------------------------------------------------------------------------
@interface UINavigationBar (VHLNavigation)

/** 设置当前 NavigationBar 背景 View */
- (void)vhl_setBackgroundView:(UIView *)view;
/** 设置当前 NavigationBar 背景图片*/
- (void)vhl_setBackgroundImage:(UIImage *)image;
/** 设置当前 NavigationBar 背景颜色*/
- (void)vhl_setBackgroundColor:(UIColor *)color;
/** 设置当前 NavigationBar 背景透明度*/
- (void)vhl_setBackgroundAlpha:(CGFloat)alpha;
/** 设置当前 NavigationBar 底部分割线是否隐藏*/
- (void)vhl_setShadowImageHidden:(BOOL)hidden;
/** 设置当前 NavigationBar _UINavigationBarBackIndicatorView (默认的返回箭头)是否隐藏*/
- (void)vhl_setBarBackIndicatorViewHidden:(BOOL)hidden;
/** 设置导航栏所有 barButtonItem 的透明度*/
- (void)vhl_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

/** 设置当前 NavigationBar 垂直方向上的平移距离*/
- (void)vhl_setTranslationY:(CGFloat)translationY;
/** 获取当前导航栏垂直方向上偏移了多少*/
- (CGFloat)vhl_getTranslationY;

@end

// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, VHLNavigationSwitchStyle) {
    VHLNavigationSwitchStyleTransition = 0,        // 颜色过渡的方式，支付宝个人中心到余额宝切换效果
    VHLNavigationSwitchStyleFakeNavBar = 1,        // 两种不同颜色导航栏，类似微信红包
};

/** UIViewController 导航栏扩展 */
@interface UIViewController (VHLNavigation)

/** 设置当前导航栏侧滑过渡效果*/
- (void)vhl_setNavigationSwitchStyle:(VHLNavigationSwitchStyle)style;
- (VHLNavigationSwitchStyle)vhl_navigationSwitchStyle;

/** 设置当前导航栏是否隐藏，设置隐藏后不会有过渡效果，想要有过渡效果不要隐藏导航栏，而是设置导航栏透明度为 0.0f*/
- (void)vhl_setNavBarHidden:(BOOL)hidden;
- (BOOL)vhl_navBarHidden;

/** 1. 设置当前导航栏背景 View，当背景图片和背景颜色不能满足的时候，可以通过自定义一个导航栏View*/
/** 比如想要一个微信首页的模态模糊视图，又想要其他样式切换效果*/
/** 设置顺序：backgroundView > backgroundImage > backgroundColor */
- (void)vhl_setNavBarBackgroundView:(UIView *)view;
- (UIView *)vhl_navBarBackgroundView;

/** 2. 设置当前导航栏的背景图片，即使当前导航栏过渡样式为颜色渐变也为执行两种导航栏样式过渡*/
- (void)vhl_setNavBarBackgroundImage:(UIImage *)image;
- (UIImage *)vhl_navBarBackgroundImage;

/** 3. 设置当前导航栏 barTintColor(导航栏背景颜色)*/
- (void)vhl_setNavBarBackgroundColor:(UIColor *)color;
- (UIColor *)vhl_navBarBackgroundColor;

/** 设置当前导航栏的透明度。需要 translucent = YES */
- (void)vhl_setNavBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)vhl_navBarBackgroundAlpha;

/** 设置当前导航栏 TintColor(导航栏按钮等颜色)*/
- (void)vhl_setNavBarTintColor:(UIColor *)color;
- (UIColor *)vhl_navBarTintColor;

/** 设置当前导航栏 titleColor(标题颜色)*/
- (void)vhl_setNavBarTitleColor:(UIColor *)color;
- (UIColor *)vhl_navBarTitleColor;

/** 设置当前导航栏 shadowImage(底部分割线)是否隐藏*/
- (void)vhl_setNavBarShadowImageHidden:(BOOL)hidden;
- (BOOL)vhl_navBarShadowImageHidden;

/** 设置当前导航栏向上的偏移量(浮动导航栏) 默认0不偏移，(0到44之间，顶部露出状态栏，其他情况不好看)*/
- (void)vhl_setNavBarTranslationY:(CGFloat)translationY;
- (CGFloat)vhl_navBarTranslationY;

/** 设置当前状态栏是否隐藏,默认为NO, 不隐藏。这样的话就不需要自己重写 prefersStatusBarHidden 方法来进行隐藏*/
/** < iPhone X 下现在默认是都不隐藏状态栏 > */
- (void)vhl_setStatusBarHidden:(BOOL)hidden;
- (BOOL)vhl_statusBarHidden;

/** 设置当前状态栏样式 白色/黑色，也可以直接重写 preferredStatusBarStyle */
- (void)vhl_setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)vhl_statusBarStyle;

/** 设置当前是否启用侧滑手势，默认启用*/
// 需要在自己的 BaseNavigationController 中重写 gestureRecognizerShouldBegin 以解决一些侧滑手势的 bug
- (void)vhl_setInteractivePopGestureRecognizerEnable:(BOOL)enable;
- (BOOL)vhl_interactivePopGestureRecognizerEnable;

/** 设置当前是否需要横屏(默认 NO, 即当前 viewController 不支持横屏)*/

/** 获取当前导航栏高度*/
- (CGFloat)vhl_navgationBarHeight;
/** 获取当前导航栏加状态栏高度*/
- (CGFloat)vhl_navigationBarAndStatusBarHeight;

@end

/**
     移动导航栏 / 隐藏系统返回按钮
     [self.navigationController.navigationBar vhl_setTranslationY:(-navBarHeight * progress)];
     [self.navigationController.navigationBar vhl_setBarButtonItemsAlpha:(1 - progress) hasSystemBackIndicator:YES];
 */

/**
    translucent
    影响navigationBar的半透明效果，默认为true。
 
    对于没有明确设置isTranslucent的navigationBar，如果背景图alpha < 1，则isTranslucent = true。反之为false。
    对于明确设置isTranslucent = true的，如果背景图为不透明，则会为背景图会被添加小于 1 的系统定义的alpha。
    对于明确设置isTranslucent = false的，如果背景图alpha < 1，会根据barStyle或barTintColor为该图片添加一个相应颜色的不透明背景。
 */

/**
 // - 屏幕旋转以及状态栏显示隐藏显示支持 -
 // View controller-based status bar appearance 需要设置为 YES

 // 1.
 - (BOOL)shouldAutorotate {
     return NO;
 }
 // 支持竖屏显示
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return UIInterfaceOrientationMaskPortrait;
 }
 // 横屏状态栏是否隐藏
 - (BOOL)prefersStatusBarHidden {
     return YES;
 }
 */

/*
    associated 关联的
 */

/*
    参考学习：
    http://www.jianshu.com/p/e3ca1b7b6cec
    https://github.com/wangrui460/WRNavigationBar
    https://github.com/CrazyGitter/HansNavController
 */
