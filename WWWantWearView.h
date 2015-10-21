//
//  WWWantWearView.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWantWearView : UIView

// 购买会员
@property (nonatomic,copy)void (^wantWearBtnClickBlock)();
// 删除商品
@property (nonatomic,copy)void (^collectionCellDelegateBlock)(NSString *);
// 点击详情
@property (nonatomic,copy)void (^collectionDidSelectItemBlock)(NSString *);
// 立即拥有
@property (nonatomic,copy)void (^settlementBtnClickBlock)();

- (id)initWithFrame:(CGRect)frame;

@end
