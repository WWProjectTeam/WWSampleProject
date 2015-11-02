//
//  WWAddToCartPopView.m
//  WWSampleProject
//
//  Created by ww on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWAddToCartPopView.h"
#import "RadioButton.h"

@implementation WWAddToCartPopView{
    UIImageView * imgProduct;
    
    
    UILabel * labelColthSpressNum;
    UILabel *clotheSubSpressNum;
    UILabel * labelDesc;
    UILabel *otherContentLab;
    UILabel *clothesNum;
    
    UIScrollView * scrollView;
    NSDictionary * clothesDetailDic;
    
    int num;
    
    NSString * strResultSize;
    NSString * strResultColor;
}

-(id)initAddToCartPopView{
    self = [super initWithFrame:CGRectMake(0,0,MainView_Width,MainView_Height)];
    
    if (self)
    {
        num = 1;
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        
        UIView * viewBG = [[UIView alloc]init];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [viewBG setFrame:CGRectMake(0, MainView_Height-iphone_size_scale(340), MainView_Width,iphone_size_scale(340))];
        
        [self addSubview:viewBG];
        
        
        imgProduct = [[UIImageView alloc]init];
        [imgProduct setFrame:CGRectMake(10,MainView_Height-iphone_size_scale(360), iphone_size_scale(100), iphone_size_scale(100))];
        
        imgProduct.layer.cornerRadius = 5;
        imgProduct.layer.masksToBounds = YES;
        [imgProduct setContentMode:UIViewContentModeScaleAspectFill];
        imgProduct.clipsToBounds = YES;
        [self addSubview:imgProduct];

        
        labelColthSpressNum = [[UILabel alloc]init];
        [labelColthSpressNum setText:@"￥30/天"];
        [labelColthSpressNum setTextColor:WWContentTextColor];
        [labelColthSpressNum setFrame:CGRectMake(CGRectGetMaxX(imgProduct.frame)+10, iphone_size_scale(23), iphone_size_scale(100), 20*kPercenX)];
        [labelColthSpressNum setFont:font_size(20)];
        
        [viewBG addSubview:labelColthSpressNum];
        
        clotheSubSpressNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgProduct.frame)+10, labelColthSpressNum.bottom+5, 100, iphone_size_scale(11))];
        clotheSubSpressNum.text = @"押金：￥380/件";
        clotheSubSpressNum.textColor = WWContentTextColor;
        clotheSubSpressNum.font = font_size(11);
        [viewBG addSubview:clotheSubSpressNum];
        
        labelDesc = [[UILabel alloc]init];
        [labelDesc setText:@"提示:租金在归还服装后从押金扣除"];
        [labelDesc setTextColor:RGBCOLOR(255, 51, 51)];
        labelDesc.adjustsFontSizeToFitWidth = YES;
        [labelDesc setFrame:CGRectMake(CGRectGetMaxX(imgProduct.frame)+10, clotheSubSpressNum.bottom+5, iphone_size_scale(200), 30)];
        [labelDesc setFont:font_size(13)];

        [viewBG addSubview:labelDesc];
        
        
        UIImageView * imgLine = [[UIImageView alloc]init];
        [imgLine setBackgroundColor:WWPageLineColor];
        [imgLine setFrame:CGRectMake(10,CGRectGetMaxY(labelDesc.frame)+10, iphone_size_scale(300), 1)];
        [viewBG addSubview:imgLine];
        
        // 底部view
        UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0,viewBG.height-49, MainView_Width, 49)];
        bottonView.backgroundColor = [UIColor blackColor];
        [viewBG addSubview:bottonView];
        // 押金
        otherContentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, bottonView.width-125*kPercenX-20, bottonView.height)];
        otherContentLab.text = @"押金：￥4500";
        otherContentLab.font = font_size(12);
        otherContentLab.textColor = [UIColor whiteColor];
        [bottonView addSubview:otherContentLab];
        
        UIButton * btnSubmit = [[UIButton alloc]init];
        [btnSubmit setFrame:CGRectMake(bottonView.width-125*kPercenX, 0, iphone_size_scale(125), 49)];
        [btnSubmit setBackgroundColor:WWBtnYellowColor];
        [btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:btnSubmit];
        
        
        UIButton * btnCancle = [[UIButton alloc]init];
        [btnCancle setBackgroundImage:[UIImage imageNamed:@"shut-down"] forState:UIControlStateNormal];
        [btnCancle setFrame:CGRectMake(iphone_size_scale(290), 9, 20, 20)];
        [btnCancle addTarget:self action:@selector(Cancle) forControlEvents:UIControlEventTouchUpInside];
        [viewBG addSubview:btnCancle];
        
        
        
        ///////////单位和颜色
        
        scrollView = [[UIScrollView alloc]init];
        [scrollView setFrame:CGRectMake(0, CGRectGetMaxY(imgLine.frame), MainView_Width, iphone_size_scale(155))];
        scrollView.backgroundColor = [UIColor whiteColor];
        [viewBG addSubview:scrollView];
        
        // 添加数量
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, scrollView.bottom, viewBG.width-20, 44)];
        [viewBG addSubview:view];
        UILabel *topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, 1)];
        topLine.backgroundColor = WWPageLineColor;
        [view addSubview:topLine];
        UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
        bottomLine.backgroundColor = WWPageLineColor;
        [view addSubview:bottomLine];
        
        UILabel *rantLab = [[UILabel alloc]initWithFrame:CGRectMake(0, (view.height-13*kPercenX)/2, 100, iphone_size_scale(13))];
        rantLab.textColor = WWSubTitleTextColor;
        rantLab.font = font_size(13);
        rantLab.text = @"租凭数量";
        [view addSubview:rantLab];
        
        UIView *numView = [[UIView alloc]initWithFrame:CGRectMake(view.width-97, (view.height-26)/2, 97, 26)];
        numView.layer.borderColor = WWPageLineColor.CGColor;
        numView.layer.borderWidth = 0.5f;
        [view addSubview:numView];
        UIButton *minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minBtn.tag = 10000;
        minBtn.frame = CGRectMake(0, 0, 31, 26);
        [minBtn setImage:[UIImage imageNamed:@"btn_jian_n"] forState:UIControlStateNormal];
        [minBtn addTarget:self action:@selector(clothesNumBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [numView addSubview:minBtn];
        UIButton *maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maxBtn.tag = 10001;
        maxBtn.frame = CGRectMake(numView.width-31, 0, 31, 26);
        [maxBtn setImage:[UIImage imageNamed:@"btn_jia_n"] forState:UIControlStateNormal];
        [maxBtn addTarget:self action:@selector(clothesNumBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [numView addSubview:maxBtn];
        
        clothesNum = [[UILabel alloc]initWithFrame:CGRectMake(minBtn.right, 0, numView.width-minBtn.width-maxBtn.width, 26)];
        clothesNum.textAlignment = NSTextAlignmentCenter;
        clothesNum.adjustsFontSizeToFitWidth = YES;
        clothesNum.text = @"1";
        clothesNum.textColor = WWContentTextColor;
        clothesNum.font = font_size(13);
        [numView addSubview:clothesNum];
        
    }
    return self;
}

- (void)clothesNumBtnClickEvent:(UIButton *)sender{
    
    if (sender.tag == 10000) {
        num--;
        if (num<=1) {
            clothesNum.text = @"1";
            otherContentLab.text = [NSString stringWithFormat:@"押金：￥%@",clothesDetailDic[@"deposit"]];
            num = 1;
            return;
        }
    }else{
        num++;
    }
    clothesNum.text = [NSString stringWithFormat:@"%d",num];
    int deposit = [clothesDetailDic[@"deposit"] intValue];
    otherContentLab.text = [NSString stringWithFormat:@"押金：￥%d",deposit*num];
}

-(void)showWithProductMsg:(NSDictionary *)dict{
    [self setHidden:NO];
    clothesDetailDic = dict;
    [imgProduct sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
    
    [labelColthSpressNum setText:[NSString stringWithFormat:@"￥%@/天",dict[@"leaseCost"]]];
    
    clotheSubSpressNum.text = [NSString stringWithFormat:@"押金：￥%@/件",dict[@"deposit"]];
    
    otherContentLab.text = [NSString stringWithFormat:@"押金：￥%@",dict[@"deposit"]];
    
    UILabel * labelSize = [[UILabel alloc]init];
    [labelSize setText:@"尺寸"];
    [labelSize setFont:font_size(13)];
    [labelSize setFrame:CGRectMake(10,0, iphone_size_scale(100), 30)];
    [labelSize setTextColor:WWSubTitleTextColor];
    [scrollView addSubview:labelSize];
    
    NSString * strProductColor = dict[@"color"];
    NSString * strProductSize  = dict[@"size"];
    
    NSArray *arrayColor = [strProductColor componentsSeparatedByString:@","];
    NSArray *arraySize  = [strProductSize componentsSeparatedByString:@","];

    
    ////////size单选按钮初始化
    
    NSInteger btnWidth = 10;
    NSInteger btnLineNum = 0;
    NSMutableArray * arrSizeBtn = [[NSMutableArray alloc]init];
    
    for (int i =0; i<arraySize.count; i++) {
        //按钮相关属性设置
        RadioButton * radio = [[RadioButton alloc]init];
        [radio setTitle:arraySize[i] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnYellowColor] forState:UIControlStateSelected];
        [radio setTitleColor:WWSubTitleTextColor forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        radio.layer.cornerRadius = 5;
        radio.layer.borderColor = WWPageLineColor.CGColor;
        radio.layer.borderWidth = 1;
        radio.layer.masksToBounds = YES;

        //按钮尺寸计算
        CGSize titleSize = [arraySize[i] sizeWithFont:radio.titleLabel.font];
        
        //按钮尺寸修正
        titleSize.height = 30;
        titleSize.width += 30;
        
        //如果下一个按钮将置于屏幕外，则换行
        if (btnWidth+titleSize.width<iphone_size_scale(300)) {
            [radio setFrame:CGRectMake(btnWidth, CGRectGetMaxY(labelSize.frame)+btnLineNum*40, titleSize.width, titleSize.height)];
            btnWidth += titleSize.width+10;
        }
        else
        {
            btnLineNum +=1;
            btnWidth = 10;
            [radio setFrame:CGRectMake(btnWidth, CGRectGetMaxY(labelSize.frame)+btnLineNum*40, titleSize.width, titleSize.height)];
        }
        
        [radio addTarget:self action:@selector(userSlectSize:) forControlEvents:UIControlEventValueChanged];

        
        //按钮数组
        [arrSizeBtn addObject:radio];
        
        //设置默认
        if (i==0) {
            [radio setSelected:YES];
            strResultSize = radio.titleLabel.text;
        }
        //设置单选组
        if (i==arraySize.count-1) {
            radio.groupButtons = arrSizeBtn;
        }
        [scrollView addSubview:radio];
    }
    
    
    UIImageView * imgLine = [[UIImageView alloc]init];
    [imgLine setBackgroundColor:WWPageLineColor];
    [imgLine setFrame:CGRectMake(10,CGRectGetMaxY(labelSize.frame)+(btnLineNum+1)*40, iphone_size_scale(300), 1)];
    [scrollView addSubview:imgLine];

    
    UILabel * labelColor = [[UILabel alloc]init];
    [labelColor setText:@"颜色"];
    [labelColor setFont:font_size(13)];
    [labelColor setFrame:CGRectMake(10,CGRectGetMaxY(imgLine.frame), iphone_size_scale(100), 30)];
    [labelColor setTextColor:WWSubTitleTextColor];
    [scrollView addSubview:labelColor];

   
    
    ////////color单选按钮初始化
    
    btnWidth = 10;
    btnLineNum = 0;
    [arrSizeBtn removeAllObjects];
    
    for (int i =0; i<arrayColor.count; i++) {
        //按钮相关属性设置
        RadioButton * radio = [[RadioButton alloc]init];
        [radio setTitle:arrayColor[i] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnYellowColor] forState:UIControlStateSelected];
        [radio setTitleColor:WWSubTitleTextColor forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        radio.layer.cornerRadius = 5;
        radio.layer.borderColor = WWPageLineColor.CGColor;
        radio.layer.borderWidth = 1;
        radio.layer.masksToBounds = YES;
        [radio.titleLabel setFont:font_size(13)];
        //按钮尺寸计算
        CGSize titleSize = [arrayColor[i] sizeWithFont:radio.titleLabel.font];
        
        //按钮尺寸修正
        titleSize.height = 30;
        titleSize.width += 30;
        
        //如果下一个按钮将置于屏幕外，则换行
        if (btnWidth+titleSize.width<iphone_size_scale(300)) {
            [radio setFrame:CGRectMake(btnWidth, CGRectGetMaxY(labelColor.frame)+btnLineNum*40, titleSize.width, titleSize.height)];
            btnWidth += titleSize.width+10;
            
        }
        else
        {
            btnLineNum +=1;
            btnWidth = 10;
            [radio setFrame:CGRectMake(btnWidth, CGRectGetMaxY(labelColor.frame)+btnLineNum*40, titleSize.width, titleSize.height)];
        }
        
        
        [radio addTarget:self action:@selector(userSlectColor:) forControlEvents:UIControlEventValueChanged];

        //按钮数组
        [arrSizeBtn addObject:radio];
        
        //设置默认
        if (i==0) {
            [radio setSelected:YES];
            strResultColor = radio.titleLabel.text;

        }
        //设置单选组
        if (i==arrayColor.count-1) {
            radio.groupButtons = arrSizeBtn;
        }
        [scrollView addSubview:radio];
    }

    [scrollView setContentSize:CGSizeMake(MainView_Width,CGRectGetMaxY(labelColor.frame)+(btnLineNum+1)*40)];
}


#pragma mark - radioResult
-(void) userSlectColor:(RadioButton*)sender
{
    if(sender.selected) {
        strResultColor = sender.titleLabel.text;
        WWLog(@"Selected color: %@", sender.titleLabel.text);
    }
}

-(void)userSlectSize:(RadioButton *)sender{
    if(sender.selected) {
        strResultSize = sender.titleLabel.text;
        WWLog(@"Selected size: %@", sender.titleLabel.text);
    }
}

-(void)Cancle{
    self.hidden = YES;
}

-(void)submit{
    if (self.AddToCart) {
        self.AddToCart(strResultColor,strResultSize,num);
    }
    
}
@end
