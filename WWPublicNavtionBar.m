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
}
@synthesize navtionBarDelegate = _navtionBarDelegate;
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
            [btnBack setBackgroundImage:[UIImage imageNamed:@"Public_btnBack.png"] forState:UIControlStateNormal];
            [btnBack setFrame:CGRectMake(kPercenX, IOS7_Y, 44, 44)];
            [btnBack addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnBack];
        }
        
        UILabel * labelTitle = [[UILabel alloc]init];
        [labelTitle setText:strTitle];
        [labelTitle setFrame:CGRectMake(0, IOS7_Y, MainView_Width, 44)];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:18]];
        
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
    [self.navtionBarDelegate rightBtnSelect];
}

-(void)btnBack{
    if([self.navtionBarDelegate respondsToSelector:@selector(leftBtnSelect)]){
        [self.navtionBarDelegate leftBtnSelect];
        
    }
    else
    {
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate.navtionViewControl popViewControllerAnimated:YES];
    }
}


#pragma mark - 首页特殊导航条创建
-(id)initHomePageNavtion{
    self = [super initWithFrame:CGRectMake(0, 0, MainView_Width, 44+IOS7_Y)];
    
    if (self)
    {
        //设置导航条背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        btnTitle = [[UIButton alloc]init];
        [btnTitle setFrame:CGRectMake(iphone_size_scale(70), IOS7_Y, iphone_size_scale(180), 44)];
        [btnTitle setTitle:@"全部" forState:UIControlStateNormal];
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTitle.titleLabel setFont:font_navtionTitle];
        [btnTitle addTarget:self action:@selector(selectTitle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        
        imageFlag = [[UIImageView alloc]init];
        [imageFlag setFrame:CGRectMake(iphone_size_scale(180), IOS7_Y+12, 20, 20)];
        [imageFlag setImage:[UIImage imageNamed:@"btn_zksq"]];
        [self addSubview:imageFlag];
        
        
        UIButton * btnRight = [[UIButton alloc]init];
        [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"PBMsg"] forState:UIControlStateNormal];
        [btnRight setFrame:CGRectMake(MainView_Width-50, IOS7_Y+2, 40,40)];
        
        [btnRight addTarget:self action:@selector(rightBtnSelelct) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnRight];
        
        
    }
    return self;
}

//首页设置小红点数
-(void)HomePageSetMsgNum:(NSInteger)Num{
    
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
