//
//  WWAddRessModel.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWAddRessModel.h"

@implementation WWAddRessModel

+(id)initWithUserAddRessModel:(NSDictionary *)dicInfor{
    WWAddRessModel *model = [[WWAddRessModel alloc]init];
    if (dicInfor == nil) {
        return model;
    }
    [model setCityStr:StringForKeyInUnserializedJSONDic(dicInfor, @"city")];
    [model setContent:StringForKeyInUnserializedJSONDic(dicInfor, @"content")];
    [model setAddressId:StringForKeyInUnserializedJSONDic(dicInfor, @"id")];
    [model setMobile:StringForKeyInUnserializedJSONDic(dicInfor, @"mobile")];
    [model setUserId:StringForKeyInUnserializedJSONDic(dicInfor, @"userId")];
    [model setUserName:StringForKeyInUnserializedJSONDic(dicInfor, @"userName")];
    
    return model;
}

@end
