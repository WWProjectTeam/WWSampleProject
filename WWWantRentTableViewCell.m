//
//  WWWantRentTableViewCell.m
//  WWSampleProject
//
//  Created by push on 15/11/2.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWWantRentTableViewCell.h"

@interface WWWantRentTableViewCell ()

@property (nonatomic,strong)UIView              *backView;
@property (nonatomic,strong)UIImageView         *clothesImageView;
@property (nonatomic,strong)UILabel             *clothesName;
@property (nonatomic,strong)UILabel             *clothesDetail;
@property (nonatomic,strong)UILabel             *clothesPrice;
@property (nonatomic,strong)UILabel             *clothesNum;

@end

@implementation WWWantRentTableViewCell

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
        // 背景view
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 70*kPercenX)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
//        UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
//        topLine.backgroundColor = WWPageLineColor;
//        [self.backView addSubview:topLine];
        UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.backView.height-0.5f, MainView_Width, 0.5f)];
        bottomLine.backgroundColor = WWPageLineColor;
        [self.backView addSubview:bottomLine];
        // 图片
        self.clothesImageView = [[UIImageView alloc]init];
        [self.backView addSubview:self.clothesImageView];
        // 名称
        self.clothesName = [[UILabel alloc]init];
        self.clothesName.textColor = RGBCOLOR(20, 20, 20);
        self.clothesName.font = font_size(12);
        [self.backView addSubview:self.clothesName];
        // 详情
        self.clothesDetail = [[UILabel alloc]init];
        self.clothesDetail.textColor = WWSubTitleTextColor;
        self.clothesDetail.font = font_size(12);
        [self.backView addSubview:self.clothesDetail];
        // 价格
        self.clothesPrice = [[UILabel alloc]init];
        self.clothesPrice.textColor = RGBCOLOR(224, 162, 28);
        self.clothesPrice.font = font_size(12);
        [self.backView addSubview:self.clothesPrice];
        // 件数
        self.clothesNum = [[UILabel alloc]init];
        self.clothesNum.textAlignment = NSTextAlignmentRight;
        self.clothesNum.textColor = RGBCOLOR(102, 102, 102);
        self.clothesNum.font = font_size(12);
        [self.backView addSubview:self.clothesNum];
    }
    return self;
}

- (void)wantRentClothesReqeuestData:(WWWantRantModel *)model{
    
    [self.clothesImageView sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"默认衣服图片"]];
    self.clothesName.text = [NSString stringWithFormat:@"%@",model.title];
    self.clothesDetail.text = [NSString stringWithFormat:@"颜色：%@  尺码：%@",model.color,model.size];
    self.clothesPrice.text = [NSString stringWithFormat:@"￥%@.00",model.leaseCost];
    self.clothesNum.text = [NSString stringWithFormat:@"x%@件",model.count];
    
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    self.backView.frame = CGRectMake(0, 0, MainView_Width, 70*kPercenX);
    self.clothesImageView.frame = CGRectMake(10, (self.backView.height-50*kPercenX)/2, 50*kPercenX, 50*kPercenX);
    self.clothesName.frame = CGRectMake(self.clothesImageView.right+10, self.clothesImageView.top, self.backView.width-75*kPercenX, iphone_size_scale(12));
    self.clothesDetail.frame = CGRectMake(self.clothesImageView.right+10, self.clothesName.bottom+7, self.clothesName.width, iphone_size_scale(12));
    self.clothesPrice.frame = CGRectMake(self.clothesImageView.right+10, self.clothesDetail.bottom+7, 200, iphone_size_scale(12));
    
    self.clothesNum.frame = CGRectMake(self.backView.width-210, self.clothesDetail.bottom+7, 200, iphone_size_scale(12));
}

@end
