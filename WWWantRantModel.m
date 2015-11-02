//
//  WWWantRantModel.m
//  WWSampleProject
//
//  Created by push on 15/11/2.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWWantRantModel.h"

@implementation WWWantRantModel

+(id)initWithClothesRequestData:(NSDictionary *)dicInfor{
    WWWantRantModel *model = [[WWWantRantModel alloc]init];
    if (dicInfor == nil) {
        return model;
    }
    
    [model setCode:StringForKeyInUnserializedJSONDic(dicInfor, @"code")];
    [model setColor:StringForKeyInUnserializedJSONDic(dicInfor, @"color")];
    [model setCount:StringForKeyInUnserializedJSONDic(dicInfor, @"count")];
    [model setDays:StringForKeyInUnserializedJSONDic(dicInfor, @"deposit")];
    [model setId_s:StringForKeyInUnserializedJSONDic(dicInfor, @"id")];
    [model setImageurl:StringForKeyInUnserializedJSONDic(dicInfor, @"imgurl")];
    [model setLeaseCost:StringForKeyInUnserializedJSONDic(dicInfor, @"leaseCost")];
    [model setSize:StringForKeyInUnserializedJSONDic(dicInfor, @"size")];
    [model setTitle:StringForKeyInUnserializedJSONDic(dicInfor, @"title")];
    
    return model;
}

@end
