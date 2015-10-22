//
//  WWVIPPackageViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/14.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWVIPPackageViewController.h"
#import "HTTPClient+Other.h"

@interface WWVIPPackageViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    WWPublicNavtionBar *navTionBarView;
}

// 开通时长
@property (nonatomic,strong)UILabel     *openTimeSubLab;        // 详情

@property (nonatomic,strong)NSMutableArray      *openTimeArray;
@property (nonatomic,strong)UIButton            *openVipBtn;

@property (nonatomic,strong)        UIView                  *pickBackView;
@property (nonatomic,strong)        UIPickerView            *pickView;
@property (nonatomic,strong)        UIButton                *pickViewBtn;

@property (nonatomic,strong)UIImageView *payArrowImage;
@property (nonatomic,strong)UIView      *payBackView;
@property (nonatomic,strong)UIView      *payDetailView;
@property (nonatomic,strong)UILabel     *paySubLab;        // 详情
@property (nonatomic,strong)UIButton    *weChatBtn;
@property (nonatomic,strong)UIButton    *allPayBtn;

@end

@implementation WWVIPPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.openTimeArray = [NSMutableArray new];
    navTionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"购买VIP套餐" withRightBtn:NO withRightBtnPicName:@"" withRightBtnSize:CGSizeZero];
    [self.view addSubview:navTionBarView];
    
    [self VIPPageLayout];
    
    [FMHTTPClient GetVIPPriceListWithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                NSArray *resultArr = [response.responseObject objectForKey:@"result"];
                for (NSDictionary *contentDic in resultArr) {
                    [self.openTimeArray addObject:[contentDic objectForKey:@"content"]];
                }
            }
        });
    }];
    // 选择view
    self.pickBackView = [[UIView alloc]initWithFrame:CGRectMake(35, MainView_Height, MainView_Width-70, 250)];
    self.pickBackView.layer.cornerRadius = 5.0f;
    self.pickBackView.layer.masksToBounds = YES;
    self.pickBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickBackView];
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake((self.pickBackView.width-250)/2, 0, 250, 180)];
    [self.pickBackView addSubview:self.pickView];
    self.pickViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pickViewBtn.frame = CGRectMake((self.pickBackView.width-200)/2, self.pickView.bottom+20, 200, 40);
    [self.pickViewBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.pickViewBtn.backgroundColor = WWBtnYellowColor;
    [self.pickViewBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    self.pickViewBtn.layer.masksToBounds = YES;
    self.pickViewBtn.layer.cornerRadius = 3.0;
    [self.pickViewBtn addTarget:self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickBackView addSubview:self.pickViewBtn];
}

- (void)VIPPageLayout{
    UIView *VIPBackView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Y+54, MainView_Width, 60*kPercenX)];
    VIPBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:VIPBackView];
    // vip--ICON
    UIImageView *VIPImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (VIPBackView.height-50*kPercenX)/2, iphone_size_scale(50), iphone_size_scale(50))];
    VIPImage.image = [UIImage imageNamed:@"iocn_vipd"];
    [VIPBackView addSubview:VIPImage];
    // vip套餐
    UILabel *vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIPImage.right+11, 7, 100, iphone_size_scale(16))];
    vipLabel.text = @"VIP套餐";
    vipLabel.font = font_size(16);
    vipLabel.textColor = RGBCOLOR(20, 20, 20);
    [VIPBackView addSubview:vipLabel];
    // vip详情
    UILabel *vipSubLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIPImage.right+11, vipLabel.bottom+10, 100, iphone_size_scale(13))];
    vipSubLabel.text = @"日常装任性换";
    vipSubLabel.font = font_size(13);
    vipSubLabel.textColor = RGBCOLOR(128, 128, 128);
    [VIPBackView addSubview:vipSubLabel];
    // 方向箭头
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(VIPBackView.width-24*kPercenX, (VIPBackView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    arrowImage.image = [UIImage imageNamed:@"check--details"];
    [VIPBackView addSubview:arrowImage];
    // 上下线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIPBackView.width, 1)];
    upLine.backgroundColor = WWPageLineColor;
    [VIPBackView addSubview:upLine];
    UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(0, VIPBackView.height-1, VIPBackView.width, 1)];
    downLine.backgroundColor = WWPageLineColor;
    [VIPBackView addSubview:downLine];
    // 点击事件
    UIButton *vipClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    vipClickBtn.frame = CGRectMake(0, 0, VIPBackView.width, VIPBackView.height);
    [vipClickBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    vipClickBtn.tag = 10000;
    [vipClickBtn addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [VIPBackView addSubview:vipClickBtn];
    
    /**
     *  开通时长
     */
    UIView *openTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, VIPBackView.bottom+10, MainView_Width, 44*kPercenX)];
    openTimeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:openTimeView];
    // 方向箭头
    UIImageView *openTimeArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(openTimeView.width-24*kPercenX, (openTimeView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    openTimeArrowImage.image = [UIImage imageNamed:@"check--details"];
    [openTimeView addSubview:openTimeArrowImage];
    // 上下线条
    UILabel *openTimeUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, openTimeView.width, 1)];
    openTimeUpLine.backgroundColor = WWPageLineColor;
    [openTimeView addSubview:openTimeUpLine];
    UILabel *openTimeDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, openTimeView.height-1, openTimeView.width, 1)];
    openTimeDownLine.backgroundColor = WWPageLineColor;
    [openTimeView addSubview:openTimeDownLine];
    //openTimeLabel
    UILabel *openTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, (openTimeView.height-14*kPercenX)/2, 100, 14*kPercenX)];
    openTimeLab.text = @"开通时长";
    openTimeLab.textColor = RGBCOLOR(20, 20, 20);
    openTimeLab.font = font_size(14);
    [openTimeView addSubview:openTimeLab];
    //openTimeSubLabel
    self.openTimeSubLab = [[UILabel alloc]initWithFrame:CGRectMake(openTimeArrowImage.left-200, (openTimeView.height-14*kPercenX)/2, 200, 14*kPercenX)];
    self.openTimeSubLab.textAlignment = NSTextAlignmentRight;
    self.openTimeSubLab.text = @"请选择";
    self.openTimeSubLab.textColor = RGBCOLOR(128, 128, 128);
    self.openTimeSubLab.font = font_size(14);
    [openTimeView addSubview:self.openTimeSubLab];
    // 点击事件
    UIButton *openTimeClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openTimeClickBtn.frame = CGRectMake(0, 0, openTimeView.width, openTimeView.height);
    [openTimeClickBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    openTimeClickBtn.tag = 10001;
    [openTimeClickBtn addTarget:self action:@selector(buttonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [openTimeView addSubview:openTimeClickBtn];
    
    /**
     *  支付
     */
    self.payBackView = [[UIView alloc]initWithFrame:CGRectMake(0, openTimeView.bottom+10, MainView_Width, 44*kPercenX)];
    self.payBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.payBackView];
    // 方向箭头
    self.payArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.payBackView.width-24*kPercenX, (self.payBackView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    self.payArrowImage.image = [UIImage imageNamed:@"check--details1"];
    [self.payBackView addSubview:self.payArrowImage];
    // 上下线条
    UILabel *payUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.payBackView.width, 1)];
    payUpLine.backgroundColor = WWPageLineColor;
    [self.payBackView addSubview:payUpLine];
    UILabel *payDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.payBackView.height-1, self.payBackView.width, 1)];
    payDownLine.backgroundColor = WWPageLineColor;
    [self.payBackView addSubview:payDownLine];
    //payLabel
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
    payLabel.text = @"支付方式";
    payLabel.textColor = RGBCOLOR(20, 20, 20);
    payLabel.font = font_size(14);
    [self.payBackView addSubview:payLabel];
    //paySubLabel;
    self.paySubLab = [[UILabel alloc]initWithFrame:CGRectMake(self.payArrowImage.left-100, (self.payBackView.height-14*kPercenX)/2, 100, 14*kPercenX)];
    self.paySubLab.textAlignment = NSTextAlignmentRight;
    self.paySubLab.text = @"支付宝";
    self.paySubLab.textColor = RGBCOLOR(128, 128, 128);
    self.paySubLab.font = font_size(14);
    [self.payBackView addSubview:self.paySubLab];
    // 点击事件
    UIButton *payClickBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    payClickBtn.frame = CGRectMake(0, 0, self.payBackView.width, self.payBackView.height);
    [payClickBtn setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnStateHighlightedColor] forState:UIControlStateHighlighted];
    [payClickBtn addTarget:self action:@selector(payClickEvnet:) forControlEvents:UIControlEventTouchUpInside];
    [self.payBackView addSubview:payClickBtn];
    
#pragma mark --- 支付选择
    self.payDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.payBackView.bottom, MainView_Width, 60*kPercenX)];
    self.payDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.payDetailView];
    // 微信
    UIView *weChatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, self.payDetailView.height/2)];
    weChatView.backgroundColor = [UIColor whiteColor];
    [self.payDetailView addSubview:weChatView];
    // 图标
    UIImageView *weChaticonImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (weChatView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
    weChaticonImage.image = [UIImage imageNamed:@"微信"];
    [weChatView addSubview:weChaticonImage];
    // 文字
    UILabel *weChatLab = [[UILabel alloc]initWithFrame:CGRectMake(weChaticonImage.right+5, (weChatView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
    weChatLab.text = @"微信";
    weChatLab.textColor = WWContentTextColor;
    weChatLab.font = font_size(13);
    [weChatView addSubview:weChatLab];
    // 支付选择按钮
    self.weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.weChatBtn.frame = CGRectMake(weChatView.width-8-14*kPercenX, (weChatView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
    [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
    [self.weChatBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
    [self.weChatBtn addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.weChatBtn.tag = 20000;
    [weChatView addSubview:self.weChatBtn];
    
    // 支付宝
    UIView *allPayView = [[UIView alloc]initWithFrame:CGRectMake(0, weChatView.bottom, MainView_Width, self.payDetailView.height/2)];
    allPayView.backgroundColor = [UIColor whiteColor];
    [self.payDetailView addSubview:allPayView];
    // 图标
    UIImageView *allPayIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10*kPercenX, (allPayView.height-27*kPercenX)/2, 27*kPercenX, 27*kPercenX)];
    allPayIconImage.image = [UIImage imageNamed:@"支付宝"];
    [allPayView addSubview:allPayIconImage];
    // 支付宝上下线条
    UILabel *allPayUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, allPayView.width, 1)];
    allPayUpLine.backgroundColor = WWPageLineColor;
    [allPayView addSubview:allPayUpLine];
    UILabel *allPayDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, allPayView.height-1, allPayView.width, 1)];
    allPayDownLine.backgroundColor = WWPageLineColor;
    [allPayView addSubview:allPayDownLine];
    // 文字
    UILabel *allPayLab = [[UILabel alloc]initWithFrame:CGRectMake(allPayIconImage.right+5, (allPayView.height-13*kPercenX)/2, 50, iphone_size_scale(13))];
    allPayLab.textAlignment = NSTextAlignmentCenter;
    allPayLab.text = @"支付宝";
    allPayLab.textColor = WWContentTextColor;
    allPayLab.font = font_size(13);
    [allPayView addSubview:allPayLab];
    // 支付选择按钮
    self.allPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allPayBtn.frame = CGRectMake(allPayView.width-8-14*kPercenX, (allPayView.height-14*kPercenX)/2, iphone_size_scale(14), iphone_size_scale(14));
    [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
    [self.allPayBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
    self.allPayBtn.selected = YES;
    [self.allPayBtn addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.allPayBtn.tag = 20001;
    [allPayView addSubview:self.allPayBtn];
    
    self.payDetailView.hidden = YES;
    
    // 支付
    self.openVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openVipBtn.frame = CGRectMake(0, self.payBackView.bottom+15, MainView_Width, 44);
    [self.openVipBtn setTitle:@"开通VIP" forState:UIControlStateNormal];
    self.openVipBtn.backgroundColor = WWBtnYellowColor;
    [self.openVipBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    [self.openVipBtn addTarget:self action:@selector(openTimeSenderSever:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openVipBtn];
}

- (void)payBtnClickEvent:(UIButton *)sender{
    if (sender.tag == 20000) {      // 微信
        self.allPayBtn.selected = NO;
        self.weChatBtn.selected = YES;
        self.paySubLab.text = @"微信";
    }else if (sender.tag == 20001){     // 支付宝
        self.allPayBtn.selected = YES;
        self.weChatBtn.selected = NO;
        self.paySubLab.text = @"支付宝";
    }
    [self payDetailViewHidden:NO];
}

// 支付触发事件
- (void)payClickEvnet:(UIButton *)sender{
    if (self.payDetailView.hidden == YES) {
        [self payDetailViewHidden:YES];
    }else{
        [self payDetailViewHidden:NO];
    }
}

- (void)payDetailViewHidden:(BOOL)bol{
    [UIView animateWithDuration:0.5 animations:^{
        self.payArrowImage.transform = CGAffineTransformRotate(self.payArrowImage.transform, -M_PI);//旋转180度
    }];
    if (bol == YES) {
        self.payDetailView.hidden = NO;
        self.openVipBtn.frame = CGRectMake(0, self.payDetailView.bottom+15, MainView_Width, 44);
    }else{
        self.payDetailView.hidden = YES;
         self.openVipBtn.frame = CGRectMake(0, self.payBackView.bottom+15, MainView_Width, 44);
    }
}


// 触发点击事件
- (void)buttonClickEvent:(UIButton *)sender{
    if (sender.tag == 10000) {
        
    }else if(sender.tag == 10001){
        [UIView animateWithDuration:0.3 animations:^{
            self.pickBackView.frame = CGRectMake(35, MainView_Height-250, MainView_Width-70, 250);
        }];
        self.pickView.dataSource = self;
        self.pickView.delegate = self;
    }
}

#pragma mark UIPickerView代理

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.openTimeArray.count;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    self.openTimeSubLab.text = [self.openTimeArray objectAtIndex:row];
    return [self.openTimeArray objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.openTimeSubLab.text = [self.openTimeArray objectAtIndex:row];
}

- (void)pickerViewBtnClick:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickBackView.frame = CGRectMake(35, MainView_Height, MainView_Width-70, 250);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        self.pickBackView.frame = CGRectMake(35, MainView_Height, MainView_Width-70, 250);
    }];
}

#pragma mark -- 开通VIP，请求网络
- (void)openTimeSenderSever:(UIButton *)sender{
    
    
    [FMHTTPClient PostBuyVipUserId:[WWUtilityClass getNSUserDefaults:UserID] andPackageId:@"" andMoney:@"" andMethod:@"" WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
