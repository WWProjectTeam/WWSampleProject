//
//  WWClothesUseModel.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClothesUseModel.h"

@implementation WWClothesUseModel


+(id)initWithClothesModel:(NSDictionary *)dicInfor{
    WWClothesUseModel *model = [[WWClothesUseModel alloc]init];
    if (dicInfor == nil) {
        return model;
    }
    
    [model setClothes_code:StringForKeyInUnserializedJSONDic(dicInfor, @"code")];
    [model setClothes_color:StringForKeyInUnserializedJSONDic(dicInfor, @"color")];
    [model setClothes_id:StringForKeyInUnserializedJSONDic(dicInfor, @"id")];
    [model setClothes_image:StringForKeyInUnserializedJSONDic(dicInfor, @"imgurl")];
    [model setClothes_size:StringForKeyInUnserializedJSONDic(dicInfor, @"size")];
    [model setClothes_title:StringForKeyInUnserializedJSONDic(dicInfor, @"title")];
    
    return model;
}

@end
