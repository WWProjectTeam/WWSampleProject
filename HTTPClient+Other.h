//
//  HTTPClient+Other.h
//  HospitalBed
//
//  Created by push on 15/9/6.
//  Copyright (c) 2015年 Suwang. All rights reserved.
//

#import "HTTPClient.h"

@interface HTTPClient (Other)

/*---------------衣优V-------------------*/

/// 首页列表
- (AFHTTPRequestOperation *)postClothesListType:(NSInteger)type index:(NSInteger)index WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;


//HP-getUserUnReadMsg
- (AFHTTPRequestOperation *)UserUnreadMsgNumWithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//HP-getProductType
- (AFHTTPRequestOperation *)ProductTypeWithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-getProductDetial
- (AFHTTPRequestOperation *)ProductDetailPriductId:(NSString *)productId WithComletion:(WebAPIRequestCompletionBlock)completionBlock;
//postFeedback
- (AFHTTPRequestOperation *)PostFeedBackToServerContent:(NSString *)feedContent WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//getUserInformation
- (AFHTTPRequestOperation *)GetUserInformationUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//getDynamicPassword
- (AFHTTPRequestOperation *)GetDynamicPasswordAndPhone:(NSString *)phoneStr WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//login
- (AFHTTPRequestOperation *)PostRequsetLoginNeedPhone:(NSString *)phoneStr AndPassword:(NSString *)password WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//modityUserInformation
- (AFHTTPRequestOperation *)PostRequestModityUserInformationParmae:(NSDictionary *)parmae WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//userCollection
- (AFHTTPRequestOperation *)GetUserCollectionIndex:(NSInteger)index userId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-AddToCollection
- (AFHTTPRequestOperation *)AddToCollection:(NSString *)productId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

@end
