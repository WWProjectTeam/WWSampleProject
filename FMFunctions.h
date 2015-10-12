//
//  FMFunctions.h
//  AiShou
//
//  Created by 张利广 on 15/3/10.
//  Copyright (c) 2015年 李 德慧. All rights reserved.
//


#ifndef FMFunctions_h
#define FMFunctions_h

#if defined __cplusplus
extern "C" {
#endif
    
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
    
#define kHUITimeIntervalSecond          1.00
#define kHUITimeIntervalMinute          60.00
#define kHUITimeIntervalHour            3600.00
#define kHUITimeIntervalDay             (3600.00 * 24.00)
#define kHUITimeIntervalYear            (kHUITimeIntervalDay * 365.00)
    
#pragma  pack()
    
    
#pragma mark - JSON
    //将键-值对加入字典。会剔除object或key或dic为nil的情况
    extern void AddObjectForKeyIntoDictionary(id object, id key, NSMutableDictionary *dic);
    
    //从反JSON序列化后的字典里面读取Key对应的对象。 如果对象为NSString对象并且是@"", 会返回nil
    extern id ObjForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的String,不是String的数据则进行转换
    extern NSString* StringForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的CGFloat,不是CGFloat的数据则进行转换
    extern float FloatForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的double,不是double的数据则进行转换
    extern double DoubleForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的NSInteger,不是NSInteger的数据则进行转换
    extern NSInteger IntForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
    
    //从反JSON序列化后的字典里面读取Key对应的Boolean,不是Boolean的数据则进行转换
    extern Boolean BoolForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key);
#pragma mark -Image TOOL
    extern UIImage* createImageWithColor(UIColor *color);
    extern UIColor* colorAddAlpha(UIColor* color,CGFloat alpha);
#pragma mark -MD5加密
    extern NSString* EncryptPassword(NSString *str);
    
#pragma mark -判断是否为空
    extern Boolean IsStringEmptyOrNull(NSString * str);
    
#pragma mark -时间函数
    extern NSString *timeShortDesc(double localAddTime);
    
#pragma mark -GPS转火星坐标
    extern CLLocationCoordinate2D WGS84toGCJ(CLLocationCoordinate2D coord);
    extern double distanceByLonlat(double lat1 ,double lat2 ,double lng1 ,double lng2);
#pragma mark -是否为手机号
    extern Boolean IsNormalMobileNum(NSString  *userMobileNum);
    
#pragma mark -PullToRefreshView
    extern void UpdateLastRefreshDataForPullToRefreshViewOnView(UIScrollView *view);
    extern void ConfiguratePullToRefreshViewAppearanceForScrollView(UIScrollView *view);
#pragma mark -LoadMoreCell
//    extern HUILoadMoreCell* CreateLoadMoreCell();
    
    
#pragma mark - 判断内容所占字符数（汉字视为2个）
    /** 用于计算内容的字符数
     
     *@See 一个汉字记做两个字符
     **/
    extern int CountOfUserPersonalContentCharWrodString(NSString *contentStr);
    
#pragma mark - 判断内容所占字符数（汉字视为2个）
    /** 用于计算内容的字数
     
     *@See 1个汉字或字符或字母或符号，均视为1
     **/
    extern int CountOfUserPersonalContentWrodSizeForString(NSString *contentStr);

    
#if defined __cplusplus
};
#endif


#endif
