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
    
    [model setClothes_count:StringForKeyInUnserializedJSONDic(dicInfor, @"count")];
    [model setClothes_deposit:StringForKeyInUnserializedJSONDic(dicInfor, @"deposit")];
    [model setClothes_id:StringForKeyInUnserializedJSONDic(dicInfor, @"id")];
    [model setClothes_endTime:StringForKeyInUnserializedJSONDic(dicInfor, @"endTime")];
    [model setClothes_ordernumber:StringForKeyInUnserializedJSONDic(dicInfor, @"orderNumber")];
    [model setClothes_state:StringForKeyInUnserializedJSONDic(dicInfor, @"state")];
    [model setClothes_types:StringForKeyInUnserializedJSONDic(dicInfor, @"types")];
    [model setClothes_payMethod:StringForKeyInUnserializedJSONDic(dicInfor, @"payMethod")];
    
    NSString *imageURLs = StringForKeyInUnserializedJSONDic(dicInfor, @"imgurl");
    ///字符串不为空
    if (!IsStringEmptyOrNull(imageURLs)) {
        
        NSArray *imageData = [imageURLs componentsSeparatedByString:@","];
        
        NSMutableArray* imageArray = [[NSMutableArray alloc] init];
        
        if ([imageData isKindOfClass:[NSArray class]]) {
            for (NSString* imageURL in imageData) {
                
                [imageArray addObject:imageURL];
            }
        }
        [model setClothes_IagesArray:[NSArray arrayWithArray:imageArray]];
    }

    return model;
}

@end
