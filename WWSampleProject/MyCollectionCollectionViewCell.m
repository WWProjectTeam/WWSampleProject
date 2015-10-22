//
//  MyCollectionCollectionViewCell.m
//  WWSampleProject
//
//  Created by push on 15/10/16.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "MyCollectionCollectionViewCell.h"

@implementation MyCollectionCollectionViewCell

@synthesize imgProduct = _imgProduct;
@synthesize labelProductName = _labelProductName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ////////产品图片
        self.imgProduct = [[UIImageView alloc]init];
        [self.imgProduct setFrame:CGRectMake(3, 10,self.frame.size.width-7, iphone_size_scale(225))];
        [self.imgProduct setContentMode:UIViewContentModeScaleAspectFill];
        self.imgProduct.clipsToBounds = YES;
        [self addSubview:self.imgProduct];
        
        
        //////遮罩View
        UIView * viewt = [[UIView alloc]initWithFrame:CGRectMake(3, CGRectGetMaxY(self.imgProduct.frame),self.frame.size.width-7, iphone_size_scale(25))];
        [viewt setBackgroundColor:[UIColor whiteColor]];
        [viewt setUserInteractionEnabled:YES];
        [self addSubview:viewt];
        
        //////产品名称
        self.labelProductName = [[UILabel alloc]init];
        [self.labelProductName setFrame:CGRectMake(5, 0, CGRectGetWidth(viewt.frame)-10, 25)];
        [self.labelProductName setFont:font_size(11)];
        [self.labelProductName setTextColor:RGBCOLOR(77, 77, 77)];
        [viewt addSubview:self.labelProductName];
        
    }
    return self;
}



@end
