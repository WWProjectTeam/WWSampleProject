//
//  CommonUtil.m
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/9.
//  Copyright (c) 2015年 张利广. All rights reserved.
//

#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation CommonUtil
+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = (int)strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}
@end
