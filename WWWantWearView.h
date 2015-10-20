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

@property (nonatomic,copy)void (^collectionCellDelegateBlock)();

- (id)initWithFrame:(CGRect)frame;

@end
