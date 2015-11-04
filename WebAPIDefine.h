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

//getProductDetial
#define KProductDetial              @"yiyouv/clothes/info"
//反馈信息
#define KFeedBackURL                @"yiyouv/user/saveSuggestion"

//userInformation
#define KUserInformationURL         @"yiyouv/user/info?id=%@"

//动态密码
#define KDynamicPasswordURL         @"yiyouv/user/validateMobile?mobile=%@"

//登陆
#define KLoginURL                   @"yiyouv/user/login"

//修改用户资料
#define KModifyUserInformationURL   @"yiyouv/user/update"

//我的收藏
#define KMyCollectionURL            @"yiyouv/clothes/favoriters?index=%@&userId=%@"

//收藏商品
#define KAddToCollectionURL         @"yiyouv/clothes/favoriter"
//获取VIP价格表
#define KVIPPriceListURL            @"yiyouv/vip/getVIPPackage"

//购买VIP
#define KBuyVipURL                  @"yiyouv/vip/buy"

//获得商品图文
#define KproductPictureDetial       @"yiyouv/clothes/details?id=%@"

//获得商品参数
#define KproductParameters          @"yiyouv/clothes/parameter"

//获得商品评论列表
#define KproductReplyList           @"yiyouv/reply/list"

//获取衣柜中的商品
#define KWardrobeGoodsURL           @"yiyouv/wardrobe/now?userId=%@"

//获取衣柜中真在租赁的商品
#define KWardrobeIsGoodsURL         @"yiyouv/wardrobe/leaseing?userId=%@"

//删除商品
#define KDelegateWardRodeGoodsURL   @"yiyouv/wardrobe/del?userId=%@&code=%@"

//新增评论
#define KproductAddReply            @"yiyouv/reply/save"

//获取收货地址列表
#define KAddRessListURL             @"yiyouv/address/search?userId=%@"

//添加到衣柜
#define KaddToCart                  @"yiyouv/wardrobe/save"

//获得消息列表
#define KMsgListURL                 @"yiyouv/message/messages"

//获得用户第一条消息
#define KFirstMsgUrl                @"/yiyouv/message/first"
//保存用户收获地址
#define KSaveUserAddressURL         @"yiyouv/address/save"

//删除用户收获地址
#define KdeleteUserAddressURL       @"yiyouv/address/del?id=%@"

//保存用户个推所需参数
#define KGetuiClientIdURL           @"yiyouv/user/saveClientid?userId=%@&clientid=%@&origin=ios"

//生成订单
#define KOrderSaveURL               @"yiyouv/order/save"

//获取订单列表
#define KOrderListURL               @"yiyouv/order/orders?userId=%@&type=%@"

//支付成功
#define KOrderPayURL                @"yiyouv/order/info?id=%@"

//获取订单详情
#define KOrderDetilURL              @"yiyouv/order/info?id=%@"

#endif
