//
//  HTTPClient+Other.m
//  HospitalBed
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#import "HTTPClient+Other.h"

@implementation HTTPClient (Other)

/*---------------衣优V-------------------*/

/// 首页列表
- (AFHTTPRequestOperation *)postClothesListType:(NSInteger)type index:(NSInteger)index WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary *paramDic = @{@"index":[NSNumber numberWithInteger:index],
                               @"type":[NSNumber numberWithInteger:type]};
    
    NSDictionary *param = @{@"json" : [paramDic JSONString] };
    ///POST请求
    return [self postPath:KClothesListURL
               parameters:param
               completion:completionBlock];
    
    
}

//HP-getUserUnReadMsg
- (AFHTTPRequestOperation *)UserUnreadMsgNumWithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary * dicParam = @{@"userId":g_UserId};
    
    return [self getPath:KUnreadMsgNumURL parameters:dicParam completion:completionBlock];
}

//HP-getProductType
- (AFHTTPRequestOperation *)ProductTypeWithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    return [self getPath:KProductType parameters:nil completion:completionBlock];
}

//PD-getProductDetial
- (AFHTTPRequestOperation *)ProductDetailPriductId:(NSString *)productId WithComletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary * dicParam;
    if (g_UserId) {
        dicParam = @{
                     @"userId":g_UserId,
                     @"id":productId
                     };
    }
    else
    {
        dicParam = @{
                     @"userId":@"0",
                     @"id":productId
                     };

    }
    
    return [self getPath:KProductDetial parameters:dicParam completion:completionBlock];
}

//postFeedback
- (AFHTTPRequestOperation *)PostFeedBackToServerContent:(NSString *)feedContent WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary *feedDic = @{@"content":feedContent};
    
    NSDictionary *param = @{@"json" : [feedDic JSONString]};
    
    return [self postPath:KFeedBackURL
               parameters:param
               completion:completionBlock];
}

//getUserInformation
- (AFHTTPRequestOperation *)GetUserInformationUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:KUserInformationURL,userId];
    return [self getPath:url
              parameters:nil
              completion:completionBlock];
}

//getDynamicPassword
- (AFHTTPRequestOperation *)GetDynamicPasswordAndPhone:(NSString *)phoneStr WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *passwordUrl = [NSString stringWithFormat:KDynamicPasswordURL,phoneStr];
    return [self getPath:passwordUrl
              parameters:nil
              completion:completionBlock];
}

//login
- (AFHTTPRequestOperation *)PostRequsetLoginNeedPhone:(NSString *)phoneStr AndPassword:(NSString *)password WithCompletion:(WebAPIRequestCompletionBlock)completionBlock
{
    NSDictionary *LoginDic = @{@"mobile":phoneStr,
                               @"code":[password JSONString]};
    NSDictionary *parame = @{@"json" : LoginDic};
    return [self postPath:KLoginURL
               parameters:parame
               completion:completionBlock];
}

//modityUserInformation
- (AFHTTPRequestOperation *)PostRequestModityUserInformationParmae:(NSDictionary *)parmae WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary *parameDic = @{@"json" : [parmae JSONString]};
    
    return [self postPath:KModifyUserInformationURL
               parameters:parameDic
               completion:completionBlock];
}


@end
