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
#define WW_BASE_COLOR [UIColor colorWithRed:181.0f/255.0f green:34.0f/255.0f blue:0.0f/255.0f alpha:1.0f]

//字体宏-带适配系数
#define font_size(size) [UIFont systemFontOfSize:size*kPercenX]
#define font_bold_size(size) [UIFont boldSystemFontOfSize:size*kPercenX]

//常用字体设置
#define font_navtionTitle font_bold_size(16)
//请求状态码
#define WWAppSuccessCode @"000"
#define WWAppNoData      @"001"

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


@end
