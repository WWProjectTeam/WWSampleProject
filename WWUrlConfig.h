//
//  WWUrlConfig.h
//  WWSampleProject
//
//  Created by ww on 15/9/9.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#ifndef WWSampleProject_WWUrlConfig_h
#define WWSampleProject_WWUrlConfig_h

//host
#define URL_MAIN_HOST @"http://apitest.aishou.com:8080/"


// 保存本地key
#define UserID          @"id"
#define UserImageURL    @"userImageURL"
#define UserName        @"userName"
#define UserPhone       @"userPhone"
#define UserVipID       @"userVip"
#define UserVipEndTime  @"UserVipEndTime"


#pragma mark ---- 支付宝参数
#define alipay_partner  @"2088801915702210"     //合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。请参考“7.1 如何获得PID与 密钥”
#define alipay_seller   @"chpcao@hotmail.com";     //支付宝收款账号,手机号码或邮箱格式

#define alipay_privateKey   @"MIICdAIBADANBgkqhkiG9w0BAQEFAASCAl4wggJaAgEAAoGBALfe7+2veQgxPv+7vabsO0YExf9/evg9F3pr5rNZfZEAHt9xNe7TsVcWqq4lVv0ydjI23FzvBk4yvpg6e809sR3JQvSx1UVmdT9lT6SyttYtCL6EcHQlyh5VbHtzeLF1U06OpKOS4KXB8LdgKjMAGnhuJdPgci4O1HxWppcRiYBVAgMBAAECgYBtsvh6WkJffOIVOTFBMZd7gsWOVcRL7kbfpxiQ0Ed2BxhkPurqfipDxyY1l9l6XmzeMJTwbTrZ1LSZperO3IuaMjmR4xaFlJTsdP6TLnl8Fjf0pOfnVfVnRVLQ07Y6UZCrzytfLx1/ioEiB13jfpaqr59olTfLx+Rr8IeNmrk70QJBAOkN23VrfEXRvZ3/cmLmLSljb0cn9OIHpM8Qh/t94ZW8c19nNcplvpVKUpNAe6l1Vbd63Gqx1GwcUwxVvoPK/3cCQQDJ+WmbRJ5keopHC2whe18IEkpcz7yj3pFW1pTN3EnJJtXynf/Zu/38OLxfwbTY7CcLxOs5uR2Ih18uet2el2mTAj9iUXZEExRaYCGehiW7k196Fnjbi//DW3Yr5M15S6HfiaEinmgS+tlsIe60MH/6/YUr4qkaWetDsK9YhNPaxckCQH4NoXF8Q/al3AM3B8dlvgvFjo+aPztuvvqZdcl9QLe/+ysunO2BPKTbrAV/WaVAzaW0wrIF7H63LhpOKF7AVO0CQCiLXsWCJ8zBh7DGGwF5cvYiMv0VhJG1rsqMpMVKAOg6dWno0gUXFOvwVJYysrwlwaBTYYS0hOlXwCKaIP3uIrk=";     //商户方的私钥,pkcs8 格式。



#pragma mark ------------------------------- NotificationName

// 刷新个人信息
#define WWRefreshUserInformation                @"refreshUserInformation"
// 衣柜删除刷新信息
#define WWDelegateWantWearGoods                 @"DelegateWantWearGoods"
// 保存收货地址
#define WWSaveUserAddress                       @"SaveUserAddress"
// 刷新铃铛红点
#define WWRefreshInformationNum                 @"refreshInfromation"

#endif
