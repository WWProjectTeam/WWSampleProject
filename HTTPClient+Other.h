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
//VIP--PriceList
- (AFHTTPRequestOperation *)GetVIPPriceListWithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//buy_vip
- (AFHTTPRequestOperation *)PostBuyVipUserId:(NSString *)userId andPackageId:(NSString *)packageId andMoney:(NSString *)money andMethod:(NSString *)method WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-getProductictureDetial
- (AFHTTPRequestOperation *)ProductPictureDetial:(NSString *)productId  WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-getProductParm
- (AFHTTPRequestOperation *)ProductParameters:(NSString *)productId  WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-getProductReplyList
- (AFHTTPRequestOperation *)ProductReplyList:(NSString *)productId maxId:(NSString *)maxID WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//WardrobeGoods
- (AFHTTPRequestOperation *)GetWardrobeGoodsUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//WardrobeIsGoods
- (AFHTTPRequestOperation *)GetWardrobeIsGoodsUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//delegateWardrobeGoods
- (AFHTTPRequestOperation *)GetDelegateWardrobeGoodsUserId:(NSString *)userId andCode:(NSString *)code WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-addProductReplyList
- (AFHTTPRequestOperation *)AddProductReply:(NSString *)productId content:(NSString *)content WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//userAddRessList
- (AFHTTPRequestOperation *)GetUserAddRessListUserId:(NSString *)userId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//PD-addToCartSubmit
- (AFHTTPRequestOperation *)PostAddToCartWithProductId:(NSString *)productId WithColor:(NSString*)color WithSize:(NSString*)size WithNum:(int)num WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//HP-MSGList
- (AFHTTPRequestOperation *)GetUserMsgList:(NSString *)maxID WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;


//HP-GETFirstMsg
- (AFHTTPRequestOperation *)GetUserFirstMsgWithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//saveUserAddress
- (AFHTTPRequestOperation *)PostSaveUserAddressWithUserId:(NSString *)userId WithName:(NSString*)name WithMobile:(NSString*)mobile WithCity:(NSString *)city WContent:(NSString *)content WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//deleteUserAddress
- (AFHTTPRequestOperation *)GEtDeleteUserAddressId:(NSString *)goodId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//Getui--clickId
- (AFHTTPRequestOperation *)GetGeTuiUserId:(NSString *)userid ClientId:(NSString *)clientId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//orderSave
- (AFHTTPRequestOperation *)PostOrderSaveUserId:(NSString *)userId WithwardrobeId:(NSString *)wardrobeId WithaddressId:(NSString *)addressId WithleaseCost:(NSString *)leaseCost WithDeposit:(NSString *)deposit WithPayMethod:(int)payMethod WithisInvoice:(int)isInvoice WithinvoiceTitle:(NSString *)invoiceTitle WithinvoiceType:(int)invoiceType WithDays:(int)days WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//GetOrderList
- (AFHTTPRequestOperation *)GetuserOrderListUserId:(NSString *)userid orderId:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//GetOrderDetail
- (AFHTTPRequestOperation *)GetOrderDetail:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//GetOrderPaySuccess
- (AFHTTPRequestOperation *)GetOrderPaySuccess:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;

//GetOrderPayfaile
- (AFHTTPRequestOperation *)GetOrderPayFaile:(NSString *)orderId WithCompletion:(WebAPIRequestCompletionBlock)completionBlock;
@end

