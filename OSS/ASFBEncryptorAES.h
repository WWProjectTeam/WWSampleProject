//
//  ASFBEncryptorAES.h
//  FBEncryptorForAES
//
//  Created by 张利广 on 15/3/9.
//  Copyright (c) 2015年 张利广. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMShareASFBEncryptorAES [ASFBEncryptorAES ShareASFBEncryptorAES]

@interface ASFBEncryptorAES : NSObject

/*!
 *@breif 密钥内容
 */
@property (nonatomic , copy)NSString        *ASAESKeyCode;

/*!
 *@breif 初始化时间戳的长度，用于截取字符串
 */
@property (nonatomic , assign)NSInteger     timeStampLength;

/*!
 *@breif 保存当前时间Day
 *@See 用于更新密钥内容
 */
@property (nonatomic , assign)NSInteger     currentDateDay;

/*!
 *@breif 精准的KEYCode
 */
@property (nonatomic , copy)NSString        *accurateKeyCode;


+ (ASFBEncryptorAES *)ShareASFBEncryptorAES;


/** 对明文进行AES加密
 
 *@param originalContent 明文内容
 *
 **/
- (NSString *)initializaionEncryptContentWithOriginalContent:(NSString *)originalContent;

/** 根据秘密要，对密文进行解密操作

 *@param keyContent 密文内容
 **/
- (NSString *)initializaionDecodeContentWithEncryptContent:(NSString *)encryptContent;

/** 初始化密钥信息，及需要的参数
 
 *@See 启动APP时，初始化密钥
 *@See  多数情况下，iPhone 的APP只是挂起，未被关闭，，故，进入唤醒时进行更新密钥操作；
 **/
- (void)initializaionKeyCode:(NSString *)keySystemCode
              withSystemDate:(NSString *)sysData;


/** 根据规则，生成请求密钥的参数内容
 
 *@See 生成规则： OS 进行SHA1加密截取1到10得字符串为，OS，为客户端标示符，IOS为2；
 *@return 请求密钥的sign参数
 **/
- (NSString *)getEncryptKeyCodeParameter;

/** 判断是否需要更新密钥
 
 *@See用于判断是否需要更新本地密钥内容;
 *@See若为NO，则不需要请求服务器；若为YES，则需要请求服务器；
 **/
- (BOOL)initIsEditEncryptorKeyInfor;
@end
