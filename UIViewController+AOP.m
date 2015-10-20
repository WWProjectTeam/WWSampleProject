//
//  UIViewController+AOP.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/runtime.h>

#import "MobClick.h"
@implementation UIViewController (AOP)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // swizzleMethod
        swizzleMethod(class, @selector(viewDidLoad), @selector(aop_viewDidLoad));
        swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
        
        
        //三方类初始化
        //友盟----渠道名称自己修改
         [MobClick startWithAppkey:@"55fb7f61e0f55a1b9e003532" reportPolicy:BATCH channelId:@"App Store"];
        
        //友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4及以上版本的Version，可以使用下面的方法；
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        
        //设置后台模式
        [MobClick setBackgroundTaskEnabled:YES];

        
        g_UserId = [WWUtilityClass getNSUserDefaults:UserVipID];

    });
}

void swizzleMethod(Class class, SEL originalSelector,SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)aop_viewDidAppear:(BOOL)animated {
    [self aop_viewDidAppear:animated];
}

-(void)aop_viewWillAppear:(BOOL)animated {
    [self aop_viewWillAppear:animated];

    //友盟-页面统计
#ifndef DEBUG
    [MobClick beginLogPageView:NSStringFromClass([self class])];
#endif
    

}
-(void)aop_viewWillDisappear:(BOOL)animated {
    [self aop_viewWillDisappear:animated];
    
    //友盟-页面统计
#ifndef DEBUG
    [MobClick endLogPageView:NSStringFromClass([self class])];
#endif
    

}

- (void)aop_viewDidLoad
{
    [self aop_viewDidLoad];
   
}
@end
