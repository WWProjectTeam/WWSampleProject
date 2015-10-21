//
//  WWWantWearCollectionViewCell.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWWantWearCollectionViewCell.h"

@implementation WWWantWearCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //////遮罩View
        UIView * viewt = [[UIView alloc]initWithFrame:CGRectMake(7, 10, 145*kPercenX, 145*kPercenX)];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        viewt.layer.borderColor = WWPageLineColor.CGColor;
        viewt.layer.borderWidth = 0.5f;
        [viewt setUserInteractionEnabled:YES];
        [self addSubview:viewt];
        
        ////////产品图片
        self.clothesImage = [[UIImageView alloc]init];
        [self.clothesImage setFrame:CGRectMake(0, 0, viewt.width, iphone_size_scale(145-22))];
        [self.clothesImage setContentMode:UIViewContentModeScaleAspectFill];
        self.clothesImage.clipsToBounds = YES;
        [viewt addSubview:self.clothesImage];
        
        
        UIView *clothesNameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.clothesImage.bottom, viewt.width, viewt.height-self.clothesImage.height)];
        clothesNameView.backgroundColor = [UIColor blackColor];
        clothesNameView.alpha = 0.5f;
        [viewt addSubview:clothesNameView];
        
        //////产品名称
        self.clothesNameLab = [[UILabel alloc]init];
        [self.clothesNameLab setFrame:CGRectMake(10, 0, CGRectGetWidth(clothesNameView.frame)-20, clothesNameView.height)];
        [self.clothesNameLab setFont:font_size(12)];
        [self.clothesNameLab setTextColor:[UIColor whiteColor]];
        [clothesNameView addSubview:self.clothesNameLab];
        
        // 删除按钮
        self.clothesDelegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clothesDelegateBtn.frame = CGRectMake(viewt.width-30*kPercenX, 0, iphone_size_scale(30), iphone_size_scale(30));
        [self.clothesDelegateBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.clothesDelegateBtn addTarget:self action:@selector(clothesDeletageClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewt addSubview:self.clothesDelegateBtn];
        
    }
    return self;
}

- (void)clothesDeletageClick:(UIButton *)sender{
    if (self.clothesDelegateBlock) {
        self.clothesDelegateBlock();
    }
}

@end
