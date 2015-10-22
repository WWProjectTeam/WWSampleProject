//
//  WWPaymentView.m
//  WWSampleProject
//
//  Created by push on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWPaymentView.h"

@interface WWPaymentView ()

@end

@implementation WWPaymentView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        /**
         *  支付
         */
        self.payBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, 44*kPercenX)];
        self.payBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.payBackView];
        // 方向箭头
        self.payArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.payBackView.width-24*kPercenX, (self.payBackView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
        self.payArrowImage.image = [UIImage imageNamed:@"check--details1"];
        [self.payBackView addSubview:self.payArrowImage];
        // 上下线条
        UILabel *payUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.payBackView.width, 1)];
        payUpLine.backgroundColor = WWPageLineColor;
        [self.payBackView addSubview:payUpLine];
        UILabel *payDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.payBackView.height-1, self.payBackView.width, 1)];
        payDownLine.backgroundColor = WWPageLineColor;
        [self.payBackView addSubview:payDownLine];
        //payLabel
        UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
        payLabel.text = @"支付方式";
        payLabel.textColor = RGBCOLOR(20, 20, 20);
        payLabel.font = font_size(14);
        [self.payBackView addSubview:payLabel];
        //paySubLabel;
        self.paySubLab = [[UILabel alloc]initWithFrame:CGRectMake(self.payArrowImage.left-100, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
        self.paySubLab.textAlignment = NSTextAlignmentRight;
        self.paySubLab.text = @"支付宝";
        self.paySubLab.textColor = RGBCOLOR(128, 128, 128);
        self.paySubLab.font = font_size(14);
        [self.payBackView addSubview:self.paySubLab];
        // 点击事件
        UIButton *payClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        payClickBtn.frame = CGRectMake(0, 0, self.payBackView.width, self.payBackView.height);
        [payClickBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
        [payClickBtn addTarget:self action:@selector(payClickEvnet:) forControlEvents:UIControlEventTouchUpInside];
        [self.payBackView addSubview:payClickBtn];
        
#pragma mark --- 支付选择
        self.payDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.payBackView.bottom, MainView_Width, 60*kPercenX)];
        self.payDetailView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.payDetailView];
        // 微信
        UIView *weChatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, self.payDetailView.height/2)];
        weChatView.backgroundColor = [UIColor whiteColor];
        [self.payDetailView addSubview:weChatView];
        // 图标
        UIImageView *weChaticonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (weChatView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
        weChaticonImage.image = [UIImage imageNamed:@"微信"];
        [weChatView addSubview:weChaticonImage];
        // 文字
        UILabel *weChatLab = [[UILabel alloc]initWithFrame:CGRectMake(weChaticonImage.right+5, (weChatView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
        weChatLab.text = @"微信";
        weChatLab.textColor = WWContentTextColor;
        weChatLab.font = font_size(13);
        [weChatView addSubview:weChatLab];
        // 支付选择按钮
        self.weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.weChatBtn.frame = CGRectMake(weChatView.width-8-14*kPercenX, (weChatView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
        [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
        [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
        [self.weChatBtn addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.weChatBtn.tag = 20000;
        [weChatView addSubview:self.weChatBtn];
        
        // 支付宝
        UIView *allPayView = [[UIView alloc]initWithFrame:CGRectMake(0, weChatView.bottom, MainView_Width, self.payDetailView.height/2)];
        allPayView.backgroundColor = [UIColor whiteColor];
        [self.payDetailView addSubview:allPayView];
        // 图标
        UIImageView *allPayIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (allPayView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
        allPayIconImage.image = [UIImage imageNamed:@"支付宝"];
        [allPayView addSubview:allPayIconImage];
        // 支付宝上下线条
        UILabel *allPayUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, allPayView.width, 1)];
        allPayUpLine.backgroundColor = WWPageLineColor;
        [allPayView addSubview:allPayUpLine];
        UILabel *allPayDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, allPayView.height-1, allPayView.width, 1)];
        allPayDownLine.backgroundColor = WWPageLineColor;
        [allPayView addSubview:allPayDownLine];
        // 文字
        UILabel *allPayLab = [[UILabel alloc]initWithFrame:CGRectMake(allPayIconImage.right+5, (allPayView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
        allPayLab.textAlignment = NSTextAlignmentCenter;
        allPayLab.text = @"支付宝";
        allPayLab.textColor = WWContentTextColor;
        allPayLab.font = font_size(13);
        [allPayView addSubview:allPayLab];
        // 支付选择按钮
        self.allPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.allPayBtn.frame = CGRectMake(allPayView.width-8-14*kPercenX, (allPayView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
        [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
        [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
        self.allPayBtn.selected = YES;
        [self.allPayBtn addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        self.allPayBtn.tag = 20001;
        [allPayView addSubview:self.allPayBtn];
        
        self.payDetailView.hidden = YES;

    }
    return self;
}

- (void)payBtnClickEvent:(UIButton *)sender{
    if (sender.tag == 20000) {      // 微信
        self.allPayBtn.selected = NO;
        self.weChatBtn.selected = YES;
        self.paySubLab.text = @"微信";
    }else if (sender.tag == 20001){     // 支付宝
        self.allPayBtn.selected = YES;
        self.weChatBtn.selected = NO;
        self.paySubLab.text = @"支付宝";
    }
    [self payDetailViewHidden:NO];
}

// 支付触发事件
- (void)payClickEvnet:(UIButton *)sender{
    if (self.payDetailView.hidden == YES) {
        [self payDetailViewHidden:YES];
    }else{
        [self payDetailViewHidden:NO];
    }
}

- (void)payDetailViewHidden:(BOOL)bol{
    [UIView animateWithDuration:0.5 animations:^{
        self.payArrowImage.transform = CGAffineTransformRotate(self.payArrowImage.transform, -M_PI);//旋转180度
    }];
    self.payMentViewPaySelectClickBlock(bol);
    if (bol == YES) {
        self.payDetailView.hidden = NO;
    }else{
        self.payDetailView.hidden = YES;
    }
}


@end
