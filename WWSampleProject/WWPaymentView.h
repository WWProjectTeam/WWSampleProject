//
//  WWPaymentView.h
//  WWSampleProject
//
//  Created by push on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPaymentView : UIView

@property (nonatomic,strong)void (^payMentViewPaySelectClickBlock)(BOOL);

@property (nonatomic,strong)UIImageView *payArrowImage;
@property (nonatomic,strong)UIView      *payBackView;
@property (nonatomic,strong)UIView      *payDetailView;
@property (nonatomic,strong)UILabel     *paySubLab;        // 详情
@property (nonatomic,strong)UIButton    *openVipBtn;
@property (nonatomic,strong)UIButton    *weChatBtn;
@property (nonatomic,strong)UIButton    *allPayBtn;

@end
