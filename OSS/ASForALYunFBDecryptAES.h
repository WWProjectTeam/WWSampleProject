//
//  ASForALYunFBDecryptAES.h
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/11.
//  Copyright (c) 2015年 张利广. All rights reserved.
//

#import <Foundation/Foundation.h>


#define FMASForALYunFBDecryptAES [ASForALYunFBDecryptAES shareASForALYunFBDecryptAES]

@interface ASForALYunFBDecryptAES : NSObject


/*!
 *@breif 保留上次请求参数的时间
 */
@property (nonatomic , copy)NSDate          *oldRequestData;

/*!
 *@breif 解密后的阿里云的 Access Key Id
 */
@property (nonatomic , copy)NSString        *decryptAccessKeyId;

/*!
 *@breif 解密后的阿里云的Access Key Secret
 */
@property (nonatomic , copy)NSString        *decryptAccessKeySecret;

@property (nonatomic , copy)NSString        *decryptAlyCdnHostStr;
@property (nonatomic , copy)NSString        *decryptAlyCNNameStr;
@property (nonatomic , copy)NSString        *decryptAlyBucketStr;


+(ASForALYunFBDecryptAES *)shareASForALYunFBDecryptAES;


/** 根据对方提供的密钥，对密文进行解密操作
 
 *@param keyContent 密文内容
 **/
- (NSString *)initializaionDecryptContentWithEncryptContent:(NSString *)keyContent;

/** 根据规则，生成请求密钥的参数内容
 
 *@See 生成规则： OS 进行SHA1加密截取1到10得字符串为，OS，为客户端标示符，IOS为2；
 *@return 请求密钥的sign参数
 **/
- (NSString *)getEncryptKeyCodeParameter;

/** 判断阿里云上传参数是否过期
 
 
 *@return 若为YES，表示过期，需要重新获取；若为NO，则可直接使用
 **/
- (BOOL)encryptContentIsEdit;

/** 根据初始化的参数，解密阿里云参数内容
 
 *@param accessKeyId 阿里云的 Access Key Id
 *@param accessKeySecret 阿里云的Access Key Secret
 **/
- (void)initAlYunUploadParamForDecryptWithAccessKeyId:(NSString *)accessKeyId
                                  withAccessKeySecret:(NSString *)accessKeySecret;

///设置默认参数内容
- (void)initALyunUploadOhterorDecryptWithCdnHost:(NSString *)cdnHostStr
                                   withCNNameStr:(NSString *)cNNameStrStr
                                   withBucketStr:(NSString *)bucketStr;

@end
