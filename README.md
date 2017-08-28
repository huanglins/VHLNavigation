# VHLNavigation

参考学习 [WRNavigationBar](https://github.com/wangrui460/WRNavigationBar)

新增了微信红包样式导航栏样式切换，通过导航栏切换的时候，隐藏原生的导航栏，并分别添加两个假的导航栏来实现。

![微信样式](https://github.com/huanglins/VHLNavigation/raw/master/screenshots/微信样式.gif)
![颜色过渡](https://github.com/huanglins/VHLNavigation/raw/master/screenshots/颜色过渡.gif)
![背景图片](https://github.com/huanglins/VHLNavigation/raw/master/screenshots/背景图片.gif)
![隐藏导航栏](https://github.com/huanglins/VHLNavigation/raw/master/screenshots/隐藏导航栏.gif)
# 如何使用
<pre>
> 手动拖入 将 VHLNavigation 文件夹拽入项目中，导入头文件：#import "VHLNavigation.h"

#### 隐藏导航栏

```
[self vhl_setNavBarHidden:YES];
```

#### 设置背景图片

```
[self vhl_setNavBarBackgroundImage:[UIImage imageNamed:@"navbg"]];
```

#### 设置为微信红包样式切换

```
    [self vhl_setNavBarBarTintColor:[UIColor colorWithRed:0.35 green:0.42 blue:0.58 alpha:1.00]];
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
```

#### 其他属性

```
设置导航栏透明度
[self vhl_setNavBarBackgroundAlpha:1.0f];
设置状态栏样式
[self vhl_setStatusBarStyle:UIStatusBarStyleLightContent];
设置导航栏标题颜色
[self vhl_setNavBarTitleColor:[UIColor whiteColor]];
设置导航栏按钮颜色
[self vhl_setNavBarTintColor:[UIColor whiteColor]];
设置是否隐藏分割线
[self vhl_setNavBarShadowImageHidden:YES];
```

## 关于
- **blog**: https://www.vincents.cn
- **email**: gvincent@163.com
- **qq**: 2801818138

# License
VHLNavigation is available under the MIT license. See the LICENSE file for more info.


