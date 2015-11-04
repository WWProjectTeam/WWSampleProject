//
//  HomePageProductCollectionViewCell.m
//  WWSampleProject
//
//  Created by ww on 15/10/13.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "HomePageProductCollectionViewCell.h"

@implementation HomePageProductCollectionViewCell
@synthesize imgProduct = _imgProduct;
@synthesize labelProductAssist =_labelProductAssist;
@synthesize labelProductName = _labelProductName;
@synthesize labelProductPrice = _labelProductPrice;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ////////产品图片
        self.imgProduct = [[UIImageView alloc]init];
        [self.imgProduct setFrame:CGRectMake(3, 10,self.frame.size.width-7, iphone_size_scale(225))];
       // [self.imgProduct setContentMode:UIViewAutoresizingFlexibleWidth];
        [self.imgProduct setContentMode:UIViewContentModeScaleAspectFill];
        self.imgProduct.clipsToBounds = YES;
        [self addSubview:self.imgProduct];
    
        
        
        //////遮罩View
        UIView * viewt = [[UIView alloc]initWithFrame:CGRectMake(3, CGRectGetMaxY(self.imgProduct.frame),self.frame.size.width-7, iphone_size_scale(45))];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        [viewt setUserInteractionEnabled:YES];
        [self addSubview:viewt];
        
        
        
        //////产品名称
        self.labelProductName = [[UILabel alloc]init];
        [self.labelProductName setFrame:CGRectMake(5, 1, CGRectGetWidth(viewt.frame)-10, 30)];
        [self.labelProductName setFont:font_size(11)];
        [self.labelProductName setTextColor:RGBCOLOR(128, 128, 128)];

        [viewt addSubview:self.labelProductName];
        
        
        ////////赞-图标
        UIImageView * imgFav = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, iphone_size_scale(13), iphone_size_scale(13))];
        [imgFav setImage:[UIImage imageNamed:@"首页收藏"]];
        [viewt addSubview:imgFav];
        
        
        ///////赞-数量
        self.labelProductAssist = [[UILabel alloc]init];
        [self.labelProductAssist setFrame:CGRectMake(CGRectGetMaxX(imgFav.frame)+3, 30, iphone_size_scale(100), iphone_size_scale(13))];
        [self.labelProductAssist setFont:font_size(13)];
        [self.labelProductAssist setTextColor:RGBCOLOR(128, 128, 128)];
        
        [viewt addSubview:self.labelProductAssist];
        
        
    }
    return self;
}
@end
