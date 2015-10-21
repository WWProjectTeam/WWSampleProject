//
//  WWUtilityClass.h
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//


@interface WWUtilityClass : NSObject

//打印命令--请务必使用此命令
#ifdef DEBUG
# define WWLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]\n" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define WWLog(...);
#endif

//设备屏幕高度
#ifndef MainView_Height
#define MainView_Height    [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef MainView_Width
#define MainView_Width    [UIScreen mainScreen].bounds.size.width
#endif

//如果为ios7，则返回20的冗余
#ifndef IOS7_Y
#define IOS7_Y              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?20:0)
#endif

//屏幕适配系数-x
#define kPercenX MainView_Width / 320
#define iphone_size_scale(value) (value /(320.0f/[UIScreen mainScreen].bounds.size.width))

//rpg颜色宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


//常用颜色定义

//工程主调颜色
#define WW_BASE_COLOR [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
//线条颜色
#define WWPageLineColor                 RGBCOLOR(217,217,217)
//内容颜色
#define WWContentTextColor              RGBCOLOR(51,51,51)
//副标题颜色
#define WWSubTitleTextColor             RGBCOLOR(153,153,153)
//按键高亮的显示颜色
#define WWBtnStateHighlightedColor      RGBCOLOR(222,222,222)
//部分按钮专用“黄色”
#define WWBtnYellowColor                RGBCOLOR(224,162,28)

//字体宏-带适配系数
#define font_size(size) [UIFont systemFontOfSize:size*kPercenX]
#define font_bold_size(size) [UIFont boldSystemFontOfSize:size*kPercenX]

//常用字体设置
#define font_navtionTitle font_bold_size(16)
//请求状态码
#define WWAppSuccessCode @"100"
#define WWAppNoData      @"001"

// 商品ID
#define kAppleLookupURLTemplate     @"http://itunes.apple.com/lookup?id=%@"
#define kAppStoreURLTemplate        @"itms-apps://itunes.apple.com/app/id%@"
#define kAppid                      @"923826908"        // 暂用爱瘦到时候换

////阿里云测试接口
#define KEncryptorKeyForOSSURL                  @"common/oss-upload-parm"
#define KEncryptorKeyURL                        @"common/aes-sk"


#pragma mark ----------------- NotificationName
// 刷新个人信息
#define WWRefreshUserInformation                @"refreshUserInformation"
// 衣柜删除刷新信息
#define WWDelegateWantWearGoods                 @"DelegateWantWearGoods"


//客服的电话号码
#define WWSupportTel        @"400-585-5896"

#pragma mark - 常用方法
//键盘隐藏
+ (void)hidderKeyboard;

//获得当前时间
+ (NSString *)getTodayTimerWithtDateFormat:(NSString *)str;

//颜色转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//计算文字宽高度
+ (CGSize)boundingRectWithSize:(CGSize)size withText:(NSString *)text withFont:(UIFont *)font;

//md5加密
+ (NSString *)md5HexDigest:(NSString*)input;

//正则判断手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (void)saveNSUserDefaults:(NSString *)key value:(NSString *)value;

+ (NSString *)getNSUserDefaults:(NSString *)key;
@end
