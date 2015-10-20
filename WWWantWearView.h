//
//  WWWantWearView.h
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWantWearView : UIView

@property (nonatomic,copy)void (^wantWearBtnClickBlock)();

- (id)initWithFrame:(CGRect)frame;

@end
