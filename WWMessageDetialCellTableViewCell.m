//
//  WWMessageDetialCellTableViewCell.m
//  WWSampleProject
//
//  Created by ww on 15/10/22.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWMessageDetialCellTableViewCell.h"

@implementation WWMessageDetialCellTableViewCell
@synthesize imgUserPic = _imgUserPic;
@synthesize labelContent = _labelContent;
@synthesize labelTime = _labelTime;
@synthesize backImg = _backImg;

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
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code
        
        /*------------------聊天时间------------------------*/
        UIImageView * imgTemp = [[UIImageView alloc]init];
        [imgTemp setBackgroundColor:RGBCOLOR(169, 169, 169)];
        imgTemp.layer.cornerRadius = 3;
        imgTemp.layer.masksToBounds = YES;
        [imgTemp setFrame:CGRectMake(iphone_size_scale(106), 10, iphone_size_scale(106), 20)];
        
        [self addSubview:imgTemp];
        
        self.labelTime = [[UILabel alloc]init];
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        [self.labelTime setFont:font];
        [self.labelTime setTextColor:[UIColor whiteColor]];
        [self.labelTime setBackgroundColor:[UIColor clearColor]];
        [self.labelTime setFrame:CGRectMake(iphone_size_scale(6), 0, iphone_size_scale(94), 20)];
        [self.labelTime setTextAlignment:NSTextAlignmentCenter];
        [imgTemp addSubview:self.labelTime];
        
        /*------------------头像------------------------*/
        self.imgUserPic = [[UIImageView alloc]init];
        [self.imgUserPic setFrame:CGRectMake(iphone_size_scale(10),iphone_size_scale(45),iphone_size_scale(40), iphone_size_scale(40))];
        self.imgUserPic.layer.cornerRadius = 15;
        self.imgUserPic.layer.masksToBounds = YES;
        [self.imgUserPic setImage:[UIImage imageNamed:@"icon_xttz"]];
        [self addSubview:self.imgUserPic];
        
        /*------------------背景图------------------------*/
        self.backImg = [[UIImageView alloc]init];
        
        [self addSubview:self.backImg];
        
        /*------------------聊天文本(图文混排)------------------------*/
        
        self.labelContent = [[KZLinkLabel alloc] initWithFrame:CGRectMake(iphone_size_scale(60), iphone_size_scale(45), iphone_size_scale(240),1000)];
        
        [self.labelContent setBackgroundColor:[UIColor clearColor]];
        self.labelContent.backgroundColor = [UIColor clearColor];
        [self.labelContent setTextColor:WWContentTextColor];
        self.labelContent.automaticLinkDetectionEnabled = YES;
        self.labelContent.linkColor = [UIColor blueColor];
        self.labelContent.linkHighlightColor = [UIColor orangeColor];
        [self addSubview:self.labelContent];
        
    }
    return self;
}


- (UIView *)bubbleView:(NSString *)text{
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popChat"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    
    
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 10000.0f) lineBreakMode:NSLineBreakByCharWrapping];
    
    
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 14.0f, size.width+10, size.height+10)];
    
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    //bubbleText.lineBreakMode = UILineBreakModeWordWrap;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 200.0f, size.height+30.0f);
    returnView.frame = CGRectMake(0.0f, 0.0f, 200.0f, size.height+50.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

@end
