//
//  WWClothesUseTableViewCell.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClothesUseTableViewCell.h"

@interface WWClothesUseTableViewCell ()

@property (nonatomic,strong)UIView                  *backView;
@property (nonatomic,strong)UILabel                 *clothesType;
@property (nonatomic,strong)UILabel                 *clothesMoney;
@property (nonatomic,strong)UILabel                 *clothesEndTime;
@property (nonatomic,strong)UIImageView             *rentImage;
@property (nonatomic,strong)UIImageView             *allImage;

@end

@implementation WWClothesUseTableViewCell

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
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, MainView_Width, 90*kPercenX)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        
        UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
        upLine.backgroundColor = WWPageLineColor;
        [self.backView addSubview:upLine];
        UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backView.height-0.5f, MainView_Width, 0.5f)];
        downLine.backgroundColor = WWPageLineColor;
        [self.backView addSubview:downLine];
        
        self.clothesType = [[UILabel alloc]init];
        self.clothesType.textAlignment = NSTextAlignmentRight;
        self.clothesType.textColor = WWContentTextColor;
        self.clothesType.font = font_size(12);
        [self.backView addSubview:self.clothesType];
        
        self.clothesMoney = [[UILabel alloc]init];
        self.clothesMoney.textColor = WWContentTextColor;
        self.clothesMoney.font = font_size(12);
        [self.backView addSubview:self.clothesMoney];
        
        self.clothesEndTime = [[UILabel alloc]init];
        self.clothesEndTime.textAlignment = NSTextAlignmentRight;
        self.clothesEndTime.textColor = WWContentTextColor;
        self.clothesEndTime.font = font_size(12);
        [self.backView addSubview:self.clothesEndTime];
        
        self.rentImage = [[UIImageView alloc]init];
        [self.backView addSubview:self.rentImage];
        
        self.allImage = [[UIImageView alloc]initWithFrame:CGRectMake(36*kPercenX*4+22, 10, iphone_size_scale(36), iphone_size_scale(36))];
        self.allImage.image = [UIImage imageNamed:@"more"];
        [self.backView addSubview:self.allImage];
        self.allImage.hidden = YES;
    }
    return self;
}

- (void)initRequestClothesDetailData:(WWClothesUseModel *)dicInfor{
    
    NSInteger maxHeight = 6;
    for (int i = 0; i<dicInfor.clothes_IagesArray.count; i++) {
        if (i <= 3) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(maxHeight+4, 10, 36*kPercenX, 36*kPercenX)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dicInfor.clothes_IagesArray[i]] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
            [self.backView addSubview:imageView];
            maxHeight = CGRectGetMaxX(imageView.frame);
        }
    }
    if (dicInfor.clothes_IagesArray.count >=4) {
        self.allImage.hidden = NO;
    }else{
        self.allImage.hidden = YES;
    }
    
    self.clothesType.text = [NSString stringWithFormat:@"%@类%@件商品",dicInfor.clothes_types,dicInfor.clothes_count];
    self.clothesMoney.text = [NSString stringWithFormat:@"实付款：￥%@",dicInfor.clothes_deposit];
    
    self.clothesEndTime.text = [NSString stringWithFormat:@"还衣时间：%@",dicInfor.clothes_endTime];
    
    if ([dicInfor.clothes_state isEqualToString:@"0"]) {
        self.rentImage.image = [UIImage imageNamed:@"icon_ygh"];        // 已归还
    }else if ([dicInfor.clothes_state isEqualToString:@"9"]){
        self.rentImage.image = [UIImage imageNamed:@"img_wfk"];         // 未付款
    }else if ([dicInfor.clothes_state isEqualToString:@"2"]){
        self.rentImage.image = [UIImage imageNamed:@"img_yzl"];        // 已租赁
    }else if ([dicInfor.clothes_state isEqualToString:@"3"]){
        self.rentImage.image = [UIImage imageNamed:@"img_psz"];        // 配送中
    }
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    // 分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+36*kPercenX, self.backView.width-20, 0.5f)];
    line.backgroundColor = WWPageLineColor;
    [self.backView addSubview:line];
    // 商品种类
    CGSize typeSize = CGSizeMake(300, 20000.0f);
    typeSize = [self.clothesType.text sizeWithFont:self.clothesType.font constrainedToSize:typeSize lineBreakMode:NSLineBreakByCharWrapping];
    self.clothesType.frame = CGRectMake(self.backView.width-typeSize.width-10, 21, typeSize.width, typeSize.height);
    // 商品价格
    CGSize moneySize = CGSizeMake(300, 20000.0f);
    moneySize = [self.clothesMoney.text sizeWithFont:self.clothesMoney.font constrainedToSize:moneySize lineBreakMode:NSLineBreakByCharWrapping];
    self.clothesMoney.frame = CGRectMake(10, line.bottom+10, moneySize.width, moneySize.height);
    // 还衣时间
    CGSize timeSize = CGSizeMake(300, 20000.0f);
    timeSize = [self.clothesEndTime.text sizeWithFont:self.clothesEndTime.font constrainedToSize:timeSize lineBreakMode:NSLineBreakByCharWrapping];
    self.clothesEndTime.frame = CGRectMake(self.backView.width-timeSize.width-10, line.bottom+10, timeSize.width, timeSize.height);
    
    self.rentImage.frame = CGRectMake(self.backView.width-58*kPercenX-41, 14, 58*kPercenX, 58*kPercenX);
    
}

@end
