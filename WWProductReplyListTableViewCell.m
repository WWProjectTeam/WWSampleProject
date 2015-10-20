//
//  WWProductReplyListTableViewCell.m
//  WWSampleProject
//
//  Created by ww on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWProductReplyListTableViewCell.h"

@implementation WWProductReplyListTableViewCell
@synthesize imgUserPic    = _imgUserPic;
@synthesize labelContent  = _labelContent;
@synthesize labelTime     = _labelTime;
@synthesize labelUserName = _labelUserName;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
     /////////头像
        self.imgUserPic = [[UIImageView alloc]init];
        [self.imgUserPic setFrame:CGRectMake(iphone_size_scale(10),iphone_size_scale(10),iphone_size_scale(30), iphone_size_scale(30))];
        [self addSubview:self.imgUserPic];
        
     ////////用户名
        self.labelUserName = [[UILabel alloc]init];
        [self.labelUserName setFrame:CGRectMake(iphone_size_scale(50), iphone_size_scale(10), iphone_size_scale(260), iphone_size_scale(30))];
        [self.labelUserName setFont:font_bold_size(14)];
        [self.labelUserName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.labelUserName];
        
    ///////描述内容
        self.labelContent = [[UILabel alloc]init];
        [self.labelContent setFrame:CGRectMake(iphone_size_scale(50), iphone_size_scale(40), iphone_size_scale(260), iphone_size_scale(30))];
        [self.labelContent setFont:font_size(15)];
        
        [self addSubview:self.labelContent];
    
    //////时间
        self.labelTime = [[UILabel alloc]init];
        [self.labelTime setFrame:CGRectMake(iphone_size_scale(250), iphone_size_scale(10), iphone_size_scale(50), iphone_size_scale(30))];
        
        [self addSubview:self.labelTime];
    }
    return self;
}

@end
