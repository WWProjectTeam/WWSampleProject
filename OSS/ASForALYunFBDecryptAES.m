//
//  ASForALYunFBDecryptAES.m
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/11.
//  Copyright (c) 2015年 张利广. All rights reserved.
//

#import "ASForALYunFBDecryptAES.h"
#import "CommonUtil.h"
#import "FMFunctions.h"
#import "FBEncryptorAES.h"
#import "ASFBEncryptorAES.h"

@implementation ASForALYunFBDecryptAES


+ (ASForALYunFBDecryptAES *)shareASForALYunFBDecryptAES{
    static ASForALYunFBDecryptAES *_shareASFBEncryptorAES = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareASFBEncryptorAES = [[ASForALYunFBDecryptAES alloc] init];
    });
    
    return _shareASFBEncryptorAES;
}

- (void)setOldRequestData:(NSDate *)oldRequestData{
    
    [[NSUserDefaults standardUserDefaults] setObject:oldRequestData forKey:@"OldRequestData"];
}

- (NSDate *)oldRequestData{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"OldRequestData"]) {
        return [NSDate new];
    }
    
    return (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"OldRequestData"];
}

- (void)setDecryptAccessKeyId:(NSString *)decryptAccessKeyId{
    [[NSUserDefaults standardUserDefaults] setObject:decryptAccessKeyId forKey:@"DecryptAccessKeyId"];
}

- (NSString *)decryptAccessKeyId{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAccessKeyId"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAccessKeyId"];
}

- (void)setDecryptAccessKeySecret:(NSString *)decryptAccessKeySecret{
    [[NSUserDefaults standardUserDefaults] setObject:decryptAccessKeySecret forKey:@"DecryptAccessKeySecret"];
}

- (NSString *)decryptAccessKeySecret{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAccessKeySecret"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAccessKeySecret"];
}

- (void)setDecryptAlyBucketStr:(NSString *)decryptAlyBucketStr{
    [[NSUserDefaults standardUserDefaults]setObject:decryptAlyBucketStr forKey:@"DecryptAlyBucketString"];
}

- (NSString *)decryptAlyBucketStr {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyBucketString"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyBucketString"];
}

- (void)setDecryptAlyCdnHostStr:(NSString *)decryptAlyCdnHostStr{
    [[NSUserDefaults standardUserDefaults]setObject:decryptAlyCdnHostStr forKey:@"DecryptAlyCdnHostString"];
}

- (NSString *)decryptAlyCdnHostStr{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyCdnHostString"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyCdnHostString"];
}


- (void)setDecryptAlyCNNameStr:(NSString *)decryptAlyCNNameStr{
     [[NSUserDefaults standardUserDefaults]setObject:decryptAlyCNNameStr forKey:@"DecryptAlyCNNameString"];
}

- (NSString *)decryptAlyCNNameStr{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyCNNameString"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DecryptAlyCNNameString"];
}

#pragma mark - 根据规则，生成请求密钥的参数内容
- (NSString *)getEncryptKeyCodeParameter{
    
    NSString *paramP = @"os2";
    NSString *osString = [CommonUtil sha1:paramP];
    
    if ([osString length] < 1) {
        return @"";
    }
    
    return osString;
}

#pragma mark - 根据对方提供的密钥，对密文进行解密操作
- (NSString *)initializaionDecryptContentWithEncryptContent:(NSString *)keyContent{
    
    //加密处理设置
    char iv[] = {0x12, 0x34, 0x56, 0x78, 0x90,0xAB, 0xCD, 0xEF,
        0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    NSData *ivData = [NSData dataWithBytes:iv length:16];
    
    ///将密文处理
    NSData *encryptData = [NSData dataFromBase64String:keyContent ];
    
    NSData *data=[FBEncryptorAES decryptData:encryptData
                                         key:[FMShareASFBEncryptorAES.accurateKeyCode dataUsingEncoding:NSUTF8StringEncoding]
                                          iv:ivData];
    NSString *decodeStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];;
    
    return decodeStr;
}

///时间间隔
- (NSInteger)intervalFordate{
    NSDate *curData = [NSDate new];
    
    NSDate *oldBGDate = FMASForALYunFBDecryptAES.oldRequestData;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:oldBGDate toDate:curData options:0];
    
    NSInteger sec = [d hour]*3600 + [d minute]*60 + [d second];
    
    return sec;
}

#pragma mark - 判断阿里云上传参数是否过期
- (BOOL)encryptContentIsEdit{
    
    //若为YES，表示过期，需要重新获取；若为NO，则可直接使用
    BOOL isEdit = YES;
    
    NSInteger second = [self intervalFordate];
    
    ///  < 1.5 小时，则视为有效，即：不需要再次编辑参数信息 second = 60*60* 1.5 = 5400
    /// @See second > 1 目的是区别出首次使用，两个时间的差值为0
    if(second < 5400 && second > 1){
        isEdit = NO;
    }
    return isEdit;
}

#pragma mark - 根据初始化的参数，解密阿里云参数内容
- (void)initAlYunUploadParamForDecryptWithAccessKeyId:(NSString *)accessKeyId
                                  withAccessKeySecret:(NSString *)accessKeySecret{
    ///设置请求的时间
    [FMASForALYunFBDecryptAES setOldRequestData:[NSDate new]];
    
    ////解密AK
    NSString *decrytAKContent = [FMASForALYunFBDecryptAES initializaionDecryptContentWithEncryptContent:accessKeyId];
    
    ///解密SK
    NSString *decrytSKContent = [FMASForALYunFBDecryptAES initializaionDecryptContentWithEncryptContent:accessKeySecret];
    
    ///初始化明文AccessKeyId
    [FMASForALYunFBDecryptAES setDecryptAccessKeyId:decrytAKContent];
    
    ///初始化好明文AccessKeySecret
    [FMASForALYunFBDecryptAES setDecryptAccessKeySecret:decrytSKContent];
    
    NSLog(@"\n\n decryptAccessKeyId is \t\t\t%@\n decryptAccessKeySecret is \t\t\t%@",FMASForALYunFBDecryptAES.decryptAccessKeyId,FMASForALYunFBDecryptAES.decryptAccessKeySecret);
}

- (void)initALyunUploadOhterorDecryptWithCdnHost:(NSString *)cdnHostStr
                                   withCNNameStr:(NSString *)cNNameStrStr
                                   withBucketStr:(NSString *)bucketStr{

    
    if (!IsStringEmptyOrNull(cdnHostStr)) {
        [FMASForALYunFBDecryptAES setDecryptAlyCdnHostStr:cdnHostStr];
    }else{
        [FMASForALYunFBDecryptAES setDecryptAlyCdnHostStr:@""];
    }
    

    if (!IsStringEmptyOrNull(cNNameStrStr)) {
        [FMASForALYunFBDecryptAES setDecryptAlyCNNameStr:cNNameStrStr];
    }else{
        [FMASForALYunFBDecryptAES setDecryptAlyCNNameStr:@""];
    }
    
    if (!IsStringEmptyOrNull(bucketStr)) {
        [FMASForALYunFBDecryptAES setDecryptAlyBucketStr:bucketStr];
    }else{
        [FMASForALYunFBDecryptAES setDecryptAlyBucketStr:@""];
    }
    
        NSLog(@"\n\n decryptAlyBucketStr is \t\t\t%@\n decryptAlyCdnHostStr is \t\t\t%@\n decryptAlyCNNameStr is \t\t\t%@",FMASForALYunFBDecryptAES.decryptAlyBucketStr,FMASForALYunFBDecryptAES.decryptAlyCdnHostStr,FMASForALYunFBDecryptAES.decryptAlyCNNameStr);
}

@end
