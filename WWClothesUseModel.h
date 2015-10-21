//
//  WWClothesUseModel.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWClothesUseModel : NSObject

@property (nonatomic,strong)NSString        *clothes_id;
@property (nonatomic,strong)NSString        *clothes_image;
@property (nonatomic,strong)NSString        *clothes_color;
@property (nonatomic,strong)NSString        *clothes_size;
@property (nonatomic,strong)NSString        *clothes_code;
@property (nonatomic,strong)NSString        *clothes_title;


+(id)initWithClothesModel:(NSDictionary *)dicInfor;

@end
