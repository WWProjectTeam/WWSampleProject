//
//  WWMessageListTableViewCell.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMessageListTableViewCell.h"

@implementation WWMessageListTableViewCell
@synthesize imgUserPic = _imgUserPic;
@synthesize labelContent = _labelContent;
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
        [self setBackgroundColor:RGBCOLOR(242, 242, 242)];
        
        UIImageView * imgView = [[UIImageView alloc]init];
        [imgView setBackgroundColor:[UIColor whiteColor]];
        imgView.layer.borderColor = WWPageLineColor.CGColor;
        imgView.layer.borderWidth = 1;
        
        [imgView setFrame:CGRectMake(iphone_size_scale(0), 10, MainView_Width, iphone_size_scale(60))];
        
        [self addSubview:imgView];
        
        
        self.imgUserPic = [[UIImageView alloc]init];
        [self.imgUserPic setFrame:CGRectMake(iphone_size_scale(12),iphone_size_scale(10),iphone_size_scale(40), iphone_size_scale(40))];
        self.imgUserPic.layer.cornerRadius = 15;
        self.imgUserPic.layer.masksToBounds = YES;
        [self.imgUserPic setImage:[UIImage imageNamed:@"icon_xttz"]];
        [imgView addSubview:self.imgUserPic];
        
        ////////用户名
        self.labelUserName = [[UILabel alloc]init];
        [self.labelUserName setFrame:CGRectMake(iphone_size_scale(60), iphone_size_scale(10), iphone_size_scale(260), iphone_size_scale(20))];
        [self.labelUserName setFont:font_size(14)];
        [self.labelUserName setTextAlignment:NSTextAlignmentLeft];
        [self.labelUserName setText:@"系统消息"];
        [imgView addSubview:self.labelUserName];
        
        ///////描述内容
        self.labelContent = [[UILabel alloc]init];
        [self.labelContent setFrame:CGRectMake(iphone_size_scale(60), iphone_size_scale(25), iphone_size_scale(250), iphone_size_scale(30))];
        [self.labelContent setFont:font_size(12)];
        [self.labelContent setTextColor:WWSubTitleTextColor];
        [self.labelContent setNumberOfLines:1];
        
        [imgView addSubview:self.labelContent];
        
    }
    return self;
}

@end