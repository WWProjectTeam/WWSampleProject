//
//  OSSsendPicture.h
//  AiShou
//
//  Created by eleven on 15/3/12.
//  Copyright (c) 2015年 李 德慧. All rights reserved.
//
#define kBucketKeyFormAS                 @"aishou"
#define kCnameKeyFormCN_HZ               @"oss-cn-hangzhou.aliyuncs.com"
#define kBucketKeyFormIOS_Img            @"iso-img"
#define kCnameKeyFormCN_QD               @"oss-cn-qingdao.aliyuncs.com"


#import <Foundation/Foundation.h>

@interface OSSsendPicture : NSObject
///判断是哪个功能模块
@property (nonatomic, copy)NSString *bucketKey;
@property (nonatomic, copy)NSString *cdnHostKey;
@property (nonatomic, copy)NSString *cnameKey;

+(OSSsendPicture *)sharedInstance;
- (NSString *)OSSsendImageToOSSFormImageData:(UIImage *)upImage
                         imageContentOfRoute:(NSString *)contentHead;
- (BOOL)OSSJudgeImageSizeFormImage:(UIImage*)image;


@end
