//
//  WebAPIDefine.h
//  AiShou
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#ifndef AiShou_WebAPIDefine_h
#define AiShou_WebAPIDefine_h


////常用参数
#pragma mark - common key
#define kDataKeyPageIndex       @"page"
#define kDataKeyPageSize        @"pagesize"
#define kDataKeyData            @"data"
#define kDataKeyId              @"id"
#define kDataKeyLastId          @"lastid"
#define kDataKeyType            @"type"
#define kDataKeyPageCount       @"totalPage"
#define kDataKeyDataCount       @"count"
#define kDataKeyLongitude       @"longitude"
#define kDataKeyLatitude        @"latitude"
#define KDataKeyAudio           @"audio"
#define KDataKeyAvatar          @"avatar"
#define KDataKeyPublic          @"is_public"
#define KDataKeyCode            @"code"
#define KdataKeyPushParam       @"payload"

#define KDataKeyUserId          @"uid"
#define KDataKeyUserIdAll       @"userId"
#define KDataKeyTaskId          @"taskId"
#define KDataKeyToken           @"token"
#define KDataKeyOrigin          @"origin"
#define KDataKeyOriginValue     @"iphone"

#define KDataKeyWeight          @"weight"

#define KDataKeyResult          @"result"
#define KDataKeySuccess         @"success"
#define KDataKeyNext            @"next"
#define KDataKeyList            @"list"
#define KDataKeyIndex           @"index"

// 错误类型
#define KDataKeyDesc            @"desc"

#define KDataKeyJson            @"json"
#define KDataKeyword            @"keyword"
//#define KDataKeyIndex           @"index"

#define KDataKeyGroupId         @"gid"


//pathAppend
#define URLAppend(a,b)      [NSString stringWithFormat:@"%@%@",a,b]


/**
 
 *
 *首页模块接口内容
 *
 *
 **/

/*--------------衣优V----------------*/

#define KClothesListURL             @"yiyouv/clothes/search"

//getUserUnreadMsg
#define KUnreadMsgNumURL            @"yiyouv/message/userNews"

//getProductType
#define KProductType                @"yiyouv/clothes/types"

//反馈信息
#define KFeedBackURL                @"yiyouv/user/saveSuggestion"

//userInformation
#define KUserInformationURL         @"yiyouv/user/info?id=%@"

#endif
