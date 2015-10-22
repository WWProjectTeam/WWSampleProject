//
//  NSDate+Tool.h
//  AiShou
//
//  Created by 爱瘦 on 14-7-29.
//  Copyright (c) 2014年 李 德慧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)

+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;

+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;
- (NSString *)stringWithSeperator:(NSString *)seperator;
- (NSString *)stringWithFormat:(NSString*)format;
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;
- (NSString *)weekday;

- (NSDate *)relativedDateWithInterval:(NSInteger)interval ;
+(long)changeTimeToTimeSp:(NSString *)timeStr;
+(NSString *)compareDate:(NSString *)dateStr;
+(NSString *)qiShiZhouShiJian:(NSDate *)date;
+(NSString *)jieShuZhouShiJian:(NSDate *)date;
+ (NSInteger)xiangChaTianShu:(NSString *)sTime eTime:(NSString *)eTime;
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
@end
