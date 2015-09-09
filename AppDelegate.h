//
//  AppDelegate.h
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//控制器创建
@property (strong, nonatomic) UINavigationController * navtionViewControl;
@property (strong, nonatomic) UITabBarController     * tabBarController;
@end

