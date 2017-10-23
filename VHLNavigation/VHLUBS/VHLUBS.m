//
//  VHLUBS.m
//  VHLNavigation
//
//  Created by vincent on 2017/10/10.
//  Copyright © 2017年 Darnel Studio. All rights reserved.
//

#import "VHLUBS.h"
#import <objc/runtime.h>

@implementation UIViewController (VHLUBS)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -> 交换方法
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:),
            @selector(viewDidAppear:),
            @selector(viewDidDisappear:),
        };
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"vhlubs_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
#pragma mark -
- (void)vhlubs_viewWillAppear:(BOOL)animated {
    NSLog(@"UBS - viewWillAppear");
    // 调自己
    [self vhlubs_viewWillAppear:animated];
}
- (void)vhlubs_viewWillDisappear:(BOOL)animated {
    // 调自己
    [self vhlubs_viewWillDisappear:animated];
}
- (void)vhlubs_viewDidAppear:(BOOL)animated {
    // 调自己
    [self vhlubs_viewDidAppear:animated];
}
- (void)vhlubs_viewDidDisappear:(BOOL)animated {
    // 调自己
    [self vhlubs_viewDidDisappear:animated];
}
@end

@implementation UIControl (VHLUBS)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // -> 交换方法
        SEL needSwizzleSelectors = @selector(sendAction:to:forEvent:);
        NSString *newSelectorStr = [NSString stringWithFormat:@"vhlubs_%@", NSStringFromSelector(needSwizzleSelectors)];
        Method originMethod = class_getInstanceMethod(self, needSwizzleSelectors);
        Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
        method_exchangeImplementations(originMethod, swizzledMethod);
    });
}

- (void)vhlubs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"UBS - Action");
    // 调用自己
    [self vhlubs_sendAction:action to:target forEvent:event];
}

@end
