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
    UILabel * labelDesc;
    
    UIScrollView * scrollView;
    
    
    NSString * strResultSize;
    NSString * strResultColor;
}

-(id)initAddToCartPopView{
    self = [super initWithFrame:CGRectMake(0,0,MainView_Width,MainView_Height)];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        
        UIView * viewBG = [[UIView alloc]init];
        [viewBG setBackgroundColor:[UIColor whiteColor]];
        [viewBG setFrame:CGRectMake(0, MainView_Height-iphone_size_scale(285), MainView_Width,iphone_size_scale(285))];
        
        [self addSubview:viewBG];
        
        
        imgProduct = [[UIImageView alloc]init];
        [imgProduct setFrame:CGRectMake(10,MainView_Height-iphone_size_scale(305), iphone_size_scale(100), iphone_size_scale(100))];
        
        imgProduct.layer.cornerRadius = 5;
        imgProduct.layer.masksToBounds = YES;
        [imgProduct setContentMode:UIViewContentModeScaleAspectFill];
        imgProduct.clipsToBounds = YES;
        [self addSubview:imgProduct];

        
        labelColthSpressNum = [[UILabel alloc]init];
        [labelColthSpressNum setText:@"衣柜:共有3件衣服"];
        [labelColthSpressNum setTextColor:WWSubTitleTextColor];
        [labelColthSpressNum setFrame:CGRectMake(CGRectGetMaxX(imgProduct.frame)+10, iphone_size_scale(30), iphone_size_scale(200), 30)];
        [labelColthSpressNum setFont:font_size(13)];
        
        [viewBG addSubview:labelColthSpressNum];
        
        
        labelDesc = [[UILabel alloc]init];
        [labelDesc setText:@"衣柜满三件才能达到借穿条件"];
        [labelDesc setTextColor:WWSubTitleTextColor];
        [labelDesc setFrame:CGRectMake(CGRectGetMaxX(imgProduct.frame)+10, iphone_size_scale(50), iphone_size_scale(200), 30)];
        [labelDesc setFont:font_size(13)];

        [viewBG addSubview:labelDesc];
        
        
        UIImageView * imgLine = [[UIImageView alloc]init];
        [imgLine setBackgroundColor:WWPageLineColor];
        [imgLine setFrame:CGRectMake(10,CGRectGetMaxY(labelDesc.frame)+10, iphone_size_scale(300), 1)];
        [viewBG addSubview:imgLine];
        
        
        
        UIButton * btnSubmit = [[UIButton alloc]init];
        [btnSubmit setFrame:CGRectMake(0, iphone_size_scale(285)-49, MainView_Width, 49)];
        [btnSubmit setBackgroundColor:WWBtnYellowColor];
        [btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
        [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [viewBG addSubview:btnSubmit];
        
        
        UIButton * btnCancle = [[UIButton alloc]init];
        [btnCancle setBackgroundImage:[UIImage imageNamed:@"shut-down"] forState:UIControlStateNormal];
        [btnCancle setFrame:CGRectMake(iphone_size_scale(290), 9, 20, 20)];
        [btnCancle addTarget:self action:@selector(Cancle) forControlEvents:UIControlEventTouchUpInside];
        [viewBG addSubview:btnCancle];
        
        
        
        ///////////单位和颜色
        
        scrollView = [[UIScrollView alloc]init];
        [scrollView setFrame:CGRectMake(0, CGRectGetMaxY(imgLine.frame), MainView_Width, iphone_size_scale(140))];
        [viewBG addSubview:scrollView];
        
    }
    return self;
    

}

-(void)showWithProductMsg:(NSDictionary *)dict{
    [self setHidden:NO];
    
    [imgProduct sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"bg_yfxq"]];
    
    
    labelDesc.text = [NSString stringWithFormat:@"衣柜满%@件才能达到借穿条件",dict[@"wardrobe"]];
    
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
        self.AddToCart(strResultColor,strResultSize);
    }
    
}
@end
