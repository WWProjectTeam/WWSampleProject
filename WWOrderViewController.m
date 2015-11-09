//
//  WWOrderViewController.m
//  WWSampleProject
//
//  Created by push on 15/10/21.
//  Copyright © 2015年 王维. All rights reserved.
//

#import "WWOrderViewController.h"
#import "WWWantRentTableViewCell.h"
#import "WWWantRantModel.h"
#import "WWOrderAddressViewController.h"
#import "WWProductDetailViewController.h"
#import "WWAddRessModel.h"
#import "RadioButton.h"
#import "HTTPClient+Other.h"
// 支付宝支付
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "WWMyOrderViewController.h"

@interface WWOrderViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    WWPublicNavtionBar *navTionBarView;
    NSString *orderId;
    int payId;      // 支付类型
    int invoice;        // 是否需要发票
    int invoiceType;        // 发票类型
}

@property (nonatomic,strong)UIScrollView    *orderBackScrollView;

@property (nonatomic,strong)UITableView     *orderClothesTableView;

@property (nonatomic,strong)UIView          *orderAddressView;  // 收货地址背景

@property (nonatomic,strong)NSMutableArray  *orderClothesArray;

@property (nonatomic,strong)UILabel         *orderOtherContentLab;
@property (nonatomic,strong)UIButton        *orderSettlementBtn;

@property (nonatomic,strong)UIImageView *payArrowImage;
@property (nonatomic,strong)UIView      *payBackView;
@property (nonatomic,strong)UIView      *payDetailView;
@property (nonatomic,strong)UILabel     *paySubLab;        // 详情
@property (nonatomic,strong)UIButton    *weChatBtn;
@property (nonatomic,strong)UIButton    *allPayBtn;

// 用户地址
@property (nonatomic,strong)UIView          *backView;
@property (nonatomic,strong)UILabel         *userName;
@property (nonatomic,strong)UILabel         *userPhone;
@property (nonatomic,strong)UILabel         *userAddRess;

// 押金、租金、清洁费、运费
@property (nonatomic,strong)UIView          *allMoneyView;

// 我要发票
@property (nonatomic,strong)UIView          *receiptView;
@property (nonatomic,strong)UIButton        *receiptBtn;
@property (nonatomic,strong)UIView          *receiptDetailView;
@property (nonatomic,strong)UITextView      *receiptTextView;
@property (nonatomic,strong)UILabel         *receiptTextViewPlacth;
@property (nonatomic,strong)RadioButton     *receoptRadioBtn;

@property (nonatomic,strong)UIImageView      *receiptImageView;

@end

@implementation WWOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WW_BASE_COLOR;
    self.orderClothesArray = [NSMutableArray new];
    // 初始化默认支付方式
    payId = 1;
    // 初始化发票--默认没有
    invoice = 0;
    invoiceType = 0;
    
    // 导航条
    navTionBarView = [[WWPublicNavtionBar alloc]initWithLeftBtn:YES withTitle:@"确认订单" withRightBtn:NO withRightBtnPicName:nil withRightBtnSize:CGSizeZero];
    [self.view addSubview:navTionBarView];
    
    UILabel *navLine = [[UILabel alloc]initWithFrame:CGRectMake(0, navTionBarView.height-0.5f, MainView_Width, 0.5f)];
    navLine.backgroundColor = WW_BASE_COLOR;
    [navTionBarView addSubview:navLine];
    
    //背景view
    self.orderBackScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7_Y+44, MainView_Width, MainView_Height-IOS7_Y-44)];
//    self.orderBackScrollView.bounces = NO;
    self.orderBackScrollView.delegate = self;
    self.orderBackScrollView.showsHorizontalScrollIndicator = NO;
    self.orderBackScrollView.showsVerticalScrollIndicator = NO;
    self.orderBackScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.orderBackScrollView];
    
    
    // 收获地址
    self.orderAddressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 76*kPercenX)];
    self.orderAddressView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.orderAddressView];
    // 线条
    UILabel *upLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.orderAddressView.width, 0.5f)];
    upLine.backgroundColor = WWPageLineColor;
    [self.orderAddressView addSubview:upLine];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.orderAddressView.height-19*kPercenX)/2, iphone_size_scale(15), iphone_size_scale(19))];
    iconImage.image = [UIImage imageNamed:@"map-pointer"];
    [self.orderAddressView addSubview:iconImage];
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.right+10, (self.orderAddressView.height-14*kPercenX)/2, 100, iphone_size_scale(14))];
    promptLab.text = @"添加收货地址";
    promptLab.textColor = RGBCOLOR(20, 20, 20);
    promptLab.font = font_size(14);
    [self.orderAddressView addSubview:promptLab];
    // 方向箭头
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.orderAddressView.width-24*kPercenX, (self.orderAddressView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    arrowImage.image = [UIImage imageNamed:@"check--details"];
    [self.orderAddressView addSubview:arrowImage];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(iconImage.right+10, 1, self.orderAddressView.width-iconImage.width-25-arrowImage.width, self.orderAddressView.height-1)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.orderAddressView addSubview:self.backView];
    
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
    
    self.backView.hidden = YES;
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderBtn.frame = CGRectMake(0, 0, self.orderAddressView.width, self.orderAddressView.height);
    [orderBtn addTarget:self action:@selector(orderClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderAddressView addSubview:orderBtn];
    
    // 加载数据
    for (NSDictionary *dic  in [self.orderDataDic objectForKey:@"clientWardrobes"]) {
        WWWantRantModel *model = [WWWantRantModel initWithClothesRequestData:dic];
        [self.orderClothesArray addObject:model];
    }
    
    self.orderClothesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.orderAddressView.bottom+5, MainView_Width, 70*kPercenX*self.orderClothesArray.count) style:UITableViewStylePlain];
    self.orderClothesTableView.delegate = self;
    self.orderClothesTableView.dataSource = self;
    self.orderClothesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderClothesTableView.backgroundColor = [UIColor redColor];
    self.orderClothesTableView.showsVerticalScrollIndicator = NO;
    self.orderClothesTableView.scrollEnabled = NO;
    [self.orderBackScrollView addSubview:self.orderClothesTableView];
    [self.orderClothesTableView reloadData];
    
    // 出租天数
    UIView *rantDaysView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderClothesTableView.bottom+5, self.orderBackScrollView.width, 40)];
    rantDaysView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:rantDaysView];
    UILabel *rantDaysOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rantDaysView.width, 0.5f)];
    rantDaysOnLine.backgroundColor = WWPageLineColor;
    [rantDaysView addSubview:rantDaysOnLine];
    UILabel *rantDaysUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, rantDaysView.height-0.5f, rantDaysView.width, 0.5f)];
    rantDaysUpLine.backgroundColor = WWPageLineColor;
    [rantDaysView addSubview:rantDaysUpLine];
    UILabel *rantDaysLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, rantDaysView.height)];
    rantDaysLab.text = @"租凭天数";
    rantDaysLab.textColor = WWContentTextColor;
    rantDaysLab.font = font_size(12);
    [rantDaysView addSubview:rantDaysLab];
    UILabel *rantDaysNum = [[UILabel alloc]initWithFrame:CGRectMake(rantDaysView.width-110, 0, 100, rantDaysView.height)];
    rantDaysNum.text = [NSString stringWithFormat:@"%d天",self.days];
    rantDaysNum.textColor = WWContentTextColor;
    rantDaysNum.font = font_size(12);
    rantDaysNum.textAlignment = NSTextAlignmentRight;
    [rantDaysView addSubview:rantDaysNum];
    
    // 押金、租金、清洁费、运费
    self.allMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0, rantDaysView.bottom+5, rantDaysView.width, 110)];
    self.allMoneyView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.allMoneyView];
    UILabel *allMoneyOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.allMoneyView.width, 0.5f)];
    allMoneyOnLine.backgroundColor = WWPageLineColor;
    [self.allMoneyView addSubview:allMoneyOnLine];       // 线条颜色
    UILabel *allMoneyUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.allMoneyView.height-0.5f, self.allMoneyView.width, 0.5f)];
    allMoneyUpLine.backgroundColor = WWPageLineColor;
    [self.allMoneyView addSubview:allMoneyUpLine];       // 线条颜色
    NSInteger maxHeight = 0;
    double deposit = [[self.orderDataDic objectForKey:@"deposit"] doubleValue];
    NSString *depositStr = [NSString stringWithFormat:@"￥%.2f",deposit];
    double leaseCost = [[self.orderDataDic objectForKey:@"leaseCost"] doubleValue]*self.days;
    NSString *leaseCostStr = [NSString stringWithFormat:@"￥%.2f(归还后从押金扣除)",leaseCost];
    NSArray *title = @[@"服装押金",@"租凭费用",@"服装清洁费",@"运费"];
    NSArray *content = @[depositStr,leaseCostStr,@"￥0.00",@"￥0.00"];
    for (int i = 0; i<4; i++) {
        UILabel *moneyTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, maxHeight+10, 100, iphone_size_scale(12))];
        moneyTitle.text = title[i];
        moneyTitle.textColor = RGBCOLOR(102, 102, 102);
        moneyTitle.font = font_size(12);
        [self.allMoneyView addSubview:moneyTitle];
        UILabel *montyNum = [[UILabel alloc]initWithFrame:CGRectMake(self.allMoneyView.width-210, maxHeight+10, 200, iphone_size_scale(12))];
        montyNum.text = content[i];
        montyNum.textColor = RGBCOLOR(224, 162, 28);
        montyNum.font = font_size(12);
        montyNum.textAlignment = NSTextAlignmentRight;
        [self.allMoneyView addSubview:montyNum];
        maxHeight = CGRectGetMaxY(moneyTitle.frame);
    }
    // 我要发票
    self.receiptView = [[UIView alloc]initWithFrame:CGRectMake(0, self.allMoneyView.bottom+5, MainView_Width, 44)];
    self.receiptView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.receiptView];
    UILabel *receiptOnLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.receiptView.width, 0.5f)];
    receiptOnLine.backgroundColor = WWPageLineColor;
    [self.receiptView addSubview:receiptOnLine];       // 线条颜色
    UILabel *receiptLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.receiptView.height-0.5f, self.receiptView.width, 0.5f)];
    receiptLine.backgroundColor = WWPageLineColor;
    [self.receiptView addSubview:receiptLine];
    
    
    self.receiptImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.receiptView.height-15)/2, 15, 15)];
    self.receiptImageView.image = [UIImage imageNamed:@"btn_zf_n@3x"];
    [self.receiptView addSubview:self.receiptImageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.receiptImageView.right+5, 0, 100, 44)];
    label.text = @"我要发票";
    label.textColor = WWContentTextColor;
    label.font = font_size(12);
    [self.receiptView addSubview:label];
    
    self.receiptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.receiptBtn.frame = CGRectMake(0, 0, self.receiptView.width, 44);
//    [self.receiptBtn setTitle:@"我要发票" forState:UIControlStateNormal];
//    [self.receiptBtn setTitleColor:WWContentTextColor forState:UIControlStateNormal];
//    self.receiptBtn.titleLabel.font = font_size(12);
//    [self.receiptBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -270, 0, 0)];
//    [self.receiptBtn setImage:[UIImage imageNamed:@"btn_zf_n@3x"] forState:UIControlStateNormal];
//    [self.receiptBtn setImage:[UIImage imageNamed:@"btn_zf_c@3x"] forState:UIControlStateSelected];
//    [self.receiptBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -280, 0, 0)];
    [self.receiptBtn addTarget:self action:@selector(receiptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.receiptView addSubview:self.receiptBtn];
    
    self.receiptDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.receiptView.bottom, MainView_Width, 180-44)];
    self.receiptDetailView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.receiptDetailView];
    UILabel *receiptUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.receiptDetailView.height-0.5f, self.receiptDetailView.width, 0.5f)];
    receiptUpLine.backgroundColor = WWPageLineColor;
    [self.receiptDetailView addSubview:receiptUpLine];// 线条颜色
    [self userReceipt];
    self.receiptDetailView.hidden = YES;
    
    // 支付
    [self payMentView];
    
    // 底部view
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, MainView_Height-44*kPercenX, MainView_Width, iphone_size_scale(44))];
    bottonView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottonView];
    UILabel *bottonUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainView_Width, 0.5f)];
    bottonUpLine.backgroundColor = WWPageLineColor;
    [bottonView addSubview:bottonUpLine];
    // 运费+次数
    self.orderOtherContentLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, bottonView.width-125*kPercenX-10, bottonView.height)];
    self.orderOtherContentLab.text = [NSString stringWithFormat:@"押金:￥%@",[self.orderDataDic objectForKey:@"deposit"]];
    self.orderOtherContentLab.font = font_size(12);
    self.orderOtherContentLab.textColor = [UIColor whiteColor];
    [bottonView addSubview:self.orderOtherContentLab];
    // 立即拥有
    self.orderSettlementBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.orderSettlementBtn.frame = CGRectMake(bottonView.width-125*kPercenX, 0, iphone_size_scale(125), bottonView.height);
    [self.orderSettlementBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.orderSettlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orderSettlementBtn.titleLabel.font = font_size(14);
    self.orderSettlementBtn.backgroundColor = WWBtnYellowColor;
    [self.orderSettlementBtn setBackgroundImage:[WWUtilityClass imageWithColor:RGBCOLOR(211, 120, 23)] forState:UIControlStateHighlighted];
    [self.orderSettlementBtn addTarget:self action:@selector(orderSettlementBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:self.orderSettlementBtn];
    
    self.orderBackScrollView.contentSize = CGSizeMake(MainView_Width, self.orderAddressView.height+self.orderClothesTableView.height+rantDaysView.height+self.allMoneyView.height+self.receiptView.height+self.payBackView.height+self.payDetailView.height+100);
}

#pragma mark - 我要发票
- (void)receiptBtnClick:(UIButton *)sender{
    if (self.receiptBtn.selected == YES) {
        self.receiptImageView.image = [UIImage imageNamed:@"btn_zf_n@3x"];
        invoice = 0;        // 不需要发票
        self.receiptBtn.selected = NO;
        self.receiptDetailView.hidden = YES;
        self.payBackView.frame = CGRectMake(0, self.receiptView.bottom+5, MainView_Width, 44*kPercenX);
        self.orderBackScrollView.contentSize = CGSizeMake(MainView_Width, self.orderAddressView.height+self.orderClothesTableView.height+40+self.allMoneyView.height+self.receiptView.height+self.payBackView.height+self.payDetailView.height+100);
    }else{
        self.receiptImageView.image = [UIImage imageNamed:@"btn_zf_c@3x"];
        invoice = 1;        // 需要发票
        self.receiptBtn.selected = YES;
        self.receiptDetailView.hidden = NO;
        self.payBackView.frame = CGRectMake(0, self.receiptDetailView.bottom+5, MainView_Width, 44*kPercenX);
        self.orderBackScrollView.contentSize = CGSizeMake(MainView_Width, self.orderAddressView.height+self.orderClothesTableView.height+40+self.allMoneyView.height+self.receiptView.height+self.receiptDetailView.height+self.payBackView.height+self.payDetailView.height+100);
    }
    self.payDetailView.frame = CGRectMake(0, self.payBackView.bottom, MainView_Width, 80*kPercenX);
}

- (void)userReceipt{
    
    self.receiptTextView = [[UITextView alloc]initWithFrame:CGRectMake(30, 10, self.receiptView.width-30, 60)];
    self.receiptTextView.backgroundColor = RGBCOLOR(240, 240, 240);
    self.receiptTextView.textColor = WWSubTitleTextColor;
    self.receiptTextView.font = font_size(11);
    self.receiptTextView.delegate = self;
    self.receiptTextView.returnKeyType = UIReturnKeyDone;
    [self.receiptDetailView addSubview:self.receiptTextView];
    
    self.receiptTextViewPlacth = [[UILabel alloc]initWithFrame:CGRectMake(5, 9, self.receiptTextView.width, 11)];
    self.receiptTextViewPlacth.textColor = WWSubTitleTextColor;
    self.receiptTextViewPlacth.font =[UIFont systemFontOfSize:11.0f];
    self.receiptTextViewPlacth.text = @"请输入发票抬头名称";
    [self.receiptTextView addSubview:self.receiptTextViewPlacth];
    
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(30, self.receiptTextView.bottom+10, 100, iphone_size_scale(12))];
    type.text = @"发票种类";
    type.textColor = WWContentTextColor;
    type.font = font_size(12);
    [self.receiptDetailView addSubview:type];
    
    ////////size单选按钮初始化
    
    NSInteger btnWidth = 30;
    NSInteger btnLineNum = 0;
    NSMutableArray * arrSizeBtn = [[NSMutableArray alloc]init];
    NSArray *arrayType = @[@"明细",@"办公用品"];
    for (int i =0; i<2; i++) {
        //按钮相关属性设置
        RadioButton * radio = [[RadioButton alloc]init];
        [radio setTitle:arrayType[i] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [radio setBackgroundImage:[WWUtilityClass imageWithColor:WWBtnYellowColor] forState:UIControlStateSelected];
        [radio setTitleColor:WWSubTitleTextColor forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        radio.layer.cornerRadius = 5;
        radio.layer.borderColor = WWPageLineColor.CGColor;
        radio.layer.borderWidth = 1;
        radio.layer.masksToBounds = YES;
        radio.tag = i+1;
        //按钮尺寸计算
        CGSize titleSize = [arrayType[i] sizeWithFont:radio.titleLabel.font];
        
        //按钮尺寸修正
        titleSize.height = 25;
        titleSize.width += 25;
        
        //如果下一个按钮将置于屏幕外，则换行
        if (btnWidth+titleSize.width<iphone_size_scale(300)) {
            [radio setFrame:CGRectMake(btnWidth, type.bottom+8, titleSize.width, titleSize.height)];
            btnWidth += titleSize.width+10;
        }
        else
        {
            btnLineNum +=1;
            btnWidth = 10;
            [radio setFrame:CGRectMake(btnWidth, type.bottom+8, titleSize.width, titleSize.height)];
        }
        
        [radio addTarget:self action:@selector(userSlectType:) forControlEvents:UIControlEventValueChanged];
        
        //按钮数组
        [arrSizeBtn addObject:radio];
        
        //设置默认
        if (i==0) {
            [radio setSelected:YES];
//            strResultSize = radio.titleLabel.text;
        }
        //设置单选组
        if (i==arrayType.count-1) {
            radio.groupButtons = arrSizeBtn;
        }
        [self.receiptDetailView addSubview:radio];
    }

    
}

- (void)userSlectType:(RadioButton *)radio{
    invoiceType = radio.tag;
}

#pragma mark - 支付
- (void)payMentView{
    /**
     *  支付
     */
    self.payBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.receiptView.bottom+5, MainView_Width, 44*kPercenX)];
    self.payBackView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.payBackView];
    // 方向箭头
    self.payArrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.payBackView.width-24*kPercenX, (self.payBackView.height-24*kPercenX)/2, 24*kPercenX, 24*kPercenX)];
    self.payArrowImage.image = [UIImage imageNamed:@"check--details1"];
    [self.payBackView addSubview:self.payArrowImage];
    // 上下线条
    UILabel *payUpLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.payBackView.width, 0.5f)];
    payUpLine.backgroundColor = WWPageLineColor;
    [self.payBackView addSubview:payUpLine];
    UILabel *payDownLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.payBackView.height-0.5f , self.payBackView.width, 0.5f)];
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
    self.payDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, self.payBackView.bottom, MainView_Width, 80*kPercenX)];
    self.payDetailView.backgroundColor = [UIColor whiteColor];
    [self.orderBackScrollView addSubview:self.payDetailView];
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
    [weChatView addSubview:self.weChatBtn];
    UIButton *weChat = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    weChat.frame = CGRectMake(0, 0, weChatView.width, weChatView.height);
    [weChat addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    weChat.tag = 20000;
    [weChatView addSubview:weChat];
    
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
    [allPayView addSubview:self.allPayBtn];
    UIButton *allpay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allpay.frame = CGRectMake(0, 0, allPayView.width, allPayView.height);
    [allpay addTarget:self action:@selector(payBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    allpay.tag = 20001;
    [allPayView addSubview:allpay];
    
    self.payDetailView.hidden = YES;

}

- (void)payBtnClickEvent:(UIButton *)sender{
    if (sender.tag == 20000) {      // 微信
        self.allPayBtn.selected = NO;
        self.weChatBtn.selected = YES;
        self.paySubLab.text = @"微信";
        payId = 2;
    }else if (sender.tag == 20001){     // 支付宝
        self.allPayBtn.selected = YES;
        self.weChatBtn.selected = NO;
        self.paySubLab.text = @"支付宝";
        payId = 1;
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
    }else{
        self.payDetailView.hidden = YES;
//        self.orderBackScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.orderClothesTableView reloadData];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderClothesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellString = @"cellId";
    WWWantRentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[WWWantRentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row < self.orderClothesArray.count) {
        WWWantRantModel *model = [self.orderClothesArray objectAtIndex:indexPath.row];
        [cell wantRentClothesReqeuestData:model];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*kPercenX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.orderClothesArray.count) {
        WWWantRantModel *model = [self.orderClothesArray objectAtIndex:indexPath.row];
        WWProductDetailViewController *productDetailVC = [[WWProductDetailViewController alloc]init];
        productDetailVC.strProductId = model.id_s;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
}

// 添加收货地址
- (void)orderClickEvent:(UIButton *)sender{
    WWOrderAddressViewController *addressVC = [[WWOrderAddressViewController alloc]init];
    addressVC.userOrderAddressBlock= ^(WWAddRessModel *model){
        self.backView.hidden = NO;
        orderId = model.addressId;
        self.userName.text = [NSString stringWithFormat:@"收货人：%@",model.userName];
        self.userPhone.text = model.mobile;
        self.userAddRess.text = [NSString stringWithFormat:@"收货地址：%@%@",model.cityStr,model.content];
        CGSize navSize = CGSizeMake(150, 20000.0f);
        navSize = [self.userName.text sizeWithFont:self.userName.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
        self.userName.frame = CGRectMake(0, 10, navSize.width, navSize.height);
        CGSize navSizePhone = CGSizeMake(300, 20000.0f);
        navSizePhone = [self.userPhone.text sizeWithFont:self.userPhone.font constrainedToSize:navSize lineBreakMode:NSLineBreakByCharWrapping];
        self.userPhone.frame = CGRectMake(self.backView.width-navSizePhone.width, 10, navSizePhone.width, navSizePhone.height);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.userAddRess.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.userAddRess.text length])];
        [self.userAddRess setAttributedText:attributedString1];
        [self.userAddRess sizeToFit];
        self.userAddRess.frame =CGRectMake(0, self.userName.bottom+5, 250, 40);
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - 确认支付
- (void)orderSettlementBtnClickEvent:(UIButton *)sender{
    if (orderId == nil) {
        [SVProgressHUD showInfoWithStatus:@"请添加收货地址"];
        return;
    }
    if (invoice != 0) {
        if ([self.receiptTextView.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请填写发票抬头"];
            return;
        }
        if (invoiceType == 0) {
            [SVProgressHUD showInfoWithStatus:@"请填写发票种类"];
            return;
        }
    }
    NSString *wardrobeid = [self.orderDataDic objectForKey:@"wardrobeId"];
    NSString *leaseCost = [self.orderDataDic objectForKey:@"leaseCost"];
    NSString *deposit = [self.orderDataDic objectForKey:@"deposit"];
    double moneyInt = [deposit doubleValue]*100;
    NSString *money = [NSString stringWithFormat:@"%.0f",moneyInt];
    [SVProgressHUD show];
    [FMHTTPClient PostOrderSaveUserId:[WWUtilityClass getNSUserDefaults:UserID] WithwardrobeId:wardrobeid WithaddressId:orderId WithleaseCost:leaseCost WithDeposit:deposit WithPayMethod:payId WithisInvoice:invoice WithinvoiceTitle:self.receiptTextView.text WithinvoiceType:invoiceType WithDays:self.days WithCompletion:^(WebAPIResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.code == WebAPIResponseCodeSuccess) {
                [SVProgressHUD dismiss];
                g_orderId = [response.responseObject objectForKey:@"result"];
                if (payId == 1) {
                    [self alipay:deposit];
                }else{
                    [self sendPay:money];
                }
                
            }else {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"提交订单失败,请重新提交"];
            }
        });
    }];
}

#pragma mark - 代理协议
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.orderBackScrollView.contentOffset = CGPointMake(0, 252);
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int number = (textView.text.length-range.length+text.length) > 0 ? (int)(textView.text.length-range.length+text.length):0;
    NSString *num = [NSString stringWithFormat:@"%d",number];
    if (![num isEqualToString:@"0"]) {
        self.receiptTextViewPlacth.hidden = YES;
    }else{
        self.receiptTextViewPlacth.hidden = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        if (number-1 > 0) {
            self.receiptTextViewPlacth.hidden = YES;
        }else{
            self.receiptTextViewPlacth.hidden = NO;
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark -
#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)alipay:(NSString *)clothesPrice{
    
    NSString *partner = alipay_partner;    //合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。请参考“7.1 如何获得PID与 密钥”
    NSString *seller = alipay_seller;     //支付宝收款账号,手机号码或邮箱格式
    NSString *privateKey = alipay_privateKey     //商户方的私钥,pkcs8 格式。
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"衣优v"; //商品标题
    order.productDescription = @"服装租赁押金"; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",clothesPrice]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"yiyouvSchemes";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] intValue] == 6001) {
                AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
                [appdelegate orderPayFaile];
                
                // 通知--刷新信息
                [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
            }else if ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000){
                
                AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
                [appdelegate orderPaySuccess];
                // 通知--刷新信息
                [[NSNotificationCenter defaultCenter] postNotificationName:WWRefreshUserInformation object:nil];
                WWMyOrderViewController *myorderVC = [[WWMyOrderViewController alloc]init];
                [self.navigationController pushViewController:myorderVC animated:YES];
            }
        }];
        
    }else{
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate orderPayFaile];
    }
}

// 微信支付
- (void)sendPay:(NSString*)money
{
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay:money];
    
    if(dict == nil){
        //错误提示
        [self alert:@"提示信息" msg:@"支付失败"];
        AppDelegate * appdelegate = (AppDelegate * )[UIApplication sharedApplication].delegate;
        [appdelegate orderPayFaile];
        
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
