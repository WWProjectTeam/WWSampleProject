//
//  NSDate+Tool.m
//  AiShou
//
//  Created by 爱瘦 on 14-7-29.
//  Copyright (c) 2014年 李 德慧. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

+ (NSString *) timeStringWithInterval:(NSTimeInterval)time
{
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%d秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    }
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    }
    else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    }
    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    }
    else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        
    }
    return string;
}



- (NSString *)stringWithSeperator:(NSString *)seperator
{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate
{
    NSString *datestring = str;
    //想要设置自己想要的格式，可以用nsdateformatter这个类，这里是初始化
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:formate];
    //把字符串的时间转换成Date对象，用dateFromString方法
    
    NSDate * newdate = [dm dateFromString:datestring];
    
    NSTimeZone *Zone = [NSTimeZone systemTimeZone];
    NSInteger Interval = [Zone secondsFromGMTForDate:newdate];
    NSDate *LocaleDate = [newdate dateByAddingTimeInterval:Interval];
    return LocaleDate;
}

- (NSString *)stringWithFormat:(NSString*)format
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear
{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero.
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero.
- (NSDate *)relativedDateWithInterval:(NSInteger)interval
{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
    
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

+(long)changeTimeToTimeSp:(NSString *)timeStr{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    return time;
}

- (NSString *)weekday
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:self] integerValue];
	if( weekday==1 ){
		weekdayStr = @"星期日";
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
	}
	return weekdayStr;
}

+(NSString *)qiShiZhouShiJian:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:date] integerValue];
    if( weekday==1 ){
		weekdayStr = @"星期日";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-6; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*0; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-1; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-2; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-3; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-4; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*-5; //1:天数
       // NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}
    return @"";
}

+ (NSInteger)xiangChaTianShu:(NSString *)sTime eTime:(NSString *)eTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:eTime];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:sTime];
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
    return days;
}

+(NSString *)jieShuZhouShiJian:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:date] integerValue];
    if( weekday==1 ){
		weekdayStr = @"星期日";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*0; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*6; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*5; //1:天数
       // NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*4; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*3; //1:天数
       // NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*2; //1:天数
        //NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeInterval  interval = 24*60*60*1; //1:天数
       // NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
        NSDate *date1 = [date initWithTimeInterval:+interval sinceDate:date];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        return currentDateStr;
	}
    return @"";
}

+(NSString *)compareDate:(NSString *)dateStr{
    /*字符串换成时间*/
    //设置一个字符串的时间
    NSString *datestring = dateStr;
    //想要设置自己想要的格式，可以用nsdateformatter这个类，这里是初始化
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"yyyy-MM-dd"];
    //把字符串的时间转换成Date对象，用dateFromString方法

    NSDate * newdate = [dm dateFromString:datestring];
    NSDate *Date = [NSDate date];
    NSTimeZone *Zone = [NSTimeZone systemTimeZone];
    NSInteger Interval = [Zone secondsFromGMTForDate:newdate];
    NSDate *LocaleDate = [Date dateByAddingTimeInterval:Interval];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[LocaleDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


@end
