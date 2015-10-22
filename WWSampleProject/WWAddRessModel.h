//
//  WWAddRessModel.h
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAddRessModel : NSObject

@property (nonatomic,strong)NSString        *cityStr;
@property (nonatomic,strong)NSString        *content;
@property (nonatomic,strong)NSString        *addressId;
@property (nonatomic,strong)NSString        *mobile;
@property (nonatomic,strong)NSString        *userId;
@property (nonatomic,strong)NSString        *userName;

+(id)initWithUserAddRessModel:(NSDictionary *)dicInfor;

@end
