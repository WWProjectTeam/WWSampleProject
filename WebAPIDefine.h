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

#define KClothesListURL             @"clothes/search"

//getUserUnreadMsg
#define KUnreadMsgNumURL            @"message/userNews"

//getProductType
#define KProductType                @"clothes/types"

//getProductDetial
#define KProductDetial              @"clothes/info"
//反馈信息
#define KFeedBackURL                @"user/saveSuggestion"

//userInformation
#define KUserInformationURL         @"user/info?id=%@"

//动态密码
#define KDynamicPasswordURL         @"user/validateMobile?mobile=%@"

//登陆
#define KLoginURL                   @"user/login"

//修改用户资料
#define KModifyUserInformationURL   @"user/update"

//我的收藏
#define KMyCollectionURL            @"clothes/favoriters?index=%@&userId=%@"

//收藏商品
#define KAddToCollectionURL         @"clothes/favoriter"
//获取VIP价格表
#define KVIPPriceListURL            @"vip/getVIPPackage"

//购买VIP
#define KBuyVipURL                  @"vip/buy"

//获得商品图文
#define KproductPictureDetial       @"clothes/details?id=%@"

//获得商品参数
#define KproductParameters          @"clothes/parameter?id=%@"

//获得商品评论列表
#define KproductReplyList           @"reply/list"

//获取衣柜中的商品
#define KWardrobeGoodsURL           @"wardrobe/now?userId=%@"

//获取衣柜中真在租赁的商品
#define KWardrobeIsGoodsURL         @"wardrobe/leaseing?userId=%@"

//删除商品
#define KDelegateWardRodeGoodsURL   @"wardrobe/del?userId=%@&code=%@"

//新增评论
#define KproductAddReply            @"reply/save"

//获取收货地址列表
#define KAddRessListURL             @"address/search?userId=%@"

//添加到衣柜
#define KaddToCart                  @"wardrobe/save"

//获得消息列表
#define KMsgListURL                 @"message/messages"

//获得用户第一条消息
#define KFirstMsgUrl                @"message/first"
//保存用户收获地址
#define KSaveUserAddressURL         @"address/save"

//删除用户收获地址
#define KdeleteUserAddressURL       @"address/del?id=%@"

//保存用户个推所需参数
#define KGetuiClientIdURL           @"user/saveClientid?userId=%@&clientid=%@&origin=ios"

//生成订单
#define KOrderSaveURL               @"order/save"

//获取订单列表
#define KOrderListURL               @"order/orders?userId=%@&type=%@"

//支付成功
#define KOrderPayURL                @"order/info?id=%@"

//支付失败
#define KOrderPayDel                @"order/del?id=%@"

//获取订单详情
#define KOrderDetilURL              @"order/info?id=%@"

#endif
