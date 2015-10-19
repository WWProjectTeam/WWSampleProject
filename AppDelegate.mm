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


NSString * g_UserId;
NSString * g_UserName;
NSString * g_UserHeadImage;
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
    clotheVC.tabBarItem.title = @"衣柜";

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
    [WXApi registerApp:@"appkey"];
    
    
#pragma mark - 微信支付测试
  //  [self sendPay];
    return YES;
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
    }
}

#pragma mark - 微信
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
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
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application {

}
// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
 //   [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
  //  [[EaseMob sharedInstance] applicationWillTerminate:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}

//============================================================
// V3&V4支付流程实现
// 注意:参数配置请查看服务器端Demo
// 更新时间：2015年3月3日
// 负责人：李启波（marcyli）
//============================================================
- (void)sendPay
{
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?plat=ios&order_no=%@&product_name=%@&order_price=%@",
                           SP_URL,
                           [[NSString stringWithFormat:@"%ld",time(0)] stringByAddingPercentEscapesUsingEncoding:enc],
                           [ORDER_NAME stringByAddingPercentEscapesUsingEncoding:enc],
                           ORDER_PRICE];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
            }
        }else{
            [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
        }
    }else{
        [self alert:@"提示信息" msg:@"服务器返回错误"];
    }
}

- (void)sendPay_demo
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
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


@end
