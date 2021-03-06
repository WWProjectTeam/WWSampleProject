//
//  WWPublicNavtionBar.m
//  WWExtension
//
//  Created by ww on 15/8/20.
//  Copyright (c) 2015年 王维. All rights reserved.
//

#import "WWPublicNavtionBar.h"
#import "AppDelegate.h"
@implementation WWPublicNavtionBar{
    UIImageView * imageFlag;
    UIButton * btnTitle;
    
    BOOL isSelect;
    
    UIImageView * ClotheSpressNum;
    UILabel * labelSpressNum;
}
@synthesize HomePageNavtionDelegate = _HomePageNavtionDelegate;
//通用初始化方法
-(id)initWithLeftBtn:(BOOL)leftBtnControl
           withTitle:(NSString *)strTitle
        withRightBtn:(BOOL)rightBtnControl
 withRightBtnPicName:(NSString *)picName
    withRightBtnSize:(CGSize)picSize{
    self = [super initWithFrame:CGRectMake(0, 0, MainView_Width, 44+IOS7_Y)];
    
    if (self)
    {
        //设置导航条背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //左侧按钮
        if (leftBtnControl) {
            //返回按钮
            UIButton * btnBack = [[UIButton alloc]init];
            [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnBack setBackgroundImage:[UIImage imageNamed:@"backView"] forState:UIControlStateNormal];
            [btnBack setFrame:CGRectMake(10, IOS7_Y+7, 30, 30)];
            [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnBack];
        }
        
        UILabel * labelTitle = [[UILabel alloc]init];
        [labelTitle setText:strTitle];
        [labelTitle setFrame:CGRectMake(0, IOS7_Y, MainView_Width, 44)];
        [labelTitle setTextColor:RGBCOLOR(20, 20, 20)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setFont:font_navtionTitle];
        
        [self addSubview:labelTitle];
        
        //右侧按钮
        if (rightBtnControl) {
            
            UIButton * btnRight = [[UIButton alloc]init];
            [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnRight setBackgroundImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
            [btnRight setFrame:CGRectMake(MainView_Width-picSize.width-10, IOS7_Y+(44-picSize.height)/2, picSize.width,picSize.height)];
            
            [btnRight addTarget:self action:@selector(rightBtnSelelct) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btnRight];
            
        }
        
        
    }
    return self;
}

//右侧按钮点击方法
-(void)rightBtnSelelct{
    if (self.TapRightButton) {
        self.TapRightButton();
    }
}

-(void)btnBack{
    if (self.TapLeftButton) {
        self.TapLeftButton();
    }
    else
    {
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate.navtionViewControl popViewControllerAnimated:YES];
    }
}


#pragma mark - 首页特殊导航条创建
-(id)initHomePageNavtion:(NSString *)title flay:(BOOL)flay{
    self = [super initWithFrame:CGRectMake(0, 0, MainView_Width, 44+IOS7_Y)];
    
    if (self)
    {
        //设置导航条背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        btnTitle = [[UIButton alloc]init];
        [btnTitle setFrame:CGRectMake(iphone_size_scale(70), IOS7_Y, iphone_size_scale(180), 44)];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitleColor:RGBCOLOR(20, 20, 20) forState:UIControlStateNormal];
        [btnTitle.titleLabel setFont:font_navtionTitle];
        [btnTitle addTarget:self action:@selector(selectTitle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        
        if (flay == YES) {
            imageFlag = [[UIImageView alloc]init];
            [imageFlag setFrame:CGRectMake(iphone_size_scale(180), IOS7_Y+12, 20, 20)];
            [imageFlag setImage:[UIImage imageNamed:@"btn_zksq"]];
            [self addSubview:imageFlag];
        }
      
        
        UIButton * btnUserMsg;
        btnUserMsg = ({
            UIButton * btnRight = [[UIButton alloc]init];
            [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnRight setBackgroundImage:[UIImage imageNamed:@"PBMsg"] forState:UIControlStateNormal];
            [btnRight setFrame:CGRectMake(MainView_Width-50, IOS7_Y+2, 40,40)];
            
            [btnRight addTarget:self action:@selector(homePageRightBtn:) forControlEvents:UIControlEventTouchUpInside];

            
            ClotheSpressNum = [[UIImageView alloc]init];
            [btnRight addSubview:ClotheSpressNum];
            
            labelSpressNum = [[UILabel alloc]init];
            [labelSpressNum setTextColor:[UIColor whiteColor]];
            [labelSpressNum setFont:font_bold_size(10)];
            [labelSpressNum setTextAlignment:NSTextAlignmentCenter];
            [ClotheSpressNum addSubview:labelSpressNum];
            btnRight;
        });
        
        [self addSubview:btnUserMsg];

        
    }
    return self;
}

//首页设置小红点数
-(void)HomePageSetMsgNum:(NSInteger)Num{
    if (Num==0) {
        [ClotheSpressNum setHidden:YES];
        return;
    }
    
    if (Num<10) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xx"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(24), 3, 13, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 13, 13)];
        
        [labelSpressNum setText:[NSString stringWithFormat:@"%d",Num]];
        
        return;
    }
    
    if (Num<100) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xxd"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(22), 3, 19, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 20, 13)];
        
        [labelSpressNum setText:[NSString stringWithFormat:@"%d",Num]];
        
        return;
    }
    
    
    if (Num>=100) {
        [ClotheSpressNum setHidden:NO];
        [ClotheSpressNum setImage:[UIImage imageNamed:@"icon_xxd"]];
        [ClotheSpressNum setFrame:CGRectMake(iphone_size_scale(22), 3, 19, 13)];
        
        [labelSpressNum setFrame:CGRectMake(0, 0, 20, 13)];
        [labelSpressNum setText:@"99+"];
        [labelSpressNum setFont:font_bold_size(8)];
        
        return;
    }
}

-(void)homePageRightBtn:(UIButton *)sender{
    [self.HomePageNavtionDelegate rightBtnSelect];
}

//首页设置标题
-(void)HomePageSetTitle:(NSString *)strTitle{
    CGSize sizef = CGSizeMake(MAXFLOAT, 44);
    
    sizef = [WWUtilityClass boundingRectWithSize:sizef withText:strTitle withFont:font_navtionTitle];
    WWLog(@"HP-TitleSize ---- W:%f H:%f",sizef.width,sizef.height);
    
    if (sizef.width>iphone_size_scale(180)) {
        sizef.width = 180;
    }
    
    [btnTitle setTitle:strTitle forState:UIControlStateNormal];;
    
    [imageFlag setFrame:CGRectMake((MainView_Width-sizef.width)/2+sizef.width, IOS7_Y+12, 20, 20)];
    
    [UIView animateWithDuration:0.1 animations:^{
        imageFlag.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        isSelect = NO;
    }];
}

//设置标题
-(void)selectTitle{
    if (isSelect) {
        [UIView animateWithDuration:0.1 animations:^{
            imageFlag.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            isSelect = NO;
            [self.HomePageNavtionDelegate closeProductType];

        }];
        

    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            imageFlag.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            isSelect = YES;
            [self.HomePageNavtionDelegate openProductType];

        }];
    }
}




@end
