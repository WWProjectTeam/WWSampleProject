//
//  WWAddRessTableViewCell.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWAddRessTableViewCell.h"



@interface WWAddRessTableViewCell ()


@property (nonatomic,strong)UILabel         *userName;
@property (nonatomic,strong)UILabel         *userPhone;
@property (nonatomic,strong)UILabel         *userAddRess;

@end

@implementation WWAddRessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 76*kPercenX)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 1)];
        upLine.backgroundColor = WWPageLineColor;
        [self.backView addSubview:upLine];
//        UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backView.height-1, MainView_Width, 1)];
//        downLine.backgroundColor = WWPageLineColor;
//        [self.backView addSubview:downLine];
        
        // 用户名称
        self.userName = [[UILabel alloc]init];
        self.userName.textColor = RGBCOLOR(20, 20, 20);
        self.userName.font = font_size(14);
        [self.backView addSubview:self.userName];
        
        // 用户手机
        self.userPhone = [[UILabel alloc]init];
        self.userPhone.font = font_size(13);
        self.userPhone.textColor = [UIColor blackColor];
        [self.backView addSubview:self.userPhone];
        
        // 用户收货地址
        self.userAddRess = [[UILabel alloc]init];
        self.userAddRess.font = font_size(12);
        self.userAddRess.textColor = WWContentTextColor;
        self.userAddRess.numberOfLines = 2;
        [self.backView addSubview:self.userAddRess];
    }
    return self;
}

- (void)initRequestAddRessData:(WWAddRessModel *)dicInfor{
    self.userName.text = [NSString stringWithFormat:@"收货人：%@",dicInfor.userName];
    self.userPhone.text = dicInfor.mobile;
    self.userAddRess.text = [NSString stringWithFormat:@"收货地址：%@%@",dicInfor.cityStr,dicInfor.content];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    self.backView.frame = CGRectMake(0, 0, MainView_Width, 76*kPercenX);
    CGSize navSize = CGSizeMake(300, 20000.0f);
    navSize = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
    self.userName.frame = CGRectMake(10, 10, navSize.width, navSize.height);
    CGSize navSizePhone = CGSizeMake(300, 20000.0f);
    navSizePhone = [self.userPhone.text sizeWithFont:self.userPhone.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
    self.userPhone.frame = CGRectMake(self.backView.width-navSizePhone.width-64, 10, navSizePhone.width, navSizePhone.height);
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.userAddRess.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.userAddRess.text length])];
    [self.userAddRess setAttributedText:attributedString1];
    [self.userAddRess sizeToFit];
    self.userAddRess.frame =CGRectMake(10, self.userName.bottom+5, 250, 40);
    
}

@end
