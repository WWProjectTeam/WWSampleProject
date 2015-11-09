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
    
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:paramDic options:0 error:nil] encoding:NSUTF8StringEncoding];

    
    NSDictionary *param = @{@"json" : stringJson };
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

//PD-AddToCollection
- (AFHTTPRequestOperation *)AddToCollection:(NSString *)productId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam;
        dicParam = @{
                     @"userId":g_UserId,
                     @"id":productId
                     };
    
    return [self getPath:KAddToCollectionURL parameters:dicParam completion:completionBlock];
}

//postFeedback
- (AFHTTPRequestOperation *)PostFeedBackToServerContent:(NSString *)feedContent WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary *feedDic = @{@"content":feedContent};
    
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:feedDic options:0 error:nil] encoding:NSUTF8StringEncoding];

    NSDictionary *param = @{@"json" : stringJson};
    
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
                               @"code":password};
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:LoginDic options:0 error:nil] encoding:NSUTF8StringEncoding];

    NSDictionary *parame = @{@"json" : stringJson};
    return [self postPath:KLoginURL
               parameters:parame
               completion:completionBlock];
}

//modityUserInformation
- (AFHTTPRequestOperation *)PostRequestModityUserInformationParmae:(NSDictionary *)parmae WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    // 拼接json---上个问题就是在这里一直崩溃
   // NSDictionary *parameDic = @{@"json" : [parmae JSONString]};
    
    return [self postPath:KModifyUserInformationURL
               parameters:parmae
               completion:completionBlock];
}

//userCollection
- (AFHTTPRequestOperation *)GetUserCollectionIndex:(NSInteger)index userId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:KMyCollectionURL,[NSNumber numberWithInteger:index],userId];
    
    return [self getPath:url
              parameters:nil
              completion:completionBlock];
}

//VIP--PriceList
- (AFHTTPRequestOperation *)GetVIPPriceListWithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    return [self getPath:KVIPPriceListURL
              parameters:nil
              completion:completionBlock];
}

//buy_vip
- (AFHTTPRequestOperation *)PostBuyVipUserId:(NSString *)userId andPackageId:(NSString *)packageId andMoney:(NSString *)money andMethod:(NSString *)method WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary *parameDic = @{@"userId":userId,
                                @"packageId":packageId,
                                @"money":money,
                                @"method":method};
    
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:parameDic options:0 error:nil] encoding:NSUTF8StringEncoding];

    NSDictionary *parame = @{@"json":stringJson};
    
    return [self postPath:KBuyVipURL
               parameters:parame
               completion:completionBlock];
}


//PD-getProductictureDetial
- (AFHTTPRequestOperation *)ProductPictureDetial:(NSString *)productId  WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{

    NSDictionary * dicParam;
    dicParam = @{@"id":productId};
    
    return [self getPath:KproductPictureDetial parameters:dicParam completion:completionBlock];
}

//PD-getProductParm
- (AFHTTPRequestOperation *)ProductParameters:(NSString *)productId  WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary * dicParam;
    dicParam = @{
                 @"id":productId
                 };
    
    return [self getPath:KproductParameters parameters:dicParam completion:completionBlock];
}

//PD-getProductReplyList
- (AFHTTPRequestOperation *)ProductReplyList:(NSString *)productId maxId:(NSString *)maxID WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam;
    dicParam = @{
                 @"id":productId,
                 @"maxId":maxID
                 };
    
    return [self getPath:KproductReplyList parameters:dicParam completion:completionBlock];
}

//WardrobeGoods
- (AFHTTPRequestOperation *)GetWardrobeGoodsUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *goodsUrl = [NSString stringWithFormat:KWardrobeGoodsURL,userId];
    
    return [self getPath:goodsUrl
              parameters:nil
              completion:completionBlock];
}

//WardrobeIsGoods
- (AFHTTPRequestOperation *)GetWardrobeIsGoodsUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *isGoodURL = [NSString stringWithFormat:KWardrobeIsGoodsURL,userId];
    
    return [self getPath:isGoodURL
              parameters:nil
              completion:completionBlock];
}

//delegateWardrobeGoods
- (AFHTTPRequestOperation *)GetDelegateWardrobeGoodsUserId:(NSString *)userId andCode:(NSString *)code WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *delegateURL = [NSString stringWithFormat:KDelegateWardRodeGoodsURL,userId,code];
    
    return [self getPath:delegateURL
              parameters:nil
              completion:completionBlock];
}

//PD-addProductReplyList
- (AFHTTPRequestOperation *)AddProductReply:(NSString *)productId content:(NSString *)content WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam;
    dicParam = @{
                 @"id":productId,
                 @"content":content,
                 @"userId":g_UserId
                 };
    
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dicParam options:0 error:nil] encoding:NSUTF8StringEncoding];

    NSDictionary *parame = @{@"json":stringJson};

    return [self postPath:KproductAddReply
               parameters:parame
               completion:completionBlock];
}

//userAddRessList
- (AFHTTPRequestOperation *)GetUserAddRessListUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *addressUrl = [NSString stringWithFormat:KAddRessListURL,userId];
    
    return [self getPath:addressUrl
              parameters:nil
              completion:completionBlock];
}



//PD-addToCartSubmit
- (AFHTTPRequestOperation *)PostAddToCartWithProductId:(NSString *)productId WithColor:(NSString*)color WithSize:(NSString*)size WithNum:(int)num WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam;
    dicParam = @{
                 @"id":StringAppend(productId),
                 @"userId":StringAppend(g_UserId),
                 @"color":StringAppend(color),
                 @"size":StringAppend(size),
                 @"count":[NSString stringWithFormat:@"%d",num]
                 };

    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dicParam options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSDictionary *parame = @{@"json":stringJson};
    
    return [self postPath:KaddToCart
               parameters:parame
               completion:completionBlock];
}



//HP-MSGList
- (AFHTTPRequestOperation *)GetUserMsgList:(NSString *)maxID WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{

    NSDictionary * dicParam;
    dicParam = @{
                 @"userId":g_UserId,
                 @"maxId":maxID
                 };
    
    return [self getPath:KMsgListURL parameters:dicParam completion:completionBlock];
}

//HP-GETFirstMsg
- (AFHTTPRequestOperation *)GetUserFirstMsgWithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam;
    dicParam = @{
                 @"userId":g_UserId
                 };
    
    return [self getPath:KFirstMsgUrl parameters:dicParam completion:completionBlock];
}
//saveUserAddress
- (AFHTTPRequestOperation *)PostSaveUserAddressWithUserId:(NSString *)userId WithName:(NSString*)name WithMobile:(NSString*)mobile WithCity:(NSString *)city WContent:(NSString *)content WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSDictionary * dicParam = @{@"userId":userId,
                                @"name":name,
                                @"mobile":city,
                                @"city":mobile,
                                @"content":content};
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dicParam options:0 error:nil] encoding:NSUTF8StringEncoding];

    
    NSDictionary *parame = @{@"json":stringJson};
    
    return [self postPath:KSaveUserAddressURL
               parameters:parame
               completion:completionBlock];
    
}

//deleteUserAddress
- (AFHTTPRequestOperation *)GEtDeleteUserAddressId:(NSString *)goodId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSString *deleteURL = [NSString stringWithFormat:KdeleteUserAddressURL,goodId];
    
    return [self getPath:deleteURL
              parameters:nil
              completion:completionBlock];
}

//Getui--clickId
- (AFHTTPRequestOperation *)GetGeTuiUserId:(NSString *)userid ClientId:(NSString *)clientId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSString *getuiUrl = [NSString stringWithFormat:KGetuiClientIdURL,userid,clientId];
    
    return [self getPath:getuiUrl
              parameters:nil
              completion:completionBlock];
}

//orderSave
- (AFHTTPRequestOperation *)PostOrderSaveUserId:(NSString *)userId WithwardrobeId:(NSString *)wardrobeId WithaddressId:(NSString *)addressId WithleaseCost:(NSString *)leaseCost WithDeposit:(NSString *)deposit WithPayMethod:(int)payMethod WithisInvoice:(int )isInvoice WithinvoiceTitle:(NSString *)invoiceTitle WithinvoiceType:(int)invoiceType WithDays:(int)days WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSDictionary *dic = @{@"userId":userId,
                          @"wardrobeId":wardrobeId,
                          @"addressId":addressId,
                          @"leaseCost":leaseCost,
                          @"deposit":deposit,
                          @"payMethod":[NSNumber numberWithInt:payMethod],
                          @"isInvoice":[NSNumber numberWithInt:isInvoice],
                          @"invoiceTitle":invoiceTitle,
                          @"invoiceType":[NSNumber numberWithInt:invoiceType],
                          @"days":[NSNumber numberWithInt:days]};
    
    NSString * stringJson = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];

    NSDictionary *paramet = @{@"json":stringJson};
    
    return [self postPath:KOrderSaveURL
               parameters:paramet
               completion:completionBlock];
}

//GetOrderList
- (AFHTTPRequestOperation *)GetuserOrderListUserId:(NSString *)userid orderId:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSString *listUrl = [NSString stringWithFormat:KOrderListURL,userid,orderId];
    
    return [self getPath:listUrl
              parameters:nil
              completion:completionBlock];
    
}

//GetOrderDetail
- (AFHTTPRequestOperation *)GetOrderDetail:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    
    NSString *detailUrl = [NSString stringWithFormat:KOrderDetilURL,orderId];
    
    return [self getPath:detailUrl
              parameters:nil
              completion:completionBlock];
}

//GetOrderPaySuccess
- (AFHTTPRequestOperation *)GetOrderPaySuccess:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *paySuccessUrl = [NSString stringWithFormat:KOrderPayURL,orderId];
    
    return [self getPath:paySuccessUrl
              parameters:nil
              completion:completionBlock];
}

//GetOrderPayfaile
- (AFHTTPRequestOperation *)GetOrderPayFaile:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock{
    NSString *payFaileUrl = [NSString stringWithFormat:KOrderPayDel,orderId];
    
    return [self getPath:payFaileUrl
              parameters:nil
              completion:completionBlock];
}

@end
