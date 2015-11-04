//
//  AppDelegate.m
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HTTPClient+Other.h"
//FunctionalModule
#import "WWHomePageViewController.h"
// 我的
#import "WWMyPageViewController.h"
#import "WWClotheSpressViewController.h"
// 登陆
#import "WWLoginViewController.h"

//APP端签名相关头文件
#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>
////////////////////
#import <AlipaySDK/AlipaySDK.h>
#import "WWMessageCenterViewController.h"
#import "WWMyOrderViewController.h"

///////个推
#import "GeTuiSdk.h"
NSString * g_UserId;
NSString * g_UserName;
NSString * g_UserHeadImage;
NSString * g_orderId;
@interface AppDelegate ()<UITabBarControllerDelegate>

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
    homePageVC.tabBarItem.title = @"全部";
    
    WWMyPageViewController * myPageVC = [[WWMyPageViewController alloc]init];
    myPageVC.tabBarItem.title = @"我的";
    
    WWClotheSpressViewController * clotheVC = [[WWClotheSpressViewController alloc]init];
    clotheVC.tabBarItem.title = @"租衣";

    //视图数组
    NSArray* controllerArray = [[NSArray alloc]initWithObjects:homePageVC,clotheVC,myPageVC,nil];
    
    //标签页控制器初始化
    self.tabBarController = [[UITabBarController alloc]init];
    [self.tabBarController setViewControllers:controllerArray];
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController setDelegate:self];
    
    //设置标签页控制器图片
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    
    
    //设置高亮颜色
    [[UITabBar appearance] setTintColor:RGBCOLOR(224, 161, 28)];
    
    //设置点击图片和默认图片
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"全部选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"全部默认"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"衣柜选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"衣柜默认"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"我的选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"我的默认"]];
    
    //设置文字高亮色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(224, 161, 28), UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    //设置文字普通色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(167, 167, 167), UITextAttributeTextColor,nil] forState:UIControlStateNormal];

    
    //导航条创建
    self.navtionViewControl = [[UINavigationController alloc]initWithRootViewController:self.tabBarController];
    //隐藏系统导航条
    [self.navtionViewControl setNavigationBarHidden:YES];
    [self.window setRootViewController:self.navtionViewControl];
    
    [self.window makeKeyAndVisible];
    
#pragma mark - wxAPIkey
    //微信
    [WXApi registerApp:APP_ID];
    
    
#pragma mark - 微信支付测试
  //  [self sendPay];
    [self startSdkWith:@"ze09SiKz0X9vJocor6SgU5" appKey:@"q95Mqway49AH5uDmmyE64" appSecret:@"H9Qsnvf1bf9vsLcMHPHT16"];
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
    
    
    
    return YES;
}


#pragma mark - 个推Steup\

- (void)startSdkWith:(NSString *)appID appKey:(NSString*)appKey appSecret:(NSString *)appSecret

{
    
    NSError *err =nil;
    
    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK
    
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    
    //[1-2]:设置是否后台运行开关
    
    [GeTuiSdk runBackgroundEnable:YES];
    
    //[1-3]:设置地理围栏功能，开启LBS定位服务和是否允许SDK 弹出用户定位请求，请求NSLocationAlwaysUsageDescription权限,如果UserVerify设置为NO，需第三方负责提示用户定位授权。
    
   // [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
//    NSString *aAlias = @"苏望";
//    
//    [GeTuiSdk bindAlias:aAlias];
    
    if (err) {
        WWLog(@"个退初始化失败---错误--%@",[err localizedDescription]);
    }
        // [_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
        
    
    
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[WWMyPageViewController class]]) {
        if ([[WWUtilityClass getNSUserDefaults:UserID] isEqualToString:@""]) {
            WWLoginViewController *loginVC = [[WWLoginViewController alloc]init];
            [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }else{
            return;
        }
    }else if ([viewController isKindOfClass:[WWClotheSpressViewController class]]){
        if ([[WWUtilityClass getNSUserDefaults:UserID] isEqualToString:@""]) {
            WWLoginViewController *loginVC = [[WWLoginViewController alloc]init];
            [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        }else{
            return;
        }
    }
}

#pragma mark - 微信
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    WWLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

//微信支付
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        if (resp.errCode == WXSuccess){
//            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [self orderPaySuccess];
            // 通知--刷新信息
            [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
            WWMyOrderViewController *myorderVC = [[WWMyOrderViewController alloc]init];
            [self.navtionViewControl pushViewController:myorderVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"支付失败，请去我的订单中进行支付"];
            // 通知--刷新信息
            [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
        }
        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//                
//            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                
//                break;
//        }
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application {

}
// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //个推进入后台
    [GeTuiSdk enterBackground];
    
 //   [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber --;
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

#pragma amark - 个推---获得token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:_deviceToken];
    if (!g_UserId) {
        [self getuiRequestClientId:_deviceToken];
    }
}

-(void)application:(UIApplication * )application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{

    [application registerForRemoteNotifications];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [GeTuiSdk registerDeviceToken:@""];
    NSLog(@"%@",[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]);
}
#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId  // SDK 返回clientid

{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    
    _clientId = clientId ;
    
    if (_deviceToken) {
        
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    _payloadId = payloadId;
    
    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];
    
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    
    
    NSLog(@"task id : %@, messageId:%@", taskId, aMsgId);
}

//TODO: 接收通知
#pragma mark - 接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber --;
    
    [self asBeginWithDidReceiveRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber --;
    
    [self asBeginWithDidReceiveRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -
#pragma mark - 运行时获取到推送后，进行的操作处理 (app在运行时)
- (void)asBeginWithDidReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    NSDictionary *payload = [[userInfo objectForKey:@"payload"] objectFromJSONString];
    
    if ([[payload objectForKey:@"type"] intValue] == 1) {
        WWMessageCenterViewController *messageVC = [[WWMessageCenterViewController alloc]init];
        [self.navtionViewControl pushViewController:messageVC animated:YES];
    }
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"%@",record);
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}

- (void) GeTuiSdkDidNotifySdkState:(SdkStatus)aStatus{
    NSLog(@"%d3",aStatus);
    
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
  //  [[EaseMob sharedInstance] applicationWillTerminate:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}

+(BOOL)isAuthentication{
    if (g_UserId) {
        return YES;
    }
    
    WWLoginViewController * loginVC = [[WWLoginViewController alloc]init];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
    loginVC.UserLoginStatu = ^(BOOL statu){
        if (statu) {
            if (app.UserLoginStatuUpdate) {
                app.UserLoginStatuUpdate();
            }
        }
    };
    return NO;
}

- (void)getuiRequestClientId:(NSString *)clientId{
    [FMHTTPClient GetGeTuiUserId:[WWUtilityClass getNSUserDefaults:UserID] ClientId:clientId WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
            }else{
                NSLog(@"上传个推返回clientId失败");
            }
        });
    }];
}

-(void)orderPaySuccess{
    [FMHTTPClient GetOrderPaySuccess:g_orderId WithCompletion:^(WebAPIResponse *response) {
        if (response.code == WebAPIResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        }else{
            
        }
    }];
}

@end
