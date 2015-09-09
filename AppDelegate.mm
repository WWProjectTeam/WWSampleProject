//
//  AppDelegate.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "AppDelegate.h"

//FunctionalModule
#import "WWHomePageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navtionViewControl = _navtionViewControl;
@synthesize tabBarController   = _tabBarController;


@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //标签页控制器初始化
    WWHomePageViewController * homePageVC = [[WWHomePageViewController alloc]init];

    //视图数组
    NSArray* controllerArray = [[NSArray alloc]initWithObjects:homePageVC,nil];
    
    //标签页控制器初始化
    self.tabBarController = [[UITabBarController alloc]init];
    [self.tabBarController setViewControllers:controllerArray];
    [self.tabBarController setSelectedIndex:0];

    
    //导航条创建
    self.navtionViewControl = [[UINavigationController alloc]initWithRootViewController:self.tabBarController];
    //隐藏系统导航条
  //  [self.navtionViewControl setNavigationBarHidden:YES];
    [self.window setRootViewController:self.navtionViewControl];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
