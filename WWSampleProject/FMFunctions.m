//
//  FMFunctions.m
//  AiShou
//
//  Created by 张利广 on 15/3/10.
//  Copyright (c) 2015年 李 德慧. All rights reserved.
//

#import "FMFunctions.h"
#import <CommonCrypto/CommonDigest.h>
//#import "SVPullToRefresh.h"

#pragma mark - JSON
void AddObjectForKeyIntoDictionary(id object, id key, NSMutableDictionary *dic)
{
    if (object == nil || key == nil || dic == nil
        || ![dic isKindOfClass:[NSDictionary class]]
        || ([object isKindOfClass:[NSString class]] && [object isEqualToString:@""]))
        return;
    
    [dic setObject:object forKey:key];
}

id ObjForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    if (unserializedJSONDic == nil || key == nil || ![unserializedJSONDic isKindOfClass:[NSDictionary class]])
        return nil;
    
    id obj = [unserializedJSONDic objectForKey:key];
    if (obj == [NSNull null])
        return nil;
    else if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""])
        return nil;
    else
        return obj;
}
NSString* StringForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return  [NSString stringWithFormat:@"%@",obj];
}
float FloatForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0.0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj floatValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj floatValue];
    }
    return  0.0;
}
double DoubleForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0.0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj doubleValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj doubleValue];
    }
    return  0.0;
}
NSInteger IntForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  0;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj intValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj intValue];
    }
    return  0;
}
Boolean BoolForKeyInUnserializedJSONDic(NSDictionary *unserializedJSONDic, id key)
{
    id obj = ObjForKeyInUnserializedJSONDic(unserializedJSONDic,key);
    if (obj == nil) {
        return  NO;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj boolValue];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj boolValue];
    }
    return  NO;
}

#pragma mark -MD5加密
NSString* EncryptPassword(NSString *str)
{
    
    ///http://192.168.1.120:8080/api/
    ///oss-upload-parm?os=2&sign=09cacfcad1c86eeb252c8b5162f7a0d884975b8c
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark -判断是否为空
Boolean IsStringEmptyOrNull(NSString * str)
{
    if (!str) {
        // null object
        return true;
    } else {
        if ([str isKindOfClass:[NSNull class]]) {
            return true;
        }
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return true;
        } else if([trimedString isEqualToString:@"null"]){
            // is neither empty nor null
            return true;
        }
        else if([trimedString isEqualToString:@"(null)"]){
            // is neither empty nor null
            return true;
        }else {
            return false;
        }
    }
}

#pragma mark -Image TOOL
UIImage* createImageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

UIColor* colorAddAlpha(UIColor* color,CGFloat alpha)
{
    if (CGColorGetNumberOfComponents([color CGColor]) == 2) {
        const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
        return [UIColor colorWithRed:colorComponents[0]
                               green:colorComponents[0]
                                blue:colorComponents[0]
                               alpha:alpha];
    }
    else if (CGColorGetNumberOfComponents([color CGColor]) == 4) {
        const CGFloat * colorComponents = CGColorGetComponents([color CGColor]);
        return [UIColor colorWithRed:colorComponents[0]
                               green:colorComponents[1]
                                blue:colorComponents[2]
                               alpha:alpha];
    }
    return color;
}

Boolean IsNormalMobileNum(NSString  *userMobileNum){
    if ([userMobileNum length] != 11) {
        return NO;
    }
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[3578]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:userMobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, userMobileNum.length)];
    if (numberOfMatch > 0) {
        return YES;
    }
    return NO;
    
}






#pragma mark -dateFormat
NSDateFormatter* dateLocalShortStyleFormatter()
{
    NSDateFormatter *dateFormatter = dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

#pragma mark -时间函数
NSString *timeShortDesc(double localAddTime)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:localAddTime];
    
    // 年月日获得
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekOfYear)
                        fromDate:timeDate];
    
    NSInteger year0 = [comps year];
    NSInteger day0 = [comps day];
    NSInteger weak0 = [comps weekOfYear];
    
    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarUnitWeekOfYear)
                        fromDate:[NSDate date]];
    
    NSInteger year1 = [comps year];
    NSInteger day1 = [comps day];
    NSInteger weak1 = [comps weekOfYear];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    if (year1 > year0)
    {
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    NSUInteger day = day1 - day0;
    if (day == 0)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    
    if (day == 1)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[dateformatter stringFromDate:timeDate]];
    }
    if (day == 2)
    {
        [dateformatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@",[dateformatter stringFromDate:timeDate]];
    }
    
    //本周
    if (weak0 == weak1) {
        [dateformatter setDateFormat:@"EEEE HH:mm"];
        return [dateformatter stringFromDate:timeDate];
    }
    
    [dateformatter setDateFormat:@"MM-dd HH:mm"];
    return [dateformatter stringFromDate:timeDate];
}

#pragma mark -加偏为火星坐标
static const double EARTH_A = 6378245.0;
static const double EARTH_EE = 0.00669342162296594323;
static double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

static double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}
CLLocationCoordinate2D WGS84toGCJ(CLLocationCoordinate2D coord)
{
    CLLocationCoordinate2D mar;
    double dLat = transformLat(coord.longitude - 105.0, coord.latitude - 35.0);
    double dLon = transformLon(coord.longitude - 105.0, coord.latitude - 35.0);
    double radLat = coord.latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - EARTH_EE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((EARTH_A * (1 - EARTH_EE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (EARTH_A / sqrtMagic * cos(radLat) * M_PI);
    mar.latitude = coord.latitude + dLat;
    mar.longitude = coord.longitude + dLon;
    return mar;
}

double distanceByLonlat(double lat1 ,double lat2 ,double lng1 ,double lng2)
{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //返回 m
    return   distance;
    
}

#pragma mark -PullToRefreshView--------------列表公用类到时候用的时候打开
//void UpdateLastRefreshDataForPullToRefreshViewOnView(UIScrollView *view)
//{
//    if (![view respondsToSelector:@selector(pullToRefreshView)])
//        return;
//    NSString *lastUpdateString = [NSString stringWithFormat:@"上次更新:%@",
//                                  [dateLocalShortStyleFormatter() stringFromDate:[NSDate date]]];
//    [view.pullToRefreshView setSubtitle:lastUpdateString forState:SVPullToRefreshStateAll];
//}
//
//void ConfiguratePullToRefreshViewAppearanceForScrollView(UIScrollView *view)
//{
//    if (![view respondsToSelector:@selector(pullToRefreshView)]
//        || view.pullToRefreshView == nil)
//        return;
//    [view.pullToRefreshView setArrowColor:kColorTextColorClay];
//    [view.pullToRefreshView setTextColor:kColorTextColorClay];
//    [view.pullToRefreshView.subtitleLabel setTextColor:kColorTextColorClay];
//    [view.pullToRefreshView setTitle:@"下拉即可刷新..." forState:SVPullToRefreshStateStopped];
//    [view.pullToRefreshView setTitle:@"松开即可刷新..." forState:SVPullToRefreshStateTriggered];
//    [view.pullToRefreshView setTitle:@"刷新中..." forState:SVPullToRefreshStateLoading];
//    UpdateLastRefreshDataForPullToRefreshViewOnView(view);
//}
//
//#pragma mark -LoadMoreCell
//HUILoadMoreCell* CreateLoadMoreCell()
//{
//    HUILoadMoreCell *cell = [[HUILoadMoreCell alloc] initWithReuseIdentifier:kHUILoadMoreCellIdentifier];
//    cell.textLabel.textAlignment    =  NSTextAlignmentCenter;
//    cell.textLabel.textColor        = [UIColor grayColor];//[FMThemeManager.skin textColor];
//    cell.textLabel.font             = [UIFont systemFontOfSize:12.0];
//    cell.textLabel.text             = LOADMORE_LOADING;
//    return cell;
//}

int CountOfUserPersonalContentCharWrodString(NSString *contentStr){
    int i,count = [contentStr length],chinese = 0,ascii = 0;unichar cha;
    for(i = 0;i < count;i++){
        cha=[contentStr characterAtIndex:i];
        if(isascii(cha)){
            ascii++;
        }else{
            chinese += 2;
        }
    }
    if(ascii == 0 && chinese == 0){
        return 0;
    }
    return chinese+ascii;
}

int CountOfUserPersonalContentWrodSizeForString(NSString *contentStr){

    int count = 0;
    if(IsStringEmptyOrNull(contentStr)){
        count = 0;
        
        return count;
    }
    
    count = [contentStr length];
    
    return count;
}