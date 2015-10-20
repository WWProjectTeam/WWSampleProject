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



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     /////////头像
        self.imgUserPic = [[UIImageView alloc]init];
        [self.imgUserPic setFrame:CGRectMake(iphone_size_scale(10),iphone_size_scale(10),iphone_size_scale(30), iphone_size_scale(30))];
        self.imgUserPic.layer.cornerRadius = 15;
        self.imgUserPic.layer.masksToBounds = YES;
        [self addSubview:self.imgUserPic];
        
     ////////用户名
        self.labelUserName = [[UILabel alloc]init];
        [self.labelUserName setFrame:CGRectMake(iphone_size_scale(50), iphone_size_scale(3), iphone_size_scale(260), iphone_size_scale(30))];
        [self.labelUserName setFont:font_bold_size(14)];
        [self.labelUserName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:self.labelUserName];
        
    ///////描述内容
        self.labelContent = [[UILabel alloc]init];
        [self.labelContent setFrame:CGRectMake(iphone_size_scale(50), iphone_size_scale(30), iphone_size_scale(260), iphone_size_scale(30))];
        [self.labelContent setFont:font_size(14)];
        [self.labelContent setTextColor:WWSubTitleTextColor];
        [self.labelContent setNumberOfLines:0];
        
        [self addSubview:self.labelContent];
    
    //////时间
        self.labelTime = [[UILabel alloc]init];
        [self.labelTime setFrame:CGRectMake(iphone_size_scale(170), iphone_size_scale(3), iphone_size_scale(140), iphone_size_scale(30))];
        [self.labelTime setTextAlignment:NSTextAlignmentLeft];
        [self.labelTime setTextColor:WWSubTitleTextColor];
        [self.labelTime setFont:font_size(12)];
        
        [self addSubview:self.labelTime];
    }
    return self;
}

@end
