//
//  ASFBEFBEncryptorAES.m
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/9.
//  Copyright (c) 2015年 张利广. All rights reserved.
//

#import "ASFBEncryptorAES.h"
#import "CommonUtil.h"
#import "FBEncryptorAES.h"
//#import "GTMBase64.h"
//#import "NSData+CommonCrypto.h"

@implementation ASFBEncryptorAES


///设置单例
+ (ASFBEncryptorAES *)ShareASFBEncryptorAES{
    static ASFBEncryptorAES *_shareASFBEncryptorAES = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareASFBEncryptorAES = [[ASFBEncryptorAES alloc] init];
    });
    
    return _shareASFBEncryptorAES;
}
- (void)setASAESKeyCode:(NSString *)ASAESKeyCode{
    
    [[NSUserDefaults standardUserDefaults] setObject:ASAESKeyCode forKey:@"ASAESKeyCodeString"];
}

- (NSString *)ASAESKeyCode{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"ASAESKeyCodeString"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"ASAESKeyCodeString"];
}

- (void)setTimeStampLength:(NSInteger)timeStampLength{
    [[NSUserDefaults standardUserDefaults] setInteger:timeStampLength forKey:@"TimeStampLength"];
}

- (NSInteger)timeStampLength{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"TimeStampLength"]) {
        return 10;
    }
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"TimeStampLength"];
}


- (void)setCurrentDateDay:(NSInteger)currentDateDay{
    
    [[NSUserDefaults standardUserDefaults] setInteger:currentDateDay forKey:@"CurrentDateDay"];
}

- (NSInteger)currentDateDay{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentDateDay"]) {
        return 0;
    }
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentDateDay"];
}


- (void)setAccurateKeyCode:(NSString *)accurateKeyCode{
    [[NSUserDefaults standardUserDefaults] setObject:accurateKeyCode forKey:@"AccurateKeyCode"];
}

- (NSString *)accurateKeyCode{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AccurateKeyCode"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"AccurateKeyCode"];
}

///获取系统时间
///@See 返回字符串
- (NSString *)nowDateCurrent{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

///获取当前时间的最后一位
- (int)dataLastUnitWith:(NSString *)currentDateStr{
    
    
    NSArray *dateArra = [currentDateStr componentsSeparatedByString:@"-"];
    
    int unit = [[dateArra lastObject] integerValue ]%10;
    
    NSLog(@"unit is %d",unit);
    return unit;
    
}

///获取当前日期
- (NSInteger)dataDayCurrentWith:(NSString *)currentDateStr{
    
    NSArray *dateArra = [currentDateStr componentsSeparatedByString:@"-"];
    
    NSInteger nowDay = [[dateArra lastObject] integerValue];
    
    return nowDay;
}


/*
 ///根据日期最后一位获取密钥内容
 - (NSString *)keyCodeStringWithDateUnit:(int)lastUnit{
 
 NSArray *keyArray = @[@"0isk$^",@"i1sk$p",
 @"2iskw#",@"i3skp^",
 @"i4sk$^",@"5iskw^",
 @"is6k$p",@"7isk$^",
 @"ps8^w#",@"9$isp^"];
 
 return [keyArray objectAtIndex:lastUnit];
 }
 
 */


///获取SHA1加密后的数据内容
- (NSString *)initializaionSHAFirstWithOriginalKeyCode:(NSString *)keyString{
    
    //    NSLog(@"keyString is %@",keyString);
    NSString *keyCode = [NSString stringWithFormat:@"%@",keyString];
    if (!keyCode) {
        return @"";
    }
    
    return [CommonUtil sha1:keyCode];
}

//TODO:注意，这个方法是根据需求进行改动的
///根据时当前时间的尾数获取精准密钥
- (NSString *)initializaionKeyCodeWithSHAString:(NSString *)sha1String
                                    withDateLen:(NSInteger)strLen{
    
    
    if ([sha1String length] < 1) {
        return @"";
    }
    if (strLen < 1)
        return @"";
    
    
    if ([sha1String length] < strLen)
        return @"";
    
    NSString *subString = [sha1String substringFromIndex:1];
    
    return [NSString stringWithFormat:@"%@",[subString substringToIndex:(strLen-1)]];
}


- (NSString *)initializaionAccurateKeyCode:(NSString *)keyCode{
    
    ////SHA1加密后的字符串
    NSString *keyForShaString = [self initializaionSHAFirstWithOriginalKeyCode:keyCode];
    
    ///根据时间长度获取精准密钥
    NSString *accurateCode = [self initializaionKeyCodeWithSHAString:keyForShaString
                                                         withDateLen:self.timeStampLength];
    
    return accurateCode;
}


#pragma mark - 对明文进行AES加密
- (NSString *)initializaionEncryptContentWithOriginalContent:(NSString *)originalContent{
    
    
    
    
    if ([self.ASAESKeyCode length] < 1) {
        
        NSLog(@"Error:密钥为空！");
        
        return @"";
    }
    //加密处理设置
    char iv[] = {0x12, 0x34, 0x56, 0x78, 0x90,0xAB, 0xCD, 0xEF,
        0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    NSData *ivData = [NSData dataWithBytes:iv length:16];
    
    
    NSData *data = [FBEncryptorAES encryptData:[originalContent dataUsingEncoding:NSUTF8StringEncoding]
                                           key:[FMShareASFBEncryptorAES.accurateKeyCode dataUsingEncoding:NSUTF8StringEncoding]
                                            iv:ivData];
    
    return [data base64EncodedString];
}


#pragma mark - 根据秘密要，对密文进行解密操作
- (NSString *)initializaionDecodeContentWithEncryptContent:(NSString *)encryptContent{
    ///加密处理设置
    char iv[] = {0x12, 0x34, 0x56, 0x78, 0x90,0xAB, 0xCD, 0xEF,
        0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    NSData *ivData = [NSData dataWithBytes:iv length:16];

    ///将密文处理
    NSData *encryptData = [NSData dataFromBase64String:encryptContent];
    
    NSData *data=[FBEncryptorAES decryptData:encryptData
                                         key:[FMShareASFBEncryptorAES.accurateKeyCode dataUsingEncoding:NSUTF8StringEncoding]
                                          iv:ivData];
    ///将密文处理
    NSString *decodeStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
    
    return decodeStr ;
}

#pragma mark - 根据规则，生成请求密钥的参数内容
- (NSString *)getEncryptKeyCodeParameter{
    
    NSString *osString = [CommonUtil sha1:@"os2"];
    
    if ([osString length] < 1) {
        return @"";
    }
    return osString;
}


#pragma mark - 初始化密钥信息，及需要的参数
- (void)initializaionKeyCode:(NSString *)keySystemCode
              withSystemDate:(NSString *)sysData{
    
    ///初始化密钥
    
    [FMShareASFBEncryptorAES setASAESKeyCode:keySystemCode];
    
    ///初始化时间戳的长度，用于截取字符串
    
    int dateUnit = [self dataLastUnitWith:sysData];
    NSInteger time = 10+dateUnit;
    [FMShareASFBEncryptorAES setTimeStampLength:time];
    
    ///保留时间，
    NSInteger nowData = [self dataDayCurrentWith:sysData];
    [FMShareASFBEncryptorAES setCurrentDateDay:nowData];
    
    ///保留精准KeyCode
    NSString *accurateCode = [self initializaionAccurateKeyCode:self.ASAESKeyCode];
    [FMShareASFBEncryptorAES setAccurateKeyCode:accurateCode];  
}


#pragma mark - 判断是否需要更新密钥
- (BOOL)initIsEditEncryptorKeyInfor{
    
    BOOL isEidt = YES;
    
    NSString *nowDateCurrent = [self nowDateCurrent];
    if (FMShareASFBEncryptorAES.currentDateDay == [self dataDayCurrentWith:nowDateCurrent]) {
        isEidt = NO;
    }
    
    [self getEncryptKeyCodeParameter];
    
    return isEidt;
}

@end
