//
//  WWAddToCartPopView.h
//  WWSampleProject
//
//  Created by ww on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWAddToCartPopView : UIView


-(id)initAddToCartPopView;


-(void)showWithProductMsg:(NSDictionary *)dict;


////加入衣柜
@property (nonatomic , copy) void (^AddToCart)(NSString * strColor,NSString * strSize,int strNum);

@end
