//
//  HTTPClient.h
//  NetWorkingDemo
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "WebAPIDefine.h"
#import "WebAPIResponse.h"

typedef void (^WebAPIRequestCompletionBlock)(WebAPIResponse* response);


//定义网络错误提示信息
#define NETERROR_LOADERR_TIP            @"读取失败,网络异常"


#define FMHTTPClient [HTTPClient sharedHTTPClient]


@interface HTTPClient : AFHTTPClient


//获取API单实例
+ (HTTPClient *)sharedHTTPClient;

//获取图片服务器单实例
//+ (HTTPClient *)sharedImageClient;

//get请求
- (AFHTTPRequestOperation *)getPath:(NSString *)path
                         parameters:(NSDictionary *)parameters
                         completion:(WebAPIRequestCompletionBlock)completionBlock;


//post请求
- (AFHTTPRequestOperation *)postPath:(NSString *)path
                          parameters:(NSDictionary *)parameters
                          completion:(WebAPIRequestCompletionBlock)completionBlock;

//6：second_hand_car
- (AFHTTPRequestOperation *)imageUpload:(UIImage *)image
                              imageType:(NSString *)type
                             completion:(WebAPIRequestCompletionBlock)completionBlock;
@end
