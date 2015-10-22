//
//  WebAPIResponse.m
//  AiShou
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#import "WebAPIResponse.h"
#import "FMFunctions.h"

//@implementation WebAPIResponse
#define kCodeNameOnServer               @"code"
#define kCodeDescriptionNameOnServer    @"RetValue"


@implementation WebAPIResponse

+ (id)responseWithCode:(WebAPIResponseCode)code
{
    return [[self class] responseWithCode:code description:nil];
}

+ (id)responseWithCode:(WebAPIResponseCode)code description:(NSString *)codeDescription
{
    id response = [[self alloc] init];
    [(WebAPIResponse*)response setCode:code];
    [(WebAPIResponse*)response setCodeDescription:codeDescription];
    return response;
}

//TODO: 拼写错误
+ (id)invalidArgumentsResonse
{
    return [self responseWithCode:WebAPIResponseCodeParamError
                      description:@"请求参数错误"];
}

+ (id)successedResponse
{
    return [self responseWithCode:WebAPIResponseCodeSuccess];
}


+ (id)responseWithUnserializedJSONDic:(id)returnData
{
    WebAPIResponse* response = [[self alloc] init];
    
    if (returnData == nil || ![returnData isKindOfClass:[NSDictionary class]])
    {
        [response setCode:WebAPIResponseCodeFailed];
        [response setCodeDescription:@"服务器返回数据异常"];
    }
    else{
        
        [response setCode:[ObjForKeyInUnserializedJSONDic((NSDictionary* )returnData, kCodeNameOnServer) integerValue]];
        [response setCodeDescription:ObjForKeyInUnserializedJSONDic((NSDictionary* )returnData, kCodeDescriptionNameOnServer)];
        [response setResponseObject:(NSDictionary* )returnData];
    }
    return response;
}
@end
