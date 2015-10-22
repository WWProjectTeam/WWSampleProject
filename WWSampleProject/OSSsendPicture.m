//
//  OSSsendPicture.m
//  AiShou
//
//  Created by eleven on 15/3/12.
//  Copyright (c) 2015年 李 德慧. All rights reserved.
//
#import "OSSsendPicture.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "ASForALYunFBDecryptAES.h"
#import "HTTPClient+Other.h"
#import "HTTPClient.h"

//#define KRequestBaseURL         @"http://192.168.1.120:8080/api/"
//#define KEncryptorKeyURL        @"common/oss-upload-parm"

@implementation OSSsendPicture
{
    int _iamgeFaileflag;
}
+(OSSsendPicture *)sharedInstance
{
    static OSSsendPicture *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OSSsendPicture alloc]init];
    });
    return sharedInstance;
}
/**
 *  back:图片上传目录路径
 */
- (NSString *)sendImageToOSSFormImageData:(UIImage *)upImage
                      imageContentOfRoute:(NSString *)contentHead
                                accessKey:(NSString *)accessKey
                                secretKey:(NSString *)secretKey
                        
{
//    ///图片等比例压缩
//    UIImage *image = upImage;
    ///图片质量压缩jpeg
    NSData *upData = UIImageJPEGRepresentation(upImage, 0.4);
//    NSData *upData = UIImagePNGRepresentation(upImage);

//    ASForALYunFBDecryptAES *yunFBClient = [ASForALYunFBDecryptAES shareASForALYunFBDecryptAES];
//    if ([yunFBClient encryptContentIsEdit]) {
//        [self uploadAliYunKeyParam];
//    }else{
//        
//    }
//    OSSData *testData;
//    OSSClient *ossclient = [OSSClient sharedInstanceManage];
//    NSString *accessKey = @"K5qbuV5tMBeyxm9y";
//    NSString *secretKey = @"ymx8wdk5Qv05HlNbDrBI6PiqvbHstB";
//    NSString *yourBucket = @"iso-img";
    /**
     *  目录：contentHead  年月：year month
     *
     */
    NSDate *  senddate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:senddate];
    UInt64 recordTime = [senddate timeIntervalSince1970]*1000*1000*1000;
    NSLog(@"timeSp:%llu",recordTime); //时间戳的值
    //    NSString *contentHead = @"topic";
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    __block NSString *yourKey;
    if (month > 9) {
        yourKey = [NSString stringWithFormat:@"%@/%ld/%ld/i%llu.jpeg",contentHead,(long)year,(long)month,recordTime];
    }else{
        yourKey = [NSString stringWithFormat:@"%@/%ld/0%ld/i%llu.jpeg",contentHead,(long)year,(long)month,recordTime];
    }
    //@"ymx8wdk5Qv05HlNbDrBI6PiqvbHstB" @"K5qbuV5tMBeyxm9y"
    [self upImageToOSSFormImageData:upData upPath:yourKey accessKey:accessKey secretKey:secretKey];
    return yourKey;
}
///图片上传
-(void)upImageToOSSFormImageData:(NSData *)upData upPath:(NSString *)upPath accessKey:(NSString *)accessKey
secretKey:(NSString *)secretKey
{
    OSSData *testData;
    OSSClient *ossclient = [OSSClient sharedInstanceManage];
    [ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:@"ymx8wdk5Qv05HlNbDrBI6PiqvbHstB"];
        signature = [NSString stringWithFormat:@"OSS %@:%@",@"K5qbuV5tMBeyxm9y" , signature];
        NSLog(@"here signature:%@", signature);
        return signature;
    }];
    [ossclient setGlobalDefaultBucketHostId:self.cnameKey];
    OSSBucket *bucket = [[OSSBucket alloc] initWithBucket:self.bucketKey];
    testData = [[OSSData alloc] initWithBucket:bucket withKey:upPath];
    [testData setData:upData withType:@"jpeg"];
        [OSSLog enableLog:YES];
        NSError *error;
        NSString *errorDomain = [error domain];//获取error domain
        NSInteger errorCode = [error code];//获取错误码
        NSDictionary *errorInfo = [error userInfo];//获取错误信息
        NSLog(@"=======#######----%@-----%@----%@------",errorDomain,errorCode,errorInfo);
    [testData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            ///成功时暂时为0，暂时让失败的方法，只要之前有成功的，如果失败了就可以走三次，除去一直都是失败超过四次，超过四次就不用再传了
            _iamgeFaileflag = 0;
            NSLog(@"------------------------成功--============-----===========----");
        }
        else
        {
            if (_iamgeFaileflag < 4) {
                NSData *imagData = upData;
                NSString *aK = accessKey;
                NSString *sk = secretKey;
                NSString *path = upPath;
                [self upImageToOSSFormImageData:imagData upPath:path accessKey:aK secretKey:sk];
                _iamgeFaileflag++;
            }
            
            NSLog(@"=====================失败==========================----");
            
        }
    } withProgressCallback:^(float progress) {
        //        yourKey = @"";
    }];
    NSString *url = [testData getResourceURL:accessKey andExpire:100000000];
    NSLog(@"--------------------------%@----",url);
}
- (BOOL)OSSJudgeImageSizeFormImage:(UIImage*)image
{
    if (UIImagePNGRepresentation(image).length > 1024 * 1024 *1024) {
        [SVProgressHUD showInfoWithStatus:@"图片太大"];
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)OSSsendImageToOSSFormImageData:(UIImage *)upImage
                imageContentOfRoute:(NSString *)contentHead{

    __block NSString *imageUrl;
    
    //若为YES，表示过期，需要重新获取；若为NO，则可直接使用
    BOOL isReSetBool =  FMASForALYunFBDecryptAES.encryptContentIsEdit;
    if (isReSetBool == NO) {
       imageUrl = [self sendImageToOSSFormImageData:upImage imageContentOfRoute:contentHead accessKey:FMASForALYunFBDecryptAES.decryptAccessKeyId secretKey:FMASForALYunFBDecryptAES.decryptAccessKeySecret];
//        imageUrl = [self sendImageToOSSFormImageData:upImage imageContentOfRoute:contentHead accessKey:FMASForALYunFBDecryptAES.decryptAccessKeyId secretKey:FMASForALYunFBDecryptAES.decryptAccessKeySecret bucketKey:FMASForALYunFBDecryptAES.decryptAlyBucketStr cdnHostKey:FMASForALYunFBDecryptAES.decryptAlyCdnHostStr cnameKey:FMASForALYunFBDecryptAES.decryptAlyCNNameStr];
        
    }
    else{
        __weak __typeof(&*self)weakSelf = self;
        [self uploadAliYunKeyParamWithcomplition:^{
            imageUrl = [weakSelf sendImageToOSSFormImageData:upImage imageContentOfRoute:contentHead accessKey:FMASForALYunFBDecryptAES.decryptAccessKeyId secretKey:FMASForALYunFBDecryptAES.decryptAccessKeySecret];
        } withErrorBlock:^{
            imageUrl = [weakSelf sendImageToOSSFormImageData:upImage imageContentOfRoute:contentHead accessKey:FMASForALYunFBDecryptAES.decryptAccessKeyId secretKey:FMASForALYunFBDecryptAES.decryptAccessKeySecret];
        }];
    }
    return imageUrl;
}

- (void)uploadAliYunKeyParamWithcomplition:(void (^)())block withErrorBlock:(void (^)())errorBlock{
    @try {
        
        
        // 1. 构造URL
        
        NSString *param = [NSString stringWithFormat:@"%@",FMASForALYunFBDecryptAES.getEncryptKeyCodeParameter];
        
        NSString *append =[NSString stringWithFormat:@"%@%@?os=2&sign=%@",@"http://api.aishou.com/api/",KEncryptorKeyForOSSURL,param];
        
        NSLog(@"append is %@",append);
        // 编码，因为URL识别的字符是有限的，26字母数据少量特殊字符，中文无法识别
        NSString *encode = [append stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encode];
        
        // 2. 构造请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        
        //2.1 构造请求体 （1、key=value&key=value[form表单，value可以文件，比如图片]；2、Text，XML，JSON，HTML；3、文件）
        NSString *bodyStr = [NSString stringWithFormat:@""];
        NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        //3. 设置了请求体
        [request setHTTPBody:data];
        
        // 4. 建立连接
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            
            NSLog(@"-----------");
            
            NSDictionary *value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            
            
            NSLog(@"value is %@",value);
            if (data != nil) {
                
                NSString *akCodeStr = StringForKeyInUnserializedJSONDic(value, @"ak");
                NSString *skCodeStr = StringForKeyInUnserializedJSONDic(value, @"sk");
                
                NSString *alHostStr = StringForKeyInUnserializedJSONDic(value, @"cdnHost");
                NSString *alCNNameStr = StringForKeyInUnserializedJSONDic(value, @"cname");
                NSString *alBucketStr = StringForKeyInUnserializedJSONDic(value, @"bucket");
                
                [FMASForALYunFBDecryptAES initAlYunUploadParamForDecryptWithAccessKeyId:akCodeStr withAccessKeySecret:skCodeStr];
                [FMASForALYunFBDecryptAES initALyunUploadOhterorDecryptWithCdnHost:alHostStr withCNNameStr:alCNNameStr withBucketStr:alBucketStr];
                
                
                block();  
            }else{
                errorBlock();
            }
            
        }];
         
         
        
        /*
        
        NSString *paramOSS = [NSString stringWithFormat:@"%@",FMASForALYunFBDecryptAES.getEncryptKeyCodeParameter];
        
        [FMHTTPClient getAShouAESForOSSInitialParamWithOs:@"2" withSign:paramOSS completion:^(WebAPIResponse *response) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                
                
                NSLog(@"response is %@\n",response.responseObject);
                
                if ([response.responseObject count] >3) {
                    
                    NSString *akCodeStr = StringForKeyInUnserializedJSONDic(response.responseObject, @"ak");
                    NSString *skCodeStr = StringForKeyInUnserializedJSONDic(response.responseObject, @"sk");
                    [FMASForALYunFBDecryptAES initAlYunUploadParamForDecryptWithAccessKeyId:akCodeStr withAccessKeySecret:skCodeStr];
                    block();
                }
            });
        }];
         
         */
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
