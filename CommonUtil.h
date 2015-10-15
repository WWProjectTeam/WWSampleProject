//
//  CommonUtil.h
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/9.
//  Copyright (c) 2015年 张利广. All rights reserved.
//




#import <Foundation/Foundation.h>

/** 常用加解密算法
 
 *
 **/
@interface CommonUtil : NSObject

/** 获取MD5加密后的字符串
 
 *@param input 源字符串
 *@return   NSString md5加密后得字符串
 **/
+ (NSString *)md5:(NSString *)input;

/** 获取SHA1加密后的字符串
 
 *@param input 源字符串
 *@return   NSString sha1加密后得字符串
 **/
+ (NSString *)sha1:(NSString *)input;
@end
static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}