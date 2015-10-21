//
//  WWClothesUseTableViewCell.m
//  WWSampleProject
//
//  Created by push on 15/10/20.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWClothesUseTableViewCell.h"

@interface WWClothesUseTableViewCell ()

@property (nonatomic,strong)UIImageView             *clothesImage;
@property (nonatomic,strong)UILabel                 *clothesName;
@property (nonatomic,strong)UILabel                 *clothesDetail;

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
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, MainView_Width, 70*kPercenX)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainView_Width, 1)];
        upLine.backgroundColor = WWPageLineColor;
        [backView addSubview:upLine];
        UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, backView.height-1, MainView_Width, 1)];
        downLine.backgroundColor = WWPageLineColor;
        [backView addSubview:downLine];
        
        // 图片
        self.clothesImage = [[UIImageView alloc]init];
        [backView addSubview:self.clothesImage];
        
        // 名称
        self.clothesName = [[UILabel alloc]init];
        self.clothesName.textColor = RGBCOLOR(20, 20, 20);
        self.clothesName.font = font_size(12);
        self.clothesName.numberOfLines = 2;
        [backView addSubview:self.clothesName];
        
        // 详情
        self.clothesDetail = [[UILabel alloc]init];
        self.clothesDetail.textColor = WWSubTitleTextColor;
        self.clothesDetail.font = font_size(12);
        [backView addSubview:self.clothesDetail];
        
    }
    return self;
}

- (void)initRequestClothesDetailData:(WWClothesUseModel *)dicInfor{
    
    [self.clothesImage sd_setImageWithURL:[NSURL URLWithString:dicInfor.clothes_image] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
    self.clothesName.text = dicInfor.clothes_title;
    self.clothesDetail.text = [NSString stringWithFormat:@"颜色：%@ 尺码：%@",dicInfor.clothes_color,dicInfor.clothes_size];
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    self.clothesImage.frame = CGRectMake(10, (20*kPercenX)/2, 50*kPercenX, 50*kPercenX);
    self.clothesName.frame = CGRectMake(self.clothesImage.right+10, 10, 235*kPercenX, 30*kPercenX);
    self.clothesDetail.frame = CGRectMake(self.clothesImage.right+10, self.clothesImage.bottom-12*kPercenX, self.clothesName.width, 12*kPercenX);
    
}


@end
