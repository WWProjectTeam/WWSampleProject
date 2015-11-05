//
//  WWClothesUseModel.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWClothesUseModel : NSObject

@property (nonatomic,strong)NSString        *clothes_count;
@property (nonatomic,strong)NSString        *clothes_id;
@property (nonatomic,strong)NSString        *clothes_deposit;
@property (nonatomic,strong)NSString        *clothes_endTime;
@property (nonatomic,strong)NSString        *clothes_ordernumber;
@property (nonatomic,strong)NSString        *clothes_state;
@property (nonatomic,strong)NSString        *clothes_types;
@property (nonatomic,strong)NSString        *clothes_payMethod;

@property (nonatomic , copy) NSArray        *clothes_IagesArray;

+(id)initWithClothesModel:(NSDictionary *)dicInfor;

@end
