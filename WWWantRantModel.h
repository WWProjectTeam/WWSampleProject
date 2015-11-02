//
//  WWWantRantModel.h
//  WWSampleProject
//
//  Created by push on 15/11/2.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWantRantModel : NSObject

@property (nonatomic,strong)NSString        *code;
@property (nonatomic,strong)NSString        *color;
@property (nonatomic,strong)NSString        *count;
@property (nonatomic,strong)NSString        *days;
@property (nonatomic,strong)NSString        *deposit;
@property (nonatomic,strong)NSString        *id_s;
@property (nonatomic,strong)NSString        *imageurl;
@property (nonatomic,strong)NSString        *leaseCost;
@property (nonatomic,strong)NSString        *size;
@property (nonatomic,strong)NSString        *title;

+(id)initWithClothesRequestData:(NSDictionary *)dicInfor;

@end
