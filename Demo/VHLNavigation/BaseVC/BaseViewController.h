//
//  PLBBaseViewController.h
//  PingLianBank
//
//  Created by vincent on 2016/11/17.
//  Copyright © 2016年 PingLianBank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *navBackButton;

/** 导航栏返回按钮图片*/
@property (nonatomic, strong) UIImage  *navBackButtonImage;          // 导航栏返回按钮图片
/** 导航栏返回按钮标题*/
@property (nonatomic, strong) NSString *navBackButtonTitle;         // 导航栏返回按钮标题
/** 导航栏返回按钮颜色*/
@property (nonatomic, strong) UIColor  *navBackButtonColor;         // 导航栏返回按钮颜色

// ** 导航栏点击事件 **
- (void)navigationItemHandleBack:(UIButton *)button;

@end
