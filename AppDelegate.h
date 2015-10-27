//
//  AppDelegate.h
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>
//环信
//#import "EaseMob.h"

//微信
#import "WXApi.h"

#import "GeTuiSdk.h"

extern NSString * g_UserId;
extern NSString * g_UserName;
extern NSString * g_UserHeadImage;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UITabBarDelegate,GeTuiSdkDelegate>{
    NSString *_deviceToken;
    NSString *_clientId;
    NSString *_payloadId;
}

@property (strong, nonatomic) UIWindow *window;


//控制器创建
@property (strong, nonatomic) UINavigationController * navtionViewControl;
@property (strong, nonatomic) UITabBarController     * tabBarController;


//////////////////isAuthentication
+(BOOL)isAuthentication;
//////////////////注销本地通知
+(void)dismissLocalNotification;

@property (nonatomic ,copy) void (^UserLoginStatuUpdate)();



@end

